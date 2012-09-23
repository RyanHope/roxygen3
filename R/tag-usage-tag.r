#' @@usageTag: describe how to use roxygen tags
#'
#' @keywords internal
setClass("TagUsageTag", contains = "Tag")

setMethod("writeRd", "TagUsageTag", function(object) {
  RdCommand("tagUsage", object@text)
})

setClass("TagUsageCommand", contains = "RdCommand")
setMethod("format", "TagUsageCommand", function(x, ...) {
  # First line looses original spacing, so add it back on
  values <- str_c(" ", x@values)
  lines <- unlist(str_split(values, "\n"))
  comments <- str_c("#'", lines, collapse = "\n")

  str_c(
    "\\section{Tag Usage}{\n",
    "\\preformatted{\n", comments, "\n}",
    "\n}"
  )
})
