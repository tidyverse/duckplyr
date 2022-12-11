test_that("promises work as expected", {
  skip("Won't need")

    producer <- function(x) {
        42L
    }
    is_promise <- function(x) .Call(is_promise, x)

    expect_true(is_promise(.Call(promise, producer)))
    expect_true(.Call(promise, producer) |> is_promise())

    p <- .Call(promise, producer)
    expect_false(is_promise(p))

})
