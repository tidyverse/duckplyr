#!/bin/bash
# Adapted from r-dbi/RSQLite's .github/actions/cran-release/cran-release-test.sh at c110c21e2 (branch claude/rsqlite-cran-release).
# Copied from duckdb/duckdb-r's scripts/cran-release-test.sh at 86ac17f6b.
# Check .github/actions/cran-release/cran-release.sh offline, against a fake P3M on 127.0.0.1 and a `gh` stub: nothing reaches GitHub.
# Process: the header of .github/workflows/cran-submission.yaml
#
#   1. A draft whose version P3M does not list yet is one line in the report, and success.
#   2. A draft whose version P3M lists is published, once its tag points at its target.
#   3. A missing tag, and a tag at another commit, fail with a "How to resolve" section
#      and publish nothing.
#   4. No draft with the marker is nothing to do: no request to P3M, and success.
#   5. A dry run publishes nothing, and says what it would publish.
#      The step output `published` names each release that was published, and only those.
#   6. Only drafts carrying the marker of cran-submission.yaml, with the tag `v<version>`, count.
#
# The `gh` stub answers `gh api <path> --jq <program>` by running the program with jq
# over a JSON file named after the path, and records every call; `gh release edit` only records.
#
# Usage:
#   .github/actions/cran-release/cran-release-test.sh
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

command -v jq >/dev/null || {
  echo "jq is needed to answer for the gh stub" >&2
  exit 1
}

# --- the fake P3M ------------------------------------------------------------
#
# Serves $SCRATCH/p3m and records every request in $SCRATCH/p3m.log.

cat >"$SCRATCH/server.py" <<'EOF'
import functools, http.server, os, sys

scratch = sys.argv[1]


class Repo(http.server.SimpleHTTPRequestHandler):
    def log_message(self, fmt, *args):
        with open(os.path.join(scratch, "p3m.log"), "a") as f:
            f.write("%s %s\n" % (self.command, self.path))


srv = http.server.HTTPServer(("127.0.0.1", 0), functools.partial(Repo, directory=os.path.join(scratch, "p3m")))
with open(os.path.join(scratch, "port.tmp"), "w") as f:
    f.write(str(srv.server_port))
os.rename(os.path.join(scratch, "port.tmp"), os.path.join(scratch, "port"))
srv.serve_forever()
EOF

CONTRIB=$SCRATCH/p3m/cran/latest/src/contrib
mkdir -p "$CONTRIB" "$SCRATCH/srv"
(cd "$SCRATCH/srv" && exec python3 -I "$SCRATCH/server.py" "$SCRATCH") &
SERVER_PID=$!
for _ in $(seq 100); do
  [ -s "$SCRATCH/port" ] && break
  sleep 0.1
done
[ -s "$SCRATCH/port" ] || {
  echo "the fake P3M did not start" >&2
  exit 1
}
P3M=http://127.0.0.1:$(cat "$SCRATCH/port")/cran/latest
INDEX=$P3M/src/contrib/PACKAGES.gz
export no_proxy=127.0.0.1 NO_PROXY=127.0.0.1

# The index lists these package versions, one `name version` per argument.
serve() {
  local pv
  for pv in "$@"; do
    printf 'Package: %s\nVersion: %s\nNeedsCompilation: no\n\n' "${pv% *}" "${pv#* }"
  done | gzip -c >"$CONTRIB/PACKAGES.gz"
}

# --- the gh stub -------------------------------------------------------------

API=$SCRATCH/api
mkdir -p "$API" "$SCRATCH/bin"
cat >"$SCRATCH/bin/gh" <<'EOF'
#!/bin/bash
echo "gh $*" >>"$SCRATCH/gh.log"
if [ "$1" = api ]; then
  shift
  path='' jq=''
  while [ $# -gt 0 ]; do
    case "$1" in
      --jq) jq=$2; shift 2 ;;
      --paginate) shift ;;
      -*) shift ;;
      *) path=$1; shift ;;
    esac
  done
  file=$API/$(printf '%s' "$path" | tr '/?=&' '____').json
  if [ ! -f "$file" ]; then
    echo "gh: Not Found (HTTP 404)" >&2
    exit 1
  fi
  if [ -n "$jq" ]; then jq -r "$jq" "$file"; else cat "$file"; fi
  exit
