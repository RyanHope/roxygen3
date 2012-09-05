
#' @usage @@exportClass class1 class2
#' @rdname tag-export
setClass("TagExportClass", contains = "Tag")
setMethod("procTag", "TagExportClass", function(tag) {
  tag@text <- words_tag()(tag@text)
  tag
})
setMethod("writeNamespace", "TagExportClass", function(tag) {
  ns_each("exportClass")(tag@text)
})

#' @usage @@exportMethods generic1 generic2
#' @rdname tag-export
setClass("TagExportMethods", contains = "Tag")
setMethod("procTag", "TagExportMethods", function(tag) {
  tag@text <- words_tag()(tag@text)
  tag
})
setMethod("writeNamespace", "TagExportMethods", function(tag) {
  ns_each("exportMethods")(tag@text)
})

#' @usage @@exportPattern pattern
#' @rdname tag-export
setClass("TagExportPattern", contains = "Tag")
setMethod("procTag", "TagExportPattern", function(tag) {
  tag@text <- words_tag()(tag@text)
  tag
})
setMethod("writeNamespace", "TagExportPattern", function(tag) {
  ns_each("exportPattern")(tag@text)
})

#' @usage
#'   @@S3method generic class
#'   @@S3method generic
#'   @@S3method
#' @rdname tag-export
setClass("TagS3method", contains = "Tag",
  list("methods" = "character"))
setMethod("procBlock", "TagExportPattern", function(tag, block) {
  s3method <- words_tag(0, 2)(tag@text)

  n <- length(s3method)
  if (n == 0) return()
  if (n == 2) return()

  if (s3method == "") {
    # Empty, so guess from name
    pieces <- s3_method_info(block@obj@value)
    generic <- pieces[1]
    class <- pieces[2]
  } else {
    generic <- s3method
    class <- str_replace(block@obj@name, fixed(str_c(generic, ".")), "")
  }

  modify_block(block,
    S3method = list(methods = cbind(generic, class)))
})

setMethod("writeNamespace", "TagS3method", function(tag) {
  if (is.vector(tag@methods)) {
    methods <- matrix(methods, ncol = 2)
  } else {
    methods <- tag@methods
  }
  
  str_c("S3method(", quote_if_needed(methods[, 1]), ",",
    quote_if_needed(methods[, 2]), ")", collapse = "\n")
})
