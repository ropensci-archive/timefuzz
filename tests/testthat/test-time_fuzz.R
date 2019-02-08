context("time_fuzz")

test_that("time_fuzz", {
  expect_is(time_fuzz, "R6ClassGenerator")
  expect_is(time_fuzz$new(), "time_fuzz")
})
