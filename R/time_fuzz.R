#' time_fuzz
#' 
#' @export
#' @details
#' **Methods**
#'   \describe{
#'     \item{`freeze(...)`}{
#'       Freez time
#'     }
#'     \item{`scale(...)`}{
#'       Freez time
#'     }
#'     \item{`local(...)`}{
#'       Freez time
#'     }
#'     \item{`travel(...)`}{
#'       Freez time
#'     }
#'     \item{`return(...)`}{
#'       Freez time
#'     }
#'   }
#'
#' @format NULL
#' @usage NULL
#' @return an [time_fuzz] object
#' @examples \dontrun{
#' x <- time_fuzz$new()
#' x
#' x$freeze
#' x$freeze(x = "2019-01-29", {
#'   5 + 5
#' })
#' 
#' x$scale
#' x$scale({
#'   5 + 5
#' })
#' }
time_fuzz <- R6::R6Class(
  "time_fuzz",
  public = list(
    url = NULL,

    print = function(x, ...) {
      cat("<time_fuzz> ", sep = "\n")
    },

    # initialize = function(...) {
    #   list(...)
    # },

    freeze = function(x, ...) {
      tmp <- rlang::quo(...)
      if (length(tmp) == 0) stop("`time_fuzz` requires a code block")
      rlang::eval_tidy(tmp)
    },

    scale = function() {
    },

    local = function() {

    },

    travel = function() {

    },

    return = function() {

    }
  ),

  private = list(
    request = NULL
  )
)
