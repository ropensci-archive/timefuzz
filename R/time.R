# FIXME: funky stuff with method aliases going on here, sort it out

#' Time
#' @examples
#' x <- Time$new()
#' x$now()
#' x$now_with_mock_time()
Time <- R6::R6Class(
  "Time",
  public = list(
    # now = NULL,
    # now_with_mock_time = NULL,
    # now_without_mock_time = NULL,
    new = NULL,
    # new_with_mock_time = NULL,
    new_without_mock_time = NULL,

    now = function() lubridate::now(),

    now_without_mock_time = function() self$now(),

    mock_time = function() {
      mocked_time_stack_item <- timefuzz_conf$top_stack_item
      if (is.null(mocked_time_stack_item)) return(NULL)
      mocked_time_stack_item$time()
    },

    now_with_mock_time = function() {
      self$mock_time() %||% self$now_without_mock_time()
    },

    new_with_mock_time = function(...) {
      if (length(list(...)) <= 0) self$now() else self$now()
    }
  )
)
