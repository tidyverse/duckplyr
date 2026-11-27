#!/usr/bin/env bash
# Adapted from r-dbi/RSQLite's .github/actions/cran-lib/cran-lib.sh at c110c21e2 (branch claude/rsqlite-cran-release).
# Copied from duckdb/duckdb-r's scripts/cran-lib.sh at 86ac17f6b.
# Shared helpers for .github/actions/cran-submit/cran-submit.sh and .github/actions/cran-release/cran-release.sh: the log, the annotations, the report.
# Process: the header of .github/workflows/cran-submission.yaml
#
# Sourced, not run. The log folds each stage into a group and annotates outcomes
# when GITHUB_ACTIONS is true, and prints plain lines otherwise.
# The report goes to GITHUB_STEP_SUMMARY when that is set, and nowhere otherwise;
# the advice on a failure goes to stderr either way.
# A commit is linked when GITHUB_REPOSITORY is set, with GITHUB_SERVER_URL defaulting to github.com.

process_page=.github/workflows/cran-submission.yaml

# --- output ---------------------------------------------------------------

in_actions() { [ "${GITHUB_ACTIONS:-}" = true ]; }

# Workflow command values escape %, CR and LF; properties also escape : and ,.
esc_data() {
  local s=${1//%/%25}
  s=${s//$'\r'/%0D}
  printf '%s' "${s//$'\n'/%0A}"
}
esc_prop() {
  local s
  s=$(esc_data "$1")
  s=${s//:/%3A}
  printf '%s' "${s//,/%2C}"
}

open_group=
group() {
  endgroup
  if in_actions; then echo "::group::$(esc_data "$1")"; else printf '\n== %s\n' "$1"; fi
  open_group=1
}
endgroup() {
  [ -n "$open_group" ] || return 0
  open_group=
  if in_actions; then echo "::endgroup::"; fi
}

say() { printf '%s\n' "$@"; }
# A value the stage uses, printed as `name: value`.
val() { printf '  %-20s %s\n' "$1:" "$2"; }

notice() { # <title> <message>
  if in_actions; then
    echo "::notice title=$(esc_prop "$1")::$(esc_data "$2")"
  else
    printf 'NOTICE: %s: %s\n' "$1" "$2"
  fi
}
warn() { # <title> <message>
  if in_actions; then
    echo "::warning title=$(esc_prop "$1")::$(esc_data "$2")"
  else
    printf 'WARNING: %s: %s\n' "$1" "$2" >&2
  fi
}

summary() {
  [ -n "${GITHUB_STEP_SUMMARY:-}" ] || return 0
  printf '%s\n' "$@" >>"$GITHUB_STEP_SUMMARY"
}

# Report a failed stage: close the group, annotate, write the report, advise.
#   failure <stage> <title> <message> [<excerpt file>] -- <how-to-resolve bullet>...
failure() {
  local stage=$1 title=$2 message=$3 excerpt=
  shift 3
  if [ "${1:-}" != -- ]; then
    excerpt=$1
    shift
  fi
  shift
  endgroup
  if in_actions; then
    echo "::error title=$(esc_prop "$title")::$(esc_data "$message")"
  else
    printf 'ERROR: %s: %s\n' "$title" "$message" >&2
  fi
  {
    echo
    echo "How to resolve:"
    printf '  - %s\n' "$@"
    echo "  (the release process: $process_page)"
  } >&2
  summary "" "### $stage: failed" "" "**$title.** $message" ""
  if [ -n "$excerpt" ] && [ -s "$excerpt" ]; then
    summary "<details><summary>Details</summary>" "" '```text' "$(cat "$excerpt")" '```' "" "</details>" ""
  fi
  summary "#### How to resolve" ""
  local b
  for b in "$@"; do summary "- $b"; done
  if [ -n "${GITHUB_REPOSITORY:-}" ] && [ -n "${GITHUB_SHA:-}" ]; then
    summary "- The release process: [\`$process_page\`](${GITHUB_SERVER_URL:-https://github.com}/$GITHUB_REPOSITORY/blob/$GITHUB_SHA/$process_page)." ""
  else
    summary "- The release process: \`$process_page\`." ""
  fi
}

# Report a failed stage as failure() does, and exit 1.
fail() {
  failure "$@"
  exit 1
}

# A commit as Markdown: linked in CI, where GITHUB_REPOSITORY names the repository.
commit_link() { # <sha>
  if [ -n "${GITHUB_REPOSITORY:-}" ]; then
    printf '%s' "[\`${1:0:10}\`](${GITHUB_SERVER_URL:-https://github.com}/$GITHUB_REPOSITORY/commit/$1)"
  else
    printf '%s' "\`${1:0:10}\`"
  fi
}

# The commit a stage works on: sets commit_sha, and commit_md, a Markdown line for the summary.
# In CI it is the commit the job checked out, linked, with the ref the run was started on;
# locally it is the HEAD of <dir>, unlinked, and nothing when <dir> is empty or no git checkout.
# shellcheck disable=SC2034  # commit_sha and commit_md are read by the scripts that source this
commit_of() { # <dir>
  local head=''
  commit_sha=''
  commit_md=''
  if [ -n "$1" ]; then
    head=$(git -C "$1" rev-parse HEAD 2>/dev/null) || head=''
  fi
  if [ -n "${GITHUB_SHA:-}" ] && [ -n "${GITHUB_REPOSITORY:-}" ]; then
    if [ -n "$head" ] && [ "$head" != "$GITHUB_SHA" ]; then
      warn "Another commit" "The checkout is at $head, not at $GITHUB_SHA, the commit the run was started on; the report names the checkout."
    fi
    commit_sha=${head:-$GITHUB_SHA}
    commit_md="Commit $(commit_link "$commit_sha")${GITHUB_REF_NAME:+ on \`$GITHUB_REF_NAME\`}."
  elif [ -n "$head" ]; then
    commit_sha=$head
    commit_md="Commit \`${commit_sha:0:10}\`."
  fi
}
