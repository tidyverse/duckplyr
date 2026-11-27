#!/bin/bash
# Adapted from r-dbi/RSQLite's .github/actions/cran-submit/cran-submit-test.sh at c110c21e2 (branch claude/rsqlite-cran-release).
# Copied from duckdb/duckdb-r's scripts/cran-submit-test.sh at 86ac17f6b.
# Check .github/actions/cran-submit/cran-submit.sh offline, against a fake CRAN submission form on 127.0.0.1: nothing reaches CRAN.
# Process: the header of .github/workflows/cran-submission.yaml
#
#   1. `upload` sends the two POSTs of `devtools:::upload_cran()`, field for field and in order,
#      with the tarball's own bytes, the maintainer from DESCRIPTION and the comment `<package> <version>`,
#      and reports the next step: the confirmation e-mail.
#   2. A 404 reads CRAN's maintenance message from the index page and fails with it.
#   3. An upload without `pkg_id`, a confirmation without `submit=1`, a 500 and an unreachable form
#      each fail before the next POST, with a "How to resolve" section in the step summary.
#   4. A misnamed tarball, and a file that is no tarball, fail before anything is sent.
#   5. `upload --dry-run` sends nothing, and prints and reports every field a real run would post.
#   6. With R and pigz on the PATH: `tarball` builds a package, recompresses it with zopfli
#      and verifies it; a package that does not build, and a recompression that does not match,
#      fail with a "How to resolve" section; the built tarball then uploads as in 1.
#   7. Both stages name the commit: in CI the one checked out, linked, with a warning when it
#      is not the run's; outside CI the package directory's HEAD, unlinked, and `upload` none.
#
# The fake form answers as CRAN's does: the upload redirects to `index2.php?pkg_id=...`,
# the confirmation to `index2.php?submit=1`, and the server records every field it receives.
#
# Usage:
#   .github/actions/cran-submit/cran-submit-test.sh
#
# Environment variables:
#   KEEP - if non-empty, do not delete the scratch directory

set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
SCRATCH=$(mktemp -d)
SERVER_PID=
cleanup() {
  [ -z "$SERVER_PID" ] || kill "$SERVER_PID" 2>/dev/null || true
  [ -n "${KEEP:-}" ] || rm -rf "$SCRATCH"
}
trap cleanup EXIT
[ -z "${KEEP:-}" ] || echo "scratch: $SCRATCH"

pass=0
fail=0
ok() { pass=$((pass + 1)); echo "  ok   $1"; }
no() { fail=$((fail + 1)); echo "  FAIL $1"; }
is() { if [ "$2" = "$3" ]; then ok "$1"; else no "$1"; echo "         actual: $2"; echo "       expected: $3"; fi; }
has() { case "$2" in *"$3"*) ok "$1" ;; *) no "$1"; echo "       missing: $3"; echo "        in: $2" ;; esac; }
hasnt() { case "$2" in *"$3"*) no "$1"; echo "       present: $3" ;; *) ok "$1" ;; esac; }

# --- the fake submission form ------------------------------------------------
#
# `mode` says how the form answers: ok, maintenance, nopkgid, nosubmit, error500.
# Every request appends to `requests`: one line per field, then one per request.

cat >"$SCRATCH/server.py" <<'EOF'
import email.parser, email.policy, hashlib, http.server, os, sys

scratch = sys.argv[1]


def mode():
    with open(os.path.join(scratch, "mode")) as f:
        return f.read().strip()


def record(line):
    with open(os.path.join(scratch, "requests"), "a", encoding="utf-8") as f:
        f.write(line + "\n")


