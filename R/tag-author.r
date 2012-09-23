#' @@author: the author of the documentation
#'
#' A free text string describing the authors of the function.  This is
#' typically only necessary if the author is not the same as the package author.
#'
#' @tagUsage @@author authors...
setClass("AuthorTag", contains = "Tag")
setMethod("writeRd", "AuthorTag", function(object) {
  RdCommand("author", object@text)
})
