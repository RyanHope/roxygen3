#' Set object documentation type.
#'
#' @details You can use any doctype, but it will only be included in
#'   the Rd file if it is one of the standard R doctypes: data, package,
#'   methods and class.
#'
#' @usageTag
#'   @@docType data
#'   @@docType package
#'   @@docType custom doctype
#'
setClass("DocTypeTag", contains = "Tag")

setMethod("defaultTag", c("DocTypeTag", "S4MethodObject"),
  function(tag, object) {
    new("DocTypeTag", text = "methods")
  }
)
setMethod("defaultTag", c("DocTypeTag", "S4ClassObject"),
  function(tag, object) {
    new("DocTypeTag", text = "class")
  }
)
setMethod("defaultTag", c("DocTypeTag", "DataObject"),
  function(tag, object) {
    new("DocTypeTag", text = "data")
  }
)
setMethod("defaultTag", c("DocTypeTag", "R5ClassObject"),
  function(tag, object) {
    new("DocTypeTag", text = "class")
  }
)
setMethod("defaultTag", c("DocTypeTag", "PackageObject"),
  function(tag, object) {
    new("DocTypeTag", text = "package")
  }
)

setMethod("writeRd", "DocTypeTag", function(object) {
  new_command("docType", object@text)
})

#' @export
format.docType_command <- function(x, ...) {
  vals <- unique(x$value)
  if (length(vals) != 1) stop("Documentation can only have single docType")

  ok <- c("data", "package", "methods", "class")
  vals <- intersect(vals, ok)
  if (length(vals) == 0) return("")

  str_c("\\docType{", vals, "}")
}

