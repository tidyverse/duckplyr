# tools/

Developer scripts for code generation, testing, and benchmarking in duckplyr.
Most scripts are meant to be run with `source("tools/<script>.R", echo = TRUE)` from the package root directory.

## Prerequisites

Before using these tools, set up the required helper repositories:

```sh
cd .sync
git clone git@github.com:krlmlr/dplyr.git dplyr-main
git clone git@github.com:krlmlr/dplyr.git -b f-revdep-duckplyr dplyr-revdep --reference dplyr-main
```

See `.sync/README.md` for details.
Also clone `duckdb/duckdb-r` in a cousin directory next to the duckplyr checkout (clone path `../../duckdb/duckdb-r`):

```sh
mkdir -p ../../duckdb
git -C ../../duckdb clone git@github.com:duckdb/duckdb-r.git
```

## Master sync script

**`99-sync.R`** — The main entry point.
Run this every time you want to regenerate all code-generated files after dplyr or duckplyr changes.
It calls, in order:

1. `80-unsupported.R`
2. `01-dplyr-methods.R`
3. `02-duckplyr_df-methods.R`
4. `03-tests.R`
5. `04-dplyr-tests.R`
6. `05-duckdb-tests.R`
7. `06-patch-duckdb.R`
8. `07-overwrite.R`
9. `37-tpch-peel.R`
10. `39-tpch-peel-oo.R`

## Script reference

### Code generation pipeline (00–07)

These scripts form a pipeline that introspects dplyr's S3 methods for `data.frame` and generates the corresponding duckplyr method implementations, tests, and overwrite/restore registration code.

#### `00-funs.R`

Shared foundation sourced by most other scripts. Loads dplyr's namespace, discovers all `data.frame` S3 methods, and builds the `df_methods` tibble that drives code generation. Also defines:

- `duckplyr_tests` — which dplyr test files to copy and which individual tests to skip.
- `dplyr_only_tests` — tests skipped only when running inside the rigged dplyr (revdep) build.
- `non_force_only_tests` — tests to skip when `DUCKPLYR_FORCE` is `TRUE`.
- `test_extra_arg_map` — per-verb argument combinations for generated tests.
- `test_skip_map`, `test_force_override` — fine-grained control over test generation.
- `test_df_code`, `test_df_xy_code` — standard test data frame definitions.

#### `01-dplyr-methods.R`

Pulls the latest dplyr from `.sync/dplyr-main`, loads it, and extracts the source code of each `data.frame` method body. Writes one text file per method to the `dplyr-methods/` directory (e.g., `dplyr-methods/mutate.txt`). These serve as the dplyr fallback implementation embedded in each generated method file.

#### `02-duckplyr_df-methods.R`

Generates the `R/<verb>.R` files (e.g., `R/mutate.R`) that contain:

- The `<verb>.duckplyr_df` S3 method, which first attempts a relational (DuckDB) execution via `rel_try()` and, on failure, falls back to the embedded dplyr `data.frame` implementation.
- A `duckplyr_<verb>()` test helper used by the generated tests.

After writing the generated files, it applies any patch files found in `patch/` (manual tweaks on top of the generated code). It then collects new patches by diffing the current R files against the generated baseline, so manual edits are preserved across regeneration.

#### `03-tests.R`

Generates `tests/testthat/test-as_duckplyr_df.R`.
For each verb, creates tests that convert a data frame to a `duckplyr_df` and compare the result of the verb to the plain dplyr result, ensuring equivalence. Also generates fallback-forcing test variants.

#### `04-dplyr-tests.R`

Copies test files from `.sync/dplyr-main/tests/testthat/` into duckplyr's test suite as `test-dplyr-*.R`. Rewrites verb calls to use `duckplyr_<verb>()` wrappers and inserts `skip("TODO duckdb")` annotations for tests listed in `duckplyr_tests`.

#### `05-duckdb-tests.R`

Generates `tests/testthat/test-rel_api.R`.
For each verb (with both order-preserving and order-enforcing variants), runs the operation through the DuckDB relational API, captures the meta-replay SQL/relational plan, and generates a self-contained test that reconstructs the same plan and checks the result against the expected output.

#### `06-patch-duckdb.R`

