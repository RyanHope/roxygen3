#' Namespace: tags for exporting objects
#'
#' Generally, you will only need to use a bare \code{@@export} - this will
#' inspect the documented object and automatically figure out the correct
#' export (which varies based on whether it's a function, s3 method, s4
#' class, s4 generic/method).
#'
#' The convention in \pkg{roxygen3} is that exporting a generic automatically
#' exports all associated methods. This happens automatically for S4 with
#' the \code{exportMethod} directive, but needs considerable work for S3.
#' For details, see \link{roxgyen_s3}.
#' 
#' It's not recommend practice to use \code{@@exportPattern} (instead it's
#' better to individually label the functions to be exported), but this may 
#' be useful for legacy packages.
#'
#' @usage 
#'   @@export 
#'   @@export function name
#' @rdname tag_export
add_roccer("export",
  roc_parser(
    words_tag(),
    function(roc, obj, ...) {
      # Not specified, or ot empty, so just return
      if (is.null(roc$export) || roc$export != "") {
        return()
      }
      
      default_export(obj$value, obj$name)
    }
  ),
  namespace_out(ns_each("export"))
)
base_prereqs[["export"]] <- c("S3method", "docType")

#' @usage @@exportClass class1 class2
#' @rdname tag_export
add_ns_roccer("exportClass", 
  words_tag(), 
  ns_each("exportClass")
)
#' @usage @@exportMethods generic1 generic2
#' @rdname tag_export
add_ns_roccer("exportMethods", 
  words_tag(), 
  ns_each("exportMethods")
)
#' @usage @@exportPattern pattern
#' @rdname tag_export
add_ns_roccer("exportPattern", 
  words_tag(), 
  ns_each("exportPattern")
)
