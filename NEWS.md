<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->

# duckplyr 0.2.3.9000 (2023-11-09)

## Chore

  - Sync generated files (#71).

## Uncategorized

  - Merge branch 'cran-0.2.3'.


# duckplyr 0.2.3 (2023-11-08)

## Performance

- Join using `IS NOT DISTINCT FROM` for faster execution (duckdb/duckdb-r#41, #68).

## Documentation

- Add stability to README output (@maelle, #62, #65).


# duckplyr 0.2.2 (2023-10-16)

## Bug fixes

- `summarise()` keeps `"duckplyr_df"` class (#63, #64).

- Fix compatibility with duckdb \>= 0.9.1.

## Chore

- Skip tests that give different output on dev tidyselect.

- Import `utils::globalVariables()`.

## Documentation

- Small README improvements (@maelle, #34, #57).

- Fix 301 in README.


# duckplyr 0.2.1 (2023-09-16)

- Improve documentation.

- Work around problem with `dplyr_reconstruct()` in R 4.3.

- Rename `duckdb_from_file()` to `df_from_file()`.

- Unexport private `duckdb_rel_from_df()`, `rel_from_df()`, `wrap_df()` and `wrap_integer()`.

- Reexport `%>%` and `tibble()`.


# duckplyr 0.2.0 (2023-09-10)

- Implement relational API for DuckDB.


# duckplyr 0.1.0 (2023-07-03)

## Bug fixes

- Fix examples.

## Chore

- Add CRAN install instructions.
- Satisfy `R CMD check`.
- Document argument.
- Error on NOTE.
- Remove `relexpr_window()` for now.

## Documentation

- Clean up reference.

## Uncategorized

Initial version, exporting:
- `new_relational()` to construct objects of class `"relational"`
- Generics `rel_aggregate()`, `rel_distinct()`, `rel_filter()`, `rel_join()`, `rel_limit()`, `rel_names()`, `rel_order()`, `rel_project()`, `rel_set_diff()`, `rel_set_intersect()`, `rel_set_symdiff()`, `rel_to_df()`, `rel_union_all()`
- `new_relexpr()` to construct objects of class `"relational_relexpr"`
- Expression builders `relexpr_constant()`, `relexpr_function()`, `relexpr_reference()`, `relexpr_set_alias()`, `relexpr_window()`
