sup_classes <- function(class) {
  if (is.character(class)) class <- getClass(class)
  lapply(class@contains, function(x) getClass(x@superClass, x@package))
}

sub_classes <- function(class) {
  if (is.character(class)) class <- getClass(class)
  lapply(class@subclasses, function(x) getClass(x@subClass, x@package))
}

slot_classes <- function(class) {
  if (is.character(class)) class <- getClass(class)
  class@slots
}

# describe(super_classes("PackageBundle"))
# describe(sub_classes("Tag"))
# describe(slot_classes("Tag"))

setGeneric("describe", function(x) standardGeneric("describe"))
setMethod("describe", "character", function(x) {
  classes <- lapply(x, getClass)
  describe(classes)
})
setMethod("describe", "list", function(x) {
  vapply(x, describe, character(1))
})
setMethod("describe", "classRepresentation", function(x) {
  if (extends(x, "oldClass")) {
    str_c(x@className, " (S3)")
  } else {
    str_c("\\linkS4class{", x@className, "} (S4)")
  }
})


