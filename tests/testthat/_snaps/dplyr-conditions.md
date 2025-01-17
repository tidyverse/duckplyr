# errors during dots collection are not enriched (#6178)

    Code
      duckplyr_mutate(mtcars, !!foobarbaz())
    Condition
      Error in `foobarbaz()`:
      ! could not find function "foobarbaz"
    Code
      duckplyr_transmute(mtcars, !!foobarbaz())
    Condition
      Error in `foobarbaz()`:
      ! could not find function "foobarbaz"
    Code
      duckplyr_select(mtcars, !!foobarbaz())
    Condition
      Error in `foobarbaz()`:
      ! could not find function "foobarbaz"
    Code
      duckplyr_arrange(mtcars, !!foobarbaz())
    Condition
      Error in `foobarbaz()`:
      ! could not find function "foobarbaz"
    Code
      duckplyr_filter(mtcars, !!foobarbaz())
    Condition
      Error in `foobarbaz()`:
      ! could not find function "foobarbaz"