class Form(http.server.BaseHTTPRequestHandler):
    def log_message(self, *args):
        pass

    def page(self, code, text):
        body = (
            "<html><head><title>CRAN package Submission</title></head>\n"
            "<body><h1>Submit package to CRAN</h1>\n<p>%s</p>\n</body></html>\n" % text
        ).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def redirect(self, query):
        self.send_response(302)
        self.send_header("Location", "/cransubmit/index2.php?" + query)
        self.send_header("Content-Length", "0")
        self.end_headers()

    def do_GET(self):
        record("GET %s" % self.path)
        if self.path == "/cransubmit/index.php":
            self.page(200, "The submission form is closed for maintenance until 2 November.")
        else:
            self.page(200, "Page %s" % self.path)

    def do_POST(self):
        body = self.rfile.read(int(self.headers["Content-Length"]))
        head = b"Content-Type: " + self.headers["Content-Type"].encode() + b"\r\n\r\n"
        msg = email.parser.BytesParser(policy=email.policy.HTTP).parsebytes(head + body)
        names = []
        for part in msg.iter_parts():
            name = part.get_param("name", header="content-disposition")
            names.append(name)
            data = part.get_payload(decode=True)
            if part.get_filename() is not None:
                record("field %s file=%s type=%s sha256=%s" % (
                    name, part.get_filename(), part.get_content_type(), hashlib.sha256(data).hexdigest()))
            else:
                record("field %s=%s" % (name, data.decode("utf-8")))
        record("POST %s %s" % (self.path, ",".join(names)))
        m = mode()
        if m == "maintenance":
            return self.page(404, "Not Found")
        if m == "error500":
            return self.page(500, "Internal Server Error")
        if "upload" in names:
            if m == "nopkgid":
                return self.page(200, "The maintainer&#39;s e-mail address could not be verified.")
            return self.redirect("pkg_id=XYZ123")
        if m == "nosubmit":
            return self.page(200, "Please confirm that you have read the policy.")
        return self.redirect("submit=1")


srv = http.server.HTTPServer(("127.0.0.1", 0), Form)
with open(os.path.join(scratch, "port.tmp"), "w") as f:
    f.write(str(srv.server_port))
os.rename(os.path.join(scratch, "port.tmp"), os.path.join(scratch, "port"))
srv.serve_forever()
EOF

echo ok >"$SCRATCH/mode"
mkdir "$SCRATCH/srv"
(cd "$SCRATCH/srv" && exec python3 -I "$SCRATCH/server.py" "$SCRATCH") &
SERVER_PID=$!
for _ in $(seq 100); do
  [ -s "$SCRATCH/port" ] && break
  sleep 0.1
done
[ -s "$SCRATCH/port" ] || {
  echo "the fake form did not start" >&2
  exit 1
}
FORM=http://127.0.0.1:$(cat "$SCRATCH/port")/cransubmit/index2.php
# The local form is reached directly, never through a proxy.
export no_proxy=127.0.0.1 NO_PROXY=127.0.0.1

# What a run on GitHub sets. The commit is this checkout's HEAD,
# as in a job that checked out the commit the run was started on.
export GITHUB_SERVER_URL=https://github.example GITHUB_REPOSITORY=tidyverse/duckplyr GITHUB_REF_NAME=release-x
GITHUB_SHA=$(git -C "$HERE/../../.." rev-parse HEAD 2>/dev/null || echo 0123456789abcdef0123456789abcdef01234567)
export GITHUB_SHA
LINK="Commit [\`${GITHUB_SHA:0:10}\`](https://github.example/tidyverse/duckplyr/commit/$GITHUB_SHA) on \`release-x\`."

SUMMARY=$SCRATCH/summary.md
# Runs the script as a workflow step would, against the fake form;
# prints its output and its exit status.
run() {
  local rc=0 out
  : >"$SUMMARY"
  : >"$SCRATCH/requests"
  out=$(GITHUB_ACTIONS=true GITHUB_STEP_SUMMARY=$SUMMARY GITHUB_OUTPUT=$SCRATCH/output \
    CRAN_SUBMISSION_URL=${URL:-$FORM} "$HERE/cran-submit.sh" "$@" 2>&1) || rc=$?
  printf '%s\nexit %s\n' "$out" "$rc"
}
requests() { cat "$SCRATCH/requests"; }
field() { sed -n "s/^field $1=//p" "$SCRATCH/requests"; }

