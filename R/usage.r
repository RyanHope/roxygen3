#' Given an object, return a string showing how that object should be
#' used.
#'
#'

setClass("TextUsage", contains = "Usage", representation(
  text = "character"))

setClass("FunctionUsage", contains = "Usage", representation(
  formals = "list",
  name = "character"
))
setClass("S4MethodUsage", contains = "FunctionUsage", representation(
  generic = "character",
  signature = "character"
))
setClass("S3MethodUsage", contains = "FunctionUsage", representation(
  generic = "character",
  signature = "character"
))

setGeneric("format")
setMethod("format", "Usage", function(x, ...) {
  browser()
})
setMethod("format", "NullUsage", function(x, ...) {
  character()
})

setMethod("format", "TextUsage", function(x, ...) {
  x@text
})
setMethod("format", "S4MethodUsage", function(x, ...) {
  signature <- str_c(as.character(x@signature), collapse = ",")
  
  str_c("\\S4method{", x@generic, "}{", signature, "}(", 
    args_string(usage_args(x@formals)), ")")
})
setMethod("format", "S3MethodUsage", function(x, ...) {
  arglist <- args_string(usage_args(x@formals))

  method <- function(x) {
    str_c("\\method", "{", x@generic, "}{", x@signature, "}", collapse = "")
  }
  
  if (is_replacement_fun(x@generic)) {
    x@generic <- str_replace(x@generic, fixed("<-"), "")
    str_c(method(x), "(", arglist, ") <- value")
  } else {
    str_c(method(x), "(", arglist, ")")
  }
})

#' @autoImports
setMethod("format", "FunctionUsage", function(x, ...) {  
  arglist <- args_string(usage_args(x@formals))
  if (is_replacement_fun(x@name)) {
    name <- str_replace(x@name, fixed("<-"), "")
    str_c(name, "(", arglist, ") <- value")
  } else if (is_infix_fun(x@name)) {
    arg_names <- names(x@formals)
    str_c(arg_names[1], " ", x@name, " ", arg_names[2])
  } else {    
    str_c(x@name, "(", arglist, ")")
  }
})
is_replacement_fun <- function(name) {
  str_detect(name, fixed("<-"))
}
is_infix_fun <- function(name) {
  str_detect(name, "^%.*%$")
}

# Given argument list, produce usage specification for it.
# 
# Adapted from \code{\link{prompt}}.
#
# @param f function, or name of function, as string
# @return a string
usage_args <- function(args) {
  is.missing.arg <- function(arg) {
    is.symbol(arg) && deparse(arg) == ""
  }
  arg_to_text <- function(arg) {
    if (is.missing.arg(arg)) return("")
    text <- deparse(arg, backtick = TRUE, width.cutoff = 500L)
    text <- str_replace_all(text, fixed("%"), "\\%")
    text <- str_replace_all(text, fixed(" "), "\u{A0}")
    Encoding(text) <- "UTF-8"    
    
    text
  }
  vapply(args, arg_to_text, character(1))
}

args_string <- function(x) {
  missing_arg <- x == ""
  sep <- ifelse(!missing_arg, "\u{A0}=\u{A0}", "")
  
  str_c(names(x), sep, x, collapse = ", ")
}
