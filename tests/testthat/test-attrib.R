test_that("attribute copy works as expected", {
    df <- data.frame(a = 1:10)
    attr(df, "asdf") <- 42

    df1 <- data.frame(b = 1:20)

    df2 <- wrap_df(df1)
    attr(df2, "fdsa") <- 42

    expect_warning(
      .Call(copy_df_attribs, df2, df),
      NA
    )

    # attrs from df2 disappear
    expect_null(attr(df2, "fdsa"))
    # attrs from df appear
    expect_equal(attr(df2, "asdf"), 42)

    # names and row.names are untouched
    expect_warning(
      expect_equal(names(df2), names(df1)),
      NA
    )

    # materialization happens only when touching row names
    expect_warning(
      expect_equal(row.names(df2), row.names(df1)),
      "DATAPTR"
    )
})
