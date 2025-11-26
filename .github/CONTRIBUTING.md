# Contributing to duckplyr

This outlines how to propose a change to duckplyr.
For a detailed discussion on contributing to this and other tidyverse packages, please see the [development contributing guide](https://rstd.io/tidy-contrib) and our [code review principles](https://code-review.tidyverse.org/).

## Fixing typos

You can fix typos, spelling mistakes, or grammatical errors in the documentation directly using the GitHub web interface, as long as the changes are made in the _source_ file.
This generally means you'll need to edit [roxygen2 comments](https://roxygen2.r-lib.org/articles/roxygen2.html) in an `.R`, not a `.Rd` file.
You can find the `.R` file that generates the `.Rd` by reading the comment in the first line.

## Bigger changes

If you want to make a bigger change, it's a good idea to first file an issue and make sure someone from the team agrees that it’s needed.
If you’ve found a bug, please file an issue that illustrates the bug with a minimal
[reprex](https://www.tidyverse.org/help/#reprex) (this will also help you write a unit test, if needed).
See our guide on [how to create a great issue](https://code-review.tidyverse.org/issues/) for more advice.

### Pull request process

*   Fork the package and clone onto your computer. If you haven't done this before, we recommend using `usethis::create_from_github("tidyverse/duckplyr", fork = TRUE)`.

*   Install all development dependencies with `pak::pak(dependencies = c("Depends", "Imports", "Suggests", "Config/Needs/development"))`, and then make sure the package passes `R CMD check` by running `devtools::check()`.
    If R CMD check doesn't pass cleanly, it's a good idea to ask for help before continuing.

*   Create a Git branch for your pull request (PR). We recommend using `usethis::pr_init("brief-description-of-change")`.

*   Make your changes, commit to git, and then create a PR by running `usethis::pr_push()`, and following the prompts in your browser.
    The title of your PR should briefly describe the change.
    The body of your PR should contain `Fixes #issue-number`.

*   Please do not edit `NEWS.md`.

### Code style

*   New code should follow the tidyverse [style guide](https://style.tidyverse.org).
    You can use the [styler](https://CRAN.R-project.org/package=styler) package to apply these styles, but please don't restyle code that has nothing to do with your PR.

*  We use [roxygen2](https://cran.r-project.org/package=roxygen2), with [Markdown syntax](https://cran.r-project.org/web/packages/roxygen2/vignettes/rd-formatting.html), for documentation.

*  We use [testthat](https://cran.r-project.org/package=testthat) for unit tests.
   Contributions with test cases included are easier to accept.

## New translations for functions

For all functions used in dplyr verbs, translations must be provided.
The code lives in `translate.R` .
New translations must change code in two places:

1. The `switch()` in `rel_find_packages()` needs a new entry, paired with the name of the package that is home to the function.
    The top 60 functions, ranked by importance, are already part of that `switch()`, as a comment if they are not implemented yet.
    Example: For adding `lubridate::month()`, add a line of the following form to the `switch()`:

    ```r
    "month" = "lubridate",
    ```

1. The actual translation must be implemented in `rel_translate_lang()`.
    This is easy for some functions, in particular if similar functions are already translated, but harder for others.
    This part of the code is not very clear yet, in particular, argument matching by name is only available for a few functions but should be generalized.

    - In some cases (like with `lubridate::month()`), a function of the exact same name already exists in DuckDB, and there's nothing more to do.

    - In other cases, a macro must be defined in `relational-duckdb.R` that implements the translation.

    - Do you need to do even more work? Let's discuss!

2. Test your implementation in the console with code of the form:

    ```r
    rel_translate(quo(lubridate::month(a)), data.frame(a = Sys.Date())) |>
      constructive::construct()
    ```

3. Ensure that your implementation computes what you want it to:

    ```r
    duckdb_tibble(a = Sys.Date(), .prudence = "stingy") |>
      mutate(lubridate::month(a))
    ```

4. Add a test for the new translation to the `mutate =` section of `test_extra_arg_map` in `00-funs.R`.
    (At some point we want to have more specific tests for the translations, for now, this is what it is.)

5. Run `03-tests.R`, commit the changes to the generated code to version control.

6. Update the list in the `limits.Rmd` vignette.

## Support more options for verbs

All verbs wrap the code in a `rel_try({})` call and fall back to dplyr in the case of failure.
The `rel_try()` function takes named arguments that describe conditions for an early drop-out, and the corresponding error message.
To add support for a condition for which a drop-out is being defined, roughly the following steps are necessary:

1. Remove the drop-out condition.
2. Run the tests, take note of the failures.
3. Provide an implementation that fixes the failures.
4. Add a test that the verb works with `DUCKPLYR_FORCE = TRUE` under the new conditions.
5. Run `02-duckplyr_df-methods.R` to update the corresponding patch file.

## Support new verbs

Let's discuss first!

## Support new column data types

Let's discuss first!

## Support new data frame types

Let's discuss first!

## Code generation and synchronization

The duckplyr package is a "long-running fork of dplyr", and has code to generate parts of its own implementation and tests, and to synchronize changes from duckplyr with our codebase.
The main synchronization script is `tools/99-sync.R`, it also contains instructions how to set up a new clone.
This script should be run whenever the implementation of the verbs changes in a substantial way.
Watch out for the `# Generated by ...` headers at the top of source files.

## Code of Conduct

Please note that the duckplyr project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this
project you agree to abide by its terms.
