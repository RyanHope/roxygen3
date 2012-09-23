#' Automatically add import statements.
#'
#' Using this tag will automatically add all external functions used by the
#' function to the namespace.  If there are any ambiguities (i.e. the same
#' name is used by multiple packages) you can resolve them using
#' \code{@@importFrom}
#'
#' @tagUsage @@autoImports
#' @autoImports
setClass("AutoImportsTag", contains = "Tag")
setMethod("process", "AutoImportsTag", function(input, block) {
  obj <- block@object
  tag(block, "autoImport") <- NULL
  if (!is.function(obj@value)) return(block)

  importFrom <- tag(block, "importFrom")
  auto <- auto_imports(obj@value, obj@name, value(importFrom))
  importFrom@imports <- c(importFrom@imports, auto)

  tag(block, "importFrom") <- importFrom
  block
})

setMethod("getPrereqs", "AutoImportsTag", function(tag) {
  "ImportFromTag"
})