Takes the generated `test-rel_api.R` and transforms it for use in the duckdb-r package (`../duckdb-r/tests/testthat/test-rel_api.R`). Removes `duckdb::` and `DBI::` namespace qualifiers and activates `skip_if_not(TEST_RE2)` guards.

#### `07-overwrite.R`

Generates `R/overwrite.R` and `R/restore.R`:

- `methods_overwrite_impl()` — registers duckplyr's `.duckplyr_df` methods as the `data.frame` methods for each dplyr generic via `vctrs::s3_register()`. This is the mechanism that makes all data frames use duckplyr transparently.
- `methods_restore_impl()` — reverses the overwrite, restoring the original dplyr methods.

### TPC-H benchmarking (30–50)

A suite of scripts for running and comparing TPC-H benchmark queries. There are three execution modes:

| Mode | Description | Scripts |
|---|---|---|
| **duckplyr** | Queries written in dplyr syntax, executed via duckplyr | 32, 33, 34 |
| **raw** | Queries "peeled" into direct relational API calls (no dplyr overhead) | 37, 42, 43, 44 |
| **raw-oo** | Same as raw, but with order-preserving output (`DUCKPLYR_OUTPUT_ORDER = TRUE`) | 39, 45, 46, 47 |

#### `30-tpch-export.R`

Generates TPC-H data at three scale factors (0.01, 0.1, 1) as Parquet files in `tools/tpch/{001,010,100}/` using DuckDB's built-in TPC-H extension.

#### `31-tpch-load-qs.R`

Reads the Parquet files and saves them as `.qs` files (`tools/tpch/{001,010,100}.qs`) for fast loading.

#### `32-tpch-run.R`

Loads scale-factor 0.01 data and runs all 22 TPC-H queries (`tpch_01()` through `tpch_22()`) interactively via duckplyr.

#### `33-tpch-compare.R`

Runs all 22 TPC-H queries and checks correctness against reference answers in `tests/testthat/tpch-sf0.01/`.

#### `34-tpch-bench.R`

Benchmarks all 22 TPC-H queries at scale factor 1 using duckplyr and writes timing results to `res-duckplyr.csv`.

#### `35-tpch-bench-dplyr.R`

Benchmarks the same queries using plain dplyr (no DuckDB) and writes results to `res-dplyr.csv`.

#### `36-tpch-bench-compare.R`

Reads `res-duckplyr.csv`, `res-dplyr.csv`, and `res-duckplyr-raw.csv` and produces comparison plots (PDF) showing speedups and absolute times.

#### `37-tpch-peel.R`

"Peels" each TPC-H query: runs it under meta-recording mode, then replays the captured relational plan as a standalone R script in `tools/tpch-raw/` and as a function in `R/tpch_raw_NN.R`. This produces the "raw" relational API version of each query, bypassing dplyr dispatch.

#### `38-tpch-empty.R`

Runs all 22 TPC-H queries on empty (zero-row) data frames using `bench::mark()`. Useful for measuring DuckDB planning overhead without data processing.

#### `39-tpch-peel-oo.R`

Same as `37-tpch-peel.R` but with `DUCKPLYR_OUTPUT_ORDER = TRUE`, producing order-preserving variants in `tools/tpch-raw-oo/` and `R/tpch_raw_oo_NN.R`.

#### `42-tpch-raw-run.R`

Runs all 22 raw (peeled) TPC-H queries interactively.

#### `43-tpch-raw-compare.R`

Checks correctness of the raw TPC-H queries against reference answers.

#### `44-tpch-raw-bench.R`

Benchmarks the raw TPC-H queries at scale factor 1; writes results to `res-duckplyr-raw.csv`.

#### `45-tpch-raw-oo-run.R`

Runs all 22 order-preserving raw TPC-H queries interactively.

#### `46-tpch-raw-oo-compare.R`

Checks correctness of the order-preserving raw queries against reference answers.

#### `47-tpch-raw-oo-bench.R`

Benchmarks the order-preserving raw queries at scale factor 1; writes results to `res-duckplyr-raw-oo.csv`.

#### `50-load-compare-bench.R`

Convenience script that runs the full benchmark pipeline: export → load → run → compare → bench (duckplyr) → bench (dplyr) → compare plots. Calls scripts 30–36 in sequence.

### Other tools (70–99)

#### `70-touchstone-gen.R`

