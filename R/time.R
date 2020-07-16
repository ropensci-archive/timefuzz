fuzzy_env <- new.env()

# FIXME: funky stuff with method aliases going on here, sort it out
#' Time
#' @export
#' @examples \dontrun{
#' x <- Time$new()
#' x$now_without_mock_time()
#' x$now_with_mock_time()
#' }
Time <- R6::R6Class(
  "Time",
  public = list(
    # now = NULL,
    # now_with_mock_time = NULL,
    # now_without_mock_time = NULL,
    new = NULL,
    # new_with_mock_time = NULL,
    new_without_mock_time = NULL,

    # now = function() super$now(),

    now_without_mock_time = function() {
      clock::clock_mock(FALSE)
      self$initialize()$now()
    },

    mock_time = function() {
      mocked_time_stack_item <- fuzzy_env$stack_item
      if (is.null(mocked_time_stack_item)) return(NULL)
      mocked_time_stack_item$time$time
    },

    now_with_mock_time = function() {
      self$mock_time() %||% self$now_without_mock_time()
    },

    new_with_mock_time = function(...) {
      if (length(list(...)) <= 0) self$now() else self$now()
    }
  )
)

fuzzy_env$time <- Time$new()
