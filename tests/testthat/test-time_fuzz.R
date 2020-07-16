context("time_fuzz")

test_that("time_fuzz", {
  expect_is(time_fuzz, "R6ClassGenerator")
  x <- time_fuzz$new()
  expect_is(x, "time_fuzz")
  expect_null(x$date)

  # no time mocking
  expect_equal(
    x$freeze("2019-01-29", {
      5 + 5
    }),
    10
  )

  # time mocking
  library(clock)
  book_due <- function(due_date = "2020-08-25") {
    as.POSIXct(clock::clock()$date()) > as.POSIXct(due_date)
  }
  expect_false(book_due()) # FALSE
  x <- time_fuzz$new()
  x
  x$freeze(Sys.Date() + 60, {
    expect_true(book_due())
  })

  # no block passed
  library(clock)
  
  # before mocking turned on
  expect_false(clock:::clock_opts$mock)
  expect_equal(round(as.numeric(clock()$now() - Sys.time())), 0)
  
  # after mocking turned on
  clock_mock()
  x <- time_fuzz$new()
  ## set to today + 435 days
  x$freeze(Sys.Date() + 435)

  expect_true(clock:::clock_opts$mock)

  expect_gt(round(as.numeric(clock()$now() - Sys.time())), 400)

  x$unfreeze()

  expect_false(clock:::clock_opts$mock)
  expect_equal(round(as.numeric(clock()$now() - Sys.time())), 0)
})