Generates `touchstone/script.R` for the [touchstone](https://lorenzwalthert.github.io/touchstone/) continuous benchmarking system. Creates benchmark expressions for all 22 TPC-H queries at three scale factors.

#### `80-unsupported.R`

Scans `R/*.R` for verbs that have no relational implementation (contain the "No relational implementation" message) and generates `R/not-supported.R` with an `@rdname unsupported` documentation page listing them. Then runs `devtools::document()`.

#### `85-spelling.R`

Updates `.aspell/duckplyr.rds` with custom dictionary words for spell-checking.

#### `90-patch-dplyr.R`

Creates a "rigged" version of dplyr for reverse-dependency checking. This script:

1. Renames dplyr's `<verb>.data.frame` methods to `<verb>_data_frame` in `.sync/dplyr-revdep`.
2. Copies duckplyr's `.duckplyr_df` method implementations into dplyr as `.data.frame` methods, bundled into a single `R/zzz-duckplyr.R` file.
3. Patches dplyr's own test files to skip tests known to fail under duckplyr.
4. Commits and pushes the result to the `f-revdep-duckplyr` branch.

The result is a dplyr fork where **every `data.frame` method is replaced by duckplyr's implementation**, suitable for running dplyr's reverse-dependency checks to ensure duckplyr doesn't break downstream packages.

#### `99-sync.R`

Master orchestration script (see above).

### Shell scripts

#### `clone.sh`

Provisions a fresh Ubuntu machine (or container) with all the necessary repositories and runs the code-generation pipeline. Includes commented-out steps for installing R via rig, cloning dplyr forks, installing dependencies, and running each tool script.

#### `old-duck.sh`

Installs historical versions of the duckdb R package (0.7.0 through 1.1.2) from Posit Package Manager snapshots. Useful for testing backward compatibility.

#### `orbstack.sh`

Creates a fresh `duckplyr` VM on [OrbStack](https://orbstack.dev/) (amd64 Ubuntu 22.04) and runs `clone.sh` inside it. Useful for reproducible testing in a clean environment.

## Common workflows

### After dplyr changes

When dplyr is updated, run the full sync to regenerate all code and tests:

```r
# Pull latest dplyr into .sync/dplyr-main first
# (01-dplyr-methods.R and 04-dplyr-tests.R do a git pull automatically)

source("tools/99-sync.R", echo = TRUE)
```

This regenerates method implementations, tests, and the overwrite/restore machinery.
Review the changes with `git diff` and fix any new test failures.

### Implementing a new verb

1. If the verb needs manual adjustments beyond what the code generator produces, create a patch file in `patch/<verb>.patch`. The generator in `02-duckplyr_df-methods.R` applies patches automatically and preserves them across regeneration.
2. Run `source("tools/99-sync.R", echo = TRUE)` to regenerate everything.
3. Add the relational implementation inside the `rel_try()` block in `R/<verb>.R`.

### Building the rigged dplyr for revdep checks

```r
# Ensure .sync/dplyr-revdep is on branch f-revdep-duckplyr and clean
source("tools/90-patch-dplyr.R", echo = TRUE)
```

This pushes a commit to the `f-revdep-duckplyr` branch of the dplyr fork with duckplyr's methods injected as dplyr's own `data.frame` methods. You can then install this rigged dplyr and run reverse-dependency checks against it to verify that duckplyr's behavior is compatible with the broader ecosystem.

### Running TPC-H benchmarks

```r
# One-time setup: generate and serialize TPC-H data
source("tools/30-tpch-export.R", echo = TRUE)
source("tools/31-tpch-load-qs.R", echo = TRUE)

# Verify correctness
source("tools/33-tpch-compare.R", echo = TRUE)

# Benchmark duckplyr vs dplyr
source("tools/34-tpch-bench.R", echo = TRUE)
source("tools/35-tpch-bench-dplyr.R", echo = TRUE)
source("tools/36-tpch-bench-compare.R", echo = TRUE)

# Or run the full pipeline in one go:
source("tools/50-load-compare-bench.R", echo = TRUE)
```

### Provisioning a clean test environment

```sh
# On macOS with OrbStack installed:
bash tools/orbstack.sh
```

This creates a fresh Ubuntu VM, clones the repo, and runs the code-generation pipeline.
