#' Namespace: tags for importing functions.
#'
#' By and large, \code{@@autoImports} should be the only imports
#' tag that you need to use. It automatically generates the necessary
#' \code{importFrom} statements to import all external functions used by this
#' function.  See \code{\link{auto_imports}} for more implementation details.
#'
#' If there is a conflict, use \code{tag_importFrom} to resolve it. You can do
#' \code{@@importFrom base function} - this is not normally allowed in the
#' \file{NAMESPACE}, but roxygen3 will simply ignore it, but still use it when
#'  resolving conflicts.
#'
#' You must have the packages declared in \code{DESCRIPTION} Imports.
#'
#'
#' @usageTag @@importFrom package function1 function2
#' @rdname tag-import
#' @autoImports
setClass("ImportFromTag", contains = "Tag", representation(
  imports = "character"))

setMethod("format", "ImportFromTag", function(x, ...) x@imports %||% x@text)

setMethod("procTag", "ImportFromTag", function(tag) {
  if (length(tag@text) == 0) return(tag)

  pieces <- str_split(tag@text, "[[:space:]]+")[[1]]
  if (length(pieces) < 2) {
    stop("@importFrom needs at least two components.", call. = FALSE)
  }
  tag@imports <- c(tag@imports,
    setNames(rep(pieces[1], length(pieces[-1])), pieces[-1]))
  tag
})
setMethod("writeNamespace", "ImportFromTag", function(object) {
  imports <- object@imports

  imports <- imports[imports != "base"]
  if (length(imports) == 0) return()

  str_c("importFrom(", imports, ",", quote_if_needed(names(imports)), ")")
})

#' @rdname tag-import
#' @usageTag @@autoImports
#' @autoImports
setClass("AutoImportsTag", contains = "Tag")
setMethod("procBlock", "AutoImportsTag", function(tag, block) {
  obj <- block@object
  if (!is.function(obj@value)) return(block)

  importFrom <- block@tags$importFrom
  auto <- auto_imports(obj@value, obj@name, importFrom)

  if (!is.null(importFrom)) {
    importFrom@imports <- c(importFrom@imports, auto)
  } else {
    importFrom <- new("ImportFromTag", imports = auto)
  }

  tag(block, "importFrom") <- importFrom
  tag(block, "autoImport") <- NULL
  block
})

setMethod("getPrereqs", "AutoImportsTag", function(tag) {
  "ImportFromTag"
})

#' @rdname tag-import
#' @usageTag @@import package1 package2 package3
setClass("ImportTag", contains = "Tag")
setMethod("procTag", "ImportTag", function(tag) {
  tag@text <- str_split(tag@text, " ")[[1]]
  tag
})
setMethod("writeNamespace", "ImportTag", function(object) {
  ns_each("import", object@text)
})

#' @rdname tag-import
#' @usageTag @@importClassesFrom package fun1 fun2
setClass("ImportClassesFromTag", contains = "Tag")
setMethod("procTag", "ImportClassesFromTag", function(tag) {
  tag@text <- str_split(tag@text, " ")[[1]]
  tag
})
setMethod("writeNamespace", "ImportClassesFromTag", function(object) {
  ns_repeat1("importClassesFrom",object@text)
})

#' @rdname tag-import
#' @usageTag @@importMethodsFrom package fun1 fun2
setClass("ImportMethodsFromTag", contains = "Tag")
setMethod("procTag", "ImportMethodsFromTag", function(tag) {
  tag@text <- str_split(tag@text, " ")[[1]]
  tag
})
setMethod("writeNamespace", "ImportMethodsFromTag", function(object) {
  ns_repeat1("importMethodsFrom",object@text)
})