# --- the fixture -------------------------------------------------------------
#
# A package tarball as R CMD build writes it, by hand: a DESCRIPTION with a
# `Maintainer:` field, a non-ASCII name, and a continuation line.

mkdir -p "$SCRATCH/pkg/fakepkg"
cat >"$SCRATCH/pkg/fakepkg/DESCRIPTION" <<'EOF'
Package: fakepkg
Version: 1.0.1
Title: A Package That Is Never Submitted
Description: Stands in for the package in .github/actions/cran-submit/cran-submit-test.sh,
    against a fake submission form.
License: MIT + file LICENSE
Encoding: UTF-8
Maintainer: Jane Müller <jane@example.org>
EOF
TARBALL=$SCRATCH/pkg/fakepkg_1.0.1.tar.gz
tar -czf "$TARBALL" -C "$SCRATCH/pkg" fakepkg
SHA=$(sha256sum "$TARBALL" | cut -d' ' -f1)

# --- 1: a submission -----------------------------------------------------------

echo
echo "== upload and confirm, as devtools:::upload_cran() does"
echo ok >"$SCRATCH/mode"
out=$(run upload "$TARBALL")
has "it succeeds" "$out" "exit 0"
is "two POSTs, upload fields first, in devtools' order" "$(grep '^POST' "$SCRATCH/requests")" \
  "POST /cransubmit/index2.php pkg_id,name,email,uploaded_file,comment,upload
POST /cransubmit/index2.php pkg_id,name,email,policy_check,submit"
is "pkg_id is empty, then the one from the redirect" "$(field pkg_id)" "
XYZ123"
is "name, twice, from Maintainer:" "$(field name)" "Jane Müller
Jane Müller"
is "email, twice, from Maintainer:" "$(field email)" "jane@example.org
jane@example.org"
is "uploaded_file is the tarball, as application/x-gzip" "$(sed -n 's/^field uploaded_file //p' "$SCRATCH/requests")" \
  "file=fakepkg_1.0.1.tar.gz type=application/x-gzip sha256=$SHA"
is "comment is the single line <package> <version>" "$(field comment)" "fakepkg 1.0.1"
is "upload" "$(field upload)" "Upload package"
is "policy_check" "$(field policy_check)" "1/"
is "submit" "$(field submit)" "Submit package"
has "the log prints the pkg_id" "$out" "XYZ123"
has "and the sha256" "$out" "$SHA"
has "and groups the stages" "$out" "::group::Confirm: POST the submission"
has "it ends with a notice" "$out" "::notice title=Submitted to CRAN::fakepkg 1.0.1"
summary=$(cat "$SUMMARY")
has "the summary names the tarball" "$summary" "fakepkg_1.0.1.tar.gz"
has "and links the commit" "$summary" "### Upload to CRAN

- $LINK"
has "the log names the commit" "$out" "$(printf '  %-20s %s' commit: "$GITHUB_SHA (release-x)")"
has "and the next step" "$summary" "**Next step:** CRAN e-mailed jane@example.org; click the confirmation link in that e-mail to finish the submission."
hasnt "and no failure" "$summary" "How to resolve"

# --- 2: maintenance ------------------------------------------------------------

echo
echo "== a 404 reads CRAN's message from the index page"
echo maintenance >"$SCRATCH/mode"
out=$(run upload "$TARBALL")
has "it fails" "$out" "exit 1"
has "with an error annotation" "$out" "::error title=CRAN submissions are closed::"
has "showing CRAN's message" "$out" "closed for maintenance until 2 November"
is "after one POST and a GET of index.php" "$(grep -v '^field' "$SCRATCH/requests")" \
  "POST /cransubmit/index2.php pkg_id,name,email,uploaded_file,comment,upload
GET /cransubmit/index.php"
summary=$(cat "$SUMMARY")
has "the summary says the upload failed" "$summary" "### Upload: failed"
has "with CRAN's message" "$summary" "closed for maintenance until 2 November"
has "and how to resolve it" "$summary" "#### How to resolve"
has "which is to wait" "$summary" "Wait until CRAN reopens"

