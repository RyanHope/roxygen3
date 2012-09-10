default_export.function <- function(obj, name) {
  list(export = name)
}

usage.function <- function(obj, name, ...) {
  args <- usage_args(formals(obj))
  
  new_usage(
    name = name,
    args = args, 
    subclass = "usage_function")
}
usage.s3generic <- usage.function

is_replacement_fun <- function(name) {
  str_detect(name, fixed("<-"))
}
is_infix_fun <- function(name) {
  str_detect(name, "^%.*%$")
}

#' @autoImports
format.usage_function <- function(x, ...) {
  
  arglist <- args_string(x$args)
  if (is_replacement_fun(x$name)) {
    name <- str_replace(x$name, fixed("<-"), "")
    str_c(name, "(", arglist, ") <- value")
  } else if (is_infix_fun(x$name)) {
    arg_names <- names(x$args)
    str_c(arg_names[1], " ", x$name, " ", arg_names[2])
  } else {    
    str_c(x$name, "(", arglist, ")")
  }
}

args_string <- function(x) {
  missing_arg <- x == ""
  sep <- ifelse(!missing_arg, "\u{A0}=\u{A0}", "")
  
  str_c(names(x), sep, x, collapse = ", ")
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
