# Snapshot transform that scrubs volatile hash values from snapshots.
#
# vctrs abbreviates factor types as `factor<xxxxx>`, where `xxxxx` is the
# first few characters of `rlang::hash()` of the factor levels. The hash
# algorithm is an implementation detail of rlang and changes between releases
# (e.g. the development version of rlang uses a different walking strategy and
# therefore produces different hashes). Scrubbing the hash keeps these
# snapshots stable across rlang versions while still capturing the structure
# of the message.
scrub_hash <- function(x) {
  gsub("factor<[0-9a-f]+>", "factor<...>", x)
}

# Snapshot transform that scrubs plan details that differ between duckdb
# versions.
#
# duckdb >= 2.0.0 qualifies temporary tables as `"temp".main.<name>` and
# prints numeric constants with an explicit cast, e.g. `CAST(1.0 AS DOUBLE)`.
# Scrubbing both keeps these snapshots stable across duckdb 1.x and 2.x.
scrub_plan <- function(x) {
  x <- gsub('"temp"\\.main\\.', "", x)
  gsub("CAST\\(([^()]+) AS DOUBLE\\)", "\\1", x)
}
