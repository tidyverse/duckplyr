pkgload::load_all()

# when keys have different names
df1 <- tibble(a = c(2, 3), b = c(1, 2))
df2 <- tibble(x = c(3, 4), y = c(3, 4))

for (i in 1:100) {
  message(i)
  out <- duckplyr_right_join(df1, df2, by = c("a" = "x"), keep = TRUE)
}