# --- 3: the other failures -----------------------------------------------------

echo
echo "== an upload without pkg_id stops before the confirmation"
echo nopkgid >"$SCRATCH/mode"
out=$(run upload "$TARBALL")
has "it fails" "$out" "exit 1"
has "naming the missing pkg_id" "$out" "::error title=No pkg_id from CRAN::"
has "and showing CRAN's page, entities decoded" "$out" "The maintainer's e-mail address could not be verified."
is "after one POST" "$(grep -c '^POST' "$SCRATCH/requests")" 1
summary=$(cat "$SUMMARY")
has "the summary resolves it" "$summary" "#### How to resolve"
has "against devtools" "$summary" "devtools:::upload_cran()"
has "and CRAN's form" "$summary" "https://cran.r-project.org/submit.html"

echo
echo "== a confirmation without submit=1 fails"
echo nosubmit >"$SCRATCH/mode"
out=$(run upload "$TARBALL")
has "it fails" "$out" "exit 1"
has "naming the step" "$out" "::error title=CRAN did not confirm the submission::"
is "after both POSTs" "$(grep -c '^POST' "$SCRATCH/requests")" 2
has "the summary says the confirmation failed" "$(cat "$SUMMARY")" "### Confirm: failed"

echo
echo "== a 500 fails with the status"
echo error500 >"$SCRATCH/mode"
out=$(run upload "$TARBALL")
has "it fails" "$out" "exit 1"
has "with the status" "$out" "answered HTTP 500"
is "after one POST" "$(grep -c '^POST' "$SCRATCH/requests")" 1
has "the summary resolves it" "$(cat "$SUMMARY")" "Check the maintainer fields"