fi
[ "$1 $2" = "release edit" ] && exit 0
echo "unexpected: gh $*" >&2
exit 1
EOF
chmod +x "$SCRATCH/bin/gh"
export SCRATCH API

TARGET=1111111111111111111111111111111111111111
OTHER=2222222222222222222222222222222222222222
URL=https://github.example/tidyverse/duckplyr/releases/tag/untagged-abc

releases() { # JSON for repos/tidyverse/duckplyr/releases?per_page=100
  cat >"$API/repos_tidyverse_duckplyr_releases_per_page_100.json"
}
# The draft cran-submission.yaml writes, a draft without the marker, a published release
# with it, and a draft whose marker disagrees with its tag.
with_draft() {
  releases <<EOF
[
  {"draft": true, "tag_name": "v2.0.0", "target_commitish": "$TARGET", "html_url": "$URL",
   "body": "## Breaking changes\n\n- Upgrade bundled SQLite.\n\n<!-- cran-submission: duckplyr 2.0.0 -->\n"},
  {"draft": true, "tag_name": "v9.9.9", "target_commitish": "main", "html_url": "https://github.example/x",
   "body": "A draft written by hand."},
  {"draft": false, "tag_name": "v1.5.6", "target_commitish": "main", "html_url": "https://github.example/v1.5.6",
   "body": "<!-- cran-submission: duckplyr 1.5.6 -->"},
  {"draft": true, "tag_name": "v3.0.0", "target_commitish": "main", "html_url": "https://github.example/odd",
   "body": "<!-- cran-submission: duckplyr 2.9.0 -->"}
]
EOF
}
tag_at() { # <commit>, or nothing for no tag
  if [ $# -eq 0 ]; then
    echo '[]' >"$API/repos_tidyverse_duckplyr_git_matching-refs_tags_v2.0.0.json"
    rm -f "$API/repos_tidyverse_duckplyr_commits_refs_tags_v2.0.0.json"
  else
    echo '[{"ref": "refs/tags/v2.0.0", "object": {"type": "tag", "sha": "3333333333333333333333333333333333333333"}}]' \
      >"$API/repos_tidyverse_duckplyr_git_matching-refs_tags_v2.0.0.json"
    echo "{\"sha\": \"$1\"}" >"$API/repos_tidyverse_duckplyr_commits_refs_tags_v2.0.0.json"
  fi
}

SUMMARY=$SCRATCH/summary.md
# Runs the script as the workflow does; prints its output and its exit status.
run() {
  local rc=0 out
  : >"$SUMMARY"
  : >"$SCRATCH/gh.log"
  : >"$SCRATCH/p3m.log"
  : >"$SCRATCH/output"
  out=$(GITHUB_ACTIONS=true GITHUB_STEP_SUMMARY=$SUMMARY GITHUB_OUTPUT=$SCRATCH/output GH=$SCRATCH/bin/gh GH_REPO=tidyverse/duckplyr \
    GITHUB_REPOSITORY=tidyverse/duckplyr GITHUB_SERVER_URL=https://github.example P3M_REPO_URL=$P3M \
    "$HERE/cran-release.sh" "$@" 2>&1) || rc=$?
  printf '%s\nexit %s\n' "$out" "$rc"
}
edits() { grep '^gh release' "$SCRATCH/gh.log" || true; }

# --- 1: not on P3M yet ---------------------------------------------------------

echo
echo "== a version P3M does not list yet waits"
with_draft
tag_at "$TARGET"
serve "duckplyr 1.5.6" "other 2.0.0"
out=$(run)
has "it succeeds" "$out" "exit 0"
is "and names nothing as published" "$(cat "$SCRATCH/output")" ""
is "the report is one line" "$(cat "$SUMMARY")" "## CRAN release

- duckplyr 2.0.0 is not on P3M yet; checked $INDEX, which lists duckplyr 1.5.6."
is "nothing is published" "$(edits)" ""
is "and names nothing as published" "$(cat "$SCRATCH/output")" ""
has "the index was read" "$(cat "$SCRATCH/p3m.log")" "GET /cran/latest/src/contrib/PACKAGES.gz"
has "the log says what P3M serves" "$out" "$(printf '  %-20s %s' 'P3M serves:' 1.5.6)"
has "and skips the draft whose marker disagrees with its tag" "$out" "skipped: https://github.example/odd, tag v3.0.0"
hasnt "and ignores the draft without the marker" "$out" "v9.9.9"
serve "other 2.0.0"
out=$(run)
has "a package P3M does not list waits too" "$(cat "$SUMMARY")" "which lists no duckplyr."
has "and succeeds" "$out" "exit 0"

# --- 2: on P3M -------------------------------------------------------------------

echo
echo "== a version P3M lists is published"
serve "duckplyr 2.0.0"
out=$(run)
has "it succeeds" "$out" "exit 0"
is "the draft is published as the latest release" "$(edits)" "gh release edit v2.0.0 --repo tidyverse/duckplyr --draft=false --latest"
has "after reading the tag" "$(cat "$SCRATCH/gh.log")" "gh api repos/tidyverse/duckplyr/commits/refs/tags/v2.0.0 --jq .sha"
has "with a notice" "$out" "::notice title=Published::duckplyr 2.0.0 is on P3M; published the release $URL."
summary=$(cat "$SUMMARY")
has "the report links the release" "$summary" "- Draft release: [duckplyr 2.0.0]($URL), tag \`v2.0.0\`"
has "and the commit" "$summary" "- Commit [\`${TARGET:0:10}\`](https://github.example/tidyverse/duckplyr/commit/$TARGET), the draft's target"
has "and what P3M said" "$summary" "- P3M: checked $INDEX, which lists duckplyr 2.0.0"
has "and the outcome" "$summary" "- Published as the latest release."
is "the step output names what was published" "$(cat "$SCRATCH/output")" "published<<EOF_PUBLISHED
duckplyr 2.0.0
EOF_PUBLISHED"

# --- 3: the tag ------------------------------------------------------------------

echo
echo "== a missing tag publishes nothing"
tag_at
out=$(run)
has "it fails" "$out" "exit 1"
has "naming the tag" "$out" "::error title=The tag v2.0.0 is missing::"
is "nothing is published" "$(edits)" ""
is "and names nothing as published" "$(cat "$SCRATCH/output")" ""
summary=$(cat "$SUMMARY")
has "the report says so" "$summary" "### duckplyr 2.0.0: failed"
has "and how to resolve it" "$summary" "git tag -a v2.0.0 $TARGET"

echo
echo "== a tag at another commit publishes nothing"
tag_at "$OTHER"
out=$(run)
has "it fails" "$out" "exit 1"
has "naming both commits" "$out" "::error title=The tag v2.0.0 points elsewhere::The tag v2.0.0 points to $OTHER, and the draft release targets $TARGET"
is "nothing is published" "$(edits)" ""
is "and names nothing as published" "$(cat "$SCRATCH/output")" ""
has "the report says how to resolve it" "$(cat "$SUMMARY")" "#### How to resolve"

# --- 4: no draft -------------------------------------------------------------------

echo
echo "== no draft of a submission is nothing to do"
tag_at "$TARGET"
releases <<'EOF'
[{"draft": true, "tag_name": "v9.9.9", "target_commitish": "main", "html_url": "https://github.example/x", "body": null}]
EOF
out=$(run)
has "it succeeds" "$out" "exit 0"
has "saying so" "$(cat "$SUMMARY")" "No draft release of a CRAN submission: nothing to publish."
is "without asking P3M" "$(cat "$SCRATCH/p3m.log")" ""
is "or publishing" "$(edits)" ""

# --- 5: dry run --------------------------------------------------------------------

echo
echo "== a dry run publishes nothing"
with_draft
serve "duckplyr 2.0.0"
out=$(run --dry-run)
has "it succeeds" "$out" "exit 0"
is "nothing is published" "$(edits)" ""
is "and names nothing as published" "$(cat "$SCRATCH/output")" ""
has "it says what it would publish" "$out" "::notice title=Dry run::Would publish duckplyr 2.0.0 ($URL) as the latest release; nothing was published."
summary=$(cat "$SUMMARY")
has "the report says it is a dry run" "$summary" "## CRAN release: dry run"
has "and what a real run does" "$summary" "- Dry run: a real run publishes the draft as the latest release."

echo
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
