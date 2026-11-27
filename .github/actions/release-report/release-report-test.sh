#!/bin/bash
# Adapted from r-dbi/RSQLite's .github/actions/release-report/release-report-test.sh at c110c21e2 (branch claude/rsqlite-cran-release).
# Check release-report.sh offline, against a `gh` stub: nothing reaches GitHub.
#
#   1. Without an earlier comment, the run posts one on the pull request whose head is the ref.
#   2. With one, carrying the marker and written by github-actions[bot], the run updates it.
#   3. A comment with the marker by someone else is left alone.
#   4. With ISSUE_MARKER, the open issue carrying it is used, never a pull request;
#      without a target, nothing is posted.
#   5. The overall result is failure when any job failed, and the body lists every job.
#
# Usage:
#   .github/actions/release-report/release-report-test.sh

set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
SCRATCH=$(mktemp -d)
trap '[ -n "${KEEP:-}" ] || rm -rf "$SCRATCH"' EXIT

pass=0
fail=0
ok() { pass=$((pass + 1)); echo "  ok   $1"; }
no() { fail=$((fail + 1)); echo "  FAIL $1"; }
is() { if [ "$2" = "$3" ]; then ok "$1"; else no "$1"; echo "         actual: $2"; echo "       expected: $3"; fi; }
has() { case "$2" in *"$3"*) ok "$1" ;; *) no "$1"; echo "       missing: $3"; echo "        in: $2" ;; esac; }

command -v jq >/dev/null || {
  echo "jq is needed to answer for the gh stub" >&2
  exit 1
}

# The stub answers `gh api <path> --jq <program>` from a JSON file named after the path,
# records every call, and keeps the body of a POST or PATCH in $SCRATCH/body.
API=$SCRATCH/api
mkdir -p "$API" "$SCRATCH/bin"
cat >"$SCRATCH/bin/gh" <<'STUB'
#!/bin/bash
echo "gh $*" >>"$SCRATCH/gh.log"
shift
path='' jq='' method=GET
while [ $# -gt 0 ]; do
  case "$1" in
    --jq) jq=$2; shift 2 ;;
    -X) method=$2; shift 2 ;;
    -F) method=${method/GET/POST}; cp "${2#body=@}" "$SCRATCH/body"; shift 2 ;;
    --paginate) shift ;;
    *) path=$1; shift ;;
  esac
done
if [ "$method" != GET ]; then
  echo "$method $path" >>"$SCRATCH/writes"
  echo "https://github.example/comment"
  exit 0
fi
file=$API/$(printf '%s' "$path" | tr '/?=&:' '_____').json
[ -f "$file" ] || { echo "gh: Not Found (HTTP 404)" >&2; exit 1; }
jq -r "$jq" "$file"
STUB
chmod +x "$SCRATCH/bin/gh"
export SCRATCH API

head_prs() { cat >"$API/repos_o_r_pulls_state_open_head_o_release-1.0.0_per_page_1.json"; }
issues() { cat >"$API/repos_o_r_issues_state_open_per_page_100.json"; }
comments() { cat >"$API/repos_o_r_issues_${1}_comments_per_page_100.json"; }

run() {
  : >"$SCRATCH/writes"
  rm -f "$SCRATCH/body"
  GH=$SCRATCH/bin/gh GH_REPO=o/r GITHUB_SERVER_URL=https://github.example GITHUB_RUN_ID=42 GITHUB_RUN_NUMBER=7 \
    GITHUB_RUN_ATTEMPT=1 GITHUB_REF_NAME=release-1.0.0 GITHUB_SHA=0123456789abcdef GITHUB_EVENT_NAME=workflow_dispatch \
    "$HERE/release-report.sh" "$@" 2>&1
}

echo "== a first run posts a comment"
head_prs <<<'[{"number": 5}]'
comments 5 <<<'[]'
out=$(RESULTS=$'gate=success\ndocs=failure\nsoft=skipped' DETAILS="Extra line." run release-gate "Release gate")
is "it posts on the pull request of the ref" "$(cat "$SCRATCH/writes")" "POST repos/o/r/issues/5/comments"
body=$(cat "$SCRATCH/body")
has "with the marker first" "$(head -n 1 <<<"$body")" "<!-- release-report: release-gate -->"
has "the overall result is failure" "$body" "### ❌ Release gate: failure"
has "with the run linked" "$body" "Run [#7](https://github.example/o/r/actions/runs/42)"
has "every job" "$body" $'- `gate`: success\n- `docs`: failure\n- `soft`: skipped'
has "and the details" "$body" "Extra line."
has "the log says so" "$out" "Posted a comment on #5."

echo "== a later run updates it"
comments 5 <<<'[{"id": 11, "user": {"login": "someone"}, "body": "<!-- release-report: release-gate -->\nquoted"},
               {"id": 12, "user": {"login": "github-actions[bot]"}, "body": "<!-- release-report: release-gate -->\nold"}]'
out=$(RESULTS=gate=success run release-gate "Release gate")
is "it patches the bot's comment, not the other one" "$(cat "$SCRATCH/writes")" "PATCH repos/o/r/issues/comments/12"
has "the overall result is success" "$(cat "$SCRATCH/body")" "### ✅ Release gate: success"

echo "== with an issue marker, the checklist issue is the target"
issues <<<'[{"number": 3, "body": "<!-- release-checklist: duckplyr 1.0.0 -->", "pull_request": {}},
            {"number": 4, "body": null},
            {"number": 9, "body": "Checklist\n<!-- release-checklist: duckplyr 1.0.0 -->"}]'
comments 9 <<<'[]'
out=$(RESULTS=publish=success ISSUE_MARKER="<!-- release-checklist: " run cran-release "CRAN release")
is "it posts on the issue, not on the pull request" "$(cat "$SCRATCH/writes")" "POST repos/o/r/issues/9/comments"

echo "== without a target, nothing is posted"
head_prs <<<'[]'
out=$(RESULTS=publish=success run cran-release "CRAN release")
is "no write" "$(cat "$SCRATCH/writes")" ""
has "a notice says so" "$out" "::notice title=Nothing to report to::"

echo
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