echo
echo "== an unreachable form fails"
out=$(URL=http://127.0.0.1:1/cransubmit/index2.php run upload "$TARBALL")
has "it fails" "$out" "exit 1"
has "saying so" "$out" "::error title=CRAN could not be reached::"

# --- 4: a misnamed tarball -----------------------------------------------------

echo
echo "== a misnamed tarball is not sent"
echo ok >"$SCRATCH/mode"
cp "$TARBALL" "$SCRATCH/pkg/fakepkg.tar.gz"
out=$(run upload "$SCRATCH/pkg/fakepkg.tar.gz")
has "it fails" "$out" "exit 1"
has "naming the expected name" "$out" "fakepkg_1.0.1.tar.gz"
is "and sends nothing" "$(requests)" ""

echo
echo "== a tarball that is not one is not sent"
printf 'not a tarball' >"$SCRATCH/pkg/fakepkg_9.9.tar.gz"
out=$(run upload "$SCRATCH/pkg/fakepkg_9.9.tar.gz")
has "it fails" "$out" "exit 1"
has "saying so" "$out" "::error title=The tarball cannot be read::"
is "and sends nothing" "$(requests)" ""

# --- 5: a dry run --------------------------------------------------------------

echo
echo "== a dry run sends nothing and shows what it would"
echo ok >"$SCRATCH/mode"
out=$(run upload --dry-run "$TARBALL")
has "it succeeds" "$out" "exit 0"
is "the form receives no request" "$(requests)" ""
has "the log lists the uploaded file" "$out" \
  "$(printf '  %-20s %s' uploaded_file: "fakepkg_1.0.1.tar.gz (application/x-gzip, $(wc -c <"$TARBALL" | tr -d ' ') bytes, sha256 $SHA)")"
has "and the confirmation's fields" "$out" "$(printf '  %-20s %s' policy_check: 1/)"
has "with a notice" "$out" "::notice title=Dry run::Nothing was sent to CRAN."
summary=$(cat "$SUMMARY")
has "the summary says it is a dry run" "$summary" "### Upload to CRAN: dry run"
has "and nothing was sent" "$summary" "Nothing was sent to CRAN. A real run posts this to $FORM:"
has "with every upload field" "$summary" "   - \`pkg_id\`: empty
   - \`name\`: \`Jane Müller\`
   - \`email\`: \`jane@example.org\`
   - \`uploaded_file\`: \`fakepkg_1.0.1.tar.gz\`, \`application/x-gzip\`"
has "the comment" "$summary" "   - \`comment\`: \`fakepkg 1.0.1\`"
has "and every confirmation field" "$summary" "   - \`policy_check\`: \`1/\`
   - \`submit\`: \`Submit package\`"
has "and how to dispatch the real run" "$summary" "\`gh workflow run cran-submission.yaml --repo tidyverse/duckplyr --ref release-x\`"
hasnt "and no next step of a real submission" "$summary" "click the confirmation link"
out=$(run upload --dry-run "$SCRATCH/pkg/fakepkg.tar.gz")
has "a misnamed tarball still fails" "$out" "::error title=The tarball is misnamed::"
is "and sends nothing" "$(requests)" ""

# --- 6: the tarball ------------------------------------------------------------

echo
if ! command -v R >/dev/null || ! command -v pigz >/dev/null; then
  echo "== skipped: building and recompressing needs R and pigz on the PATH"
else
  echo "== build, recompress with zopfli, verify"
  mkdir -p "$SCRATCH/src/zpkg/R"
  cat >"$SCRATCH/src/zpkg/DESCRIPTION" <<'EOF'
Package: zpkg
Version: 0.2.0
Title: A Package That Is Never Submitted Either
Description: Built by .github/actions/cran-submit/cran-submit-test.sh.
Authors@R: person("Jane", "Müller", , "jane@example.org", role = c("aut", "cre"))
License: GPL-3
Encoding: UTF-8
EOF
  echo 'export(zf)' >"$SCRATCH/src/zpkg/NAMESPACE"
  for i in $(seq 200); do echo "zf$i <- function(x) x + $i # padding that compresses"; done >"$SCRATCH/src/zpkg/R/zf.R"
  echo 'zf <- function(x) x' >>"$SCRATCH/src/zpkg/R/zf.R"
  out=$(run tarball "$SCRATCH/out" "$SCRATCH/src/zpkg")
  has "it succeeds" "$out" "exit 0"
  Z=$SCRATCH/out/zpkg_0.2.0.tar.gz
  if [ -f "$Z" ]; then ok "the zopfli tarball is where it was asked"; else no "the zopfli tarball is where it was asked"; fi
  if gzip -t "$Z" 2>/dev/null; then ok "it passes gzip -t"; else no "it passes gzip -t"; fi
  has "the log names the stages" "$out" "::group::Verify: gzip -t, tar -tzf, the tar stream"
  has "and compares the entries" "$out" "the same 4 entries as the gzip tarball"
  is "the step outputs" "$(grep -v '^sha256=' "$SCRATCH/output")" "package=zpkg
version=0.2.0
tarball=$Z"
  summary=$(cat "$SUMMARY")
  plain=$(sed -n 's/^  gzip size: *\([0-9]*\) bytes.*/\1/p' <<<"$out")
  zsize=$(wc -c <"$Z" | tr -d ' ')
  # The saving, computed here in integer arithmetic: tenths of a percent, rounded.
  tenths=$(((plain - zsize) * 2000 / plain))
  tenths=$(((tenths + 1) / 2))
  sizes="$plain → $zsize bytes (−$((tenths / 10)).$((tenths % 10))%)"
  has "the log gives both sizes and the saving" "$out" "$sizes"
  has "the summary too" "$summary" "Recompressed with zopfli (\`pigz -11\`): $sizes, in "
  # A workflow command escapes the % sign.
  has "and the notice" "$out" "::notice title=CRAN tarball::zpkg_0.2.0.tar.gz: ${sizes//%/%25} with zopfli"
  has "and the sha256" "$summary" "$(sha256sum "$Z" | cut -d' ' -f1)"
  has "and links the commit under its heading" "$summary" "## CRAN submission

$LINK"
  has "the log names the commit" "$out" "$(printf '  %-20s %s' commit: "$GITHUB_SHA (release-x)")"

  echo
  echo "== the built tarball uploads"
  out=$(run upload "$Z")
  has "it succeeds" "$out" "exit 0"
  is "with the maintainer R CMD build wrote" "$(field name)" "Jane Müller
Jane Müller"
  is "and the comment" "$(field comment)" "zpkg 0.2.0"

  echo
  echo "== outside CI, the commit is the package directory's HEAD, unlinked"
  git -C "$SCRATCH/src/zpkg" init -q
  git -C "$SCRATCH/src/zpkg" add -A
  git -C "$SCRATCH/src/zpkg" -c user.name=t -c user.email=t@example.org commit -q -m zpkg
  ZHEAD=$(git -C "$SCRATCH/src/zpkg" rev-parse HEAD)
  out=$(
    unset GITHUB_SHA GITHUB_REPOSITORY GITHUB_SERVER_URL GITHUB_REF_NAME
    run tarball "$SCRATCH/out4" "$SCRATCH/src/zpkg"
  )
  has "it succeeds" "$out" "exit 0"
  summary=$(cat "$SUMMARY")
  has "the summary names the commit" "$summary" "## CRAN submission

Commit \`${ZHEAD:0:10}\`."
  hasnt "without a link" "$summary" "/commit/"
  out=$(
    unset GITHUB_SHA GITHUB_REPOSITORY GITHUB_SERVER_URL GITHUB_REF_NAME
    run upload "$Z"
  )
  has "an upload outside CI succeeds" "$out" "exit 0"
  hasnt "and names no commit" "$(cat "$SUMMARY")" "Commit"

  echo
  echo "== a checkout at another commit than the run's is named, with a warning"
  out=$(run tarball "$SCRATCH/out5" "$SCRATCH/src/zpkg")
  has "it warns" "$out" "::warning title=Another commit::The checkout is at $ZHEAD, not at $GITHUB_SHA"
  has "and links the checkout" "$(cat "$SUMMARY")" "Commit [\`${ZHEAD:0:10}\`](https://github.example/tidyverse/duckplyr/commit/$ZHEAD) on \`release-x\`."

  echo
  echo "== a package that does not build fails with advice"
  mkdir -p "$SCRATCH/src/broken"
  printf 'Package: broken\nVersion: one\nTitle: A Malformed Version\n' >"$SCRATCH/src/broken/DESCRIPTION"
  out=$(run tarball "$SCRATCH/out2" "$SCRATCH/src/broken")
  has "it fails" "$out" "exit 1"
  has "naming the build" "$out" "::error title=R CMD build failed::"
  summary=$(cat "$SUMMARY")
  has "the summary says the build failed" "$summary" "### Build: failed"
  has "and how to resolve it" "$summary" "Reproduce it with \`R CMD build .\`"

  echo
  echo "== a recompression that does not match is deleted"
  mkdir -p "$SCRATCH/bin"
  # shellcheck disable=SC2016  # the stub's own $1
  printf '#!/bin/sh\n[ "$1" = --version ] && { echo "pigz 0.0"; exit 0; }\ncat >/dev/null\nprintf "not a gzip stream"\n' >"$SCRATCH/bin/pigz"
  chmod +x "$SCRATCH/bin/pigz"
  out=$(PATH=$SCRATCH/bin:$PATH run tarball "$SCRATCH/out3" "$SCRATCH/src/zpkg")
  has "it fails" "$out" "exit 1"
  has "naming the mismatch" "$out" "::error title=The zopfli tarball does not match the one R built::"
  if [ -e "$SCRATCH/out3/zpkg_0.2.0.tar.gz" ]; then no "the tarball is gone"; else ok "the tarball is gone"; fi
  has "the summary says verification failed" "$(cat "$SUMMARY")" "### Verify: failed"
fi

echo
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
