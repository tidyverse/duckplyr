# duckplyr_select() provides informative errors

    Code
      (expect_error(duckplyr_select(mtcars, 1 + "")))
    Output
      <error/rlang_error>
      Error in `select()`:
      ! Problem while evaluating `1 + ""`.
      Caused by error in `1 + ""`:
      ! non-numeric argument to binary operator

