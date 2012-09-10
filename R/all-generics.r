setGeneric("usage", function(value, name, srcref) {
  standardGeneric("usage")
})

setGeneric("writeRd", function(object) {
  standardGeneric("writeRd")
})
setGeneric("writeNamespace", function(object) {
  standardGeneric("writeNamespace")
})
setGeneric("writeDescription", function(object) {
  standardGeneric("writeDescription")
})
setGeneric("getPrereqs", function(tag) {
  standardGeneric("getPrereqs")
}, valueClass = "character")

setGeneric("process", function(input) {
  standardGeneric("process")
})

setGeneric("isNull", function(x) standardGeneric("isNull"))
setMethod("isNull", "NULL", function(x) TRUE)
setMethod("isNull", "ANY", function(x) FALSE)

