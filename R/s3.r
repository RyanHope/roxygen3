#' Determine if a function is an S3 generic or S3 method.
#'
#' @description
#' \code{is_s3_generic} compares name to \code{.knownS3Generics} and
#' \code{.S3PrimitiveGenerics}, then uses \code{\link[codetools]{findGlobals}}
#' to see if the functionion calls \code{\link{UseMethod}}.
#'
#' \code{is_s3_method} builds names of all possible generics for that function
#' and then checks if any of them actually is a generic.
#'
#' @param name name of function.
#' @param env environment to search in.
#' @rdname s3
#' @aliases roxgyen_s3
#' @export
#' @dev
is_s3_generic <- function(name, env = parent.frame()) {
  known_generics <- c(names(.knownS3Generics),
    tools:::.get_internal_S3_generics())
  
  if (name %in% known_generics) return(TRUE)
  if (!exists(name, envir = env)) return(FALSE)

  f <- get(name, envir = env)
  if (is.primitive(f) || !is.function(f)) return(FALSE)
  
  uses <- findGlobals(f, merge = FALSE)$functions
  any(uses == "UseMethod")
}

is_s3_method <- function(name, env = parent.frame()) {
  !is.null(find_generic(name, env))
}

find_generic <- memoise(function(name, env = parent.frame()) {
  pieces <- str_split(name, fixed("."))[[1]]
  n <- length(pieces)
  
  # No . in name, so can't be method
  if (n == 1) return(NULL)
  
  for(i in seq_len(n - 1)) {
    generic <- str_c(pieces[seq_len(i)], collapse = ".")
    class <- str_c(pieces[(i + 1):n], collapse = ".")
    if (is_s3_generic(generic, env)) return(c(generic, class))
  }
  NULL
})

all_s3_methods <- memoise(function(env = parent.frame()) {
  names <- ls(envir = env)
  t(simplify2array(compact(lapply(names, find_generic, env = env))))
})

is.s3 <- function(x) inherits(x, c("s3method", "s3generic"))
add_s3_metadata <- function(val, name, env) {
  if (!is.function(val)) return(val)
  
  if (is_s3_generic(name, env)) {
    class(val) <- "s3generic"
    return(val)
  } 
  
  method <- find_generic(name, env)
  if (is.null(method)) return(val)
  
  class(val) <- "s3method"
  attr(val, "s3method") <- method
  val
}

s3_method_info <- function(x) {
  stopifnot(is.s3(x))
  attr(x, "s3method")
}