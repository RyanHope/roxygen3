#' Block class.
#'
#' The block class encapsulates the data about a single roxygen comment
#' block, along with its location in the src code, and the object associated
#' with the block.
#'
#' @export
Block <- function(tags = list(), object = new("NullObject"),
                  srcref = new("NullSrcref"), default_tags = base_tags()) {
  defaults <- compute_defaults(object, default_tags)
  tags <- c(tags, defaults[setdiff(names(defaults), names(tags))])

  new("Block", tags = tags, object = object, srcref = srcref)
}

compute_defaults <- function(object, tags) {
  methods <- find_default_methods(object@class, tag_class(tags))
  defaults <- compact(lapply(methods, call_fun, object = object))
  names(defaults) <- vapply(defaults, tag_name, character(1))

  defaults
}

find_default_methods <- memoise(function(object, tags) {
  default_method <- function(x) {
    selectMethod("defaultTag", c(x, object), optional = TRUE)
  }
  compact(lapply(tags, default_method))
})

setMethod("show", "Block", function(object) {
  cat("Block: ", object@object@name, "@",
    location(object@srcref), "\n", sep = "")
  lapply(object@tags, show)
})

setMethod("process", "Block", function(input) {
  for (tag in names(input@tags)) {
    input <- process(input@tags[[tag]], block = input)
  }

  input
})
