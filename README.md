timefuzz
========



[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Build Status](https://travis-ci.com/ropensci/timefuzz.svg?branch=master)](https://travis-ci.com/ropensci/timefuzz)

Time travel to test time dependent code - a port of Ruby's [timecop](https://github.com/travisjeffery/timecop)

**BEWARE: VERY ALPHA**

Package API:

 - `time_fuzz`
 - `TimeStackItem`
 - `Time`

Features supported:

- freeze: freeze time to a specific point

Hope to support soon:

- travel: travel back to a specific point in time, but allow time to continue moving forward from there
- scale: scale time by a given scaling factor that will cause time to move at an accelerated pace

## Installation


```r
remotes::install_github("ropensci/timefuzz")
```


```r
library("timefuzz")
```

## freeze

### freeze with a code block


```r
library(timefuzz)
library(clock)
library(testthat)
```

`book_due()` is a toy function that tells us if a book is due


```r
book_due <- function(due_date = Sys.Date() + 10) {
  sys_date() > due_date
}
```

Given the due date of 2020-07-31 the book is not due


```r
expect_false(book_due()) # FALSE
```

Create a `time_fuzz` object


```r
x <- time_fuzz$new()
x
#> <time_fuzz> 
#>   date:
```

Call `freez()`, passing the date you want to freeze time to, and then a code block to run
in the context of that frozen time. Here we'll freeze time to today + 450 days


```r
x$freeze(Sys.Date() + 450, {
  expect_true(book_due())
})
#> [1] TRUE
```

`book_due()` results in `TRUE` now, whereas it was `FALSE` above in real time

### freeze without a code block


```r
x <- time_fuzz$new()
## set to today + 450 days
x$freeze(Sys.Date() + 450)
```

We're in the freezed date. So any time based actions using the [clock][] package 
are now using your frozen time context.


```r
sys_time()
#> [1] "2021-10-13 17:00:00 PDT"
```

call `$unfreeze()` to unfreeze


```r
x$unfreeze()
```

now we're back in current time


```r
sys_time()
#> [1] "2020-07-21 17:18:32 PDT"
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/timefuzz/issues).
* License: MIT
* Get citation information for `timefuzz` in R doing `citation(package = 'timefuzz')`
* Please note that this package is released with a [Contributor Code of Conduct](https://ropensci.org/code-of-conduct/). By contributing to this project, you agree to abide by its terms.

[![rofooter](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
