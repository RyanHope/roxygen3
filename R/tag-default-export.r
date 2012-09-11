setClass("TagDefaultExport", contains = "Tag", list( 
  exports = "character", 
  exportMethods = "character", 
  exportClass = "character",
  S3method = "matrix"
))

setMethod("defaultTag", c("TagDefaultExport", "FunctionObject"), 
  function(tag, object) {
    new("TagDefaultExport", exports = object@name)
  }
)
setMethod("defaultTag", c("TagDefaultExport", "S4MethodObject"), 
  function(tag, object) {
    gen <- as.vector(object@value@generic) 
    new("TagDefaultExport", exportMethods = gen)    
  }
)
setMethod("defaultTag", c("TagDefaultExport", "S3MethodObject"), 
  function(tag, object) {
    s3 <- s3_method_info(object@value)
    new("TagDefaultExport", S3method = matrix(s3, ncol = 2))
  }
)
setMethod("defaultTag", c("TagDefaultExport", "S3GenericObject"), 
  function(tag, object) {
    all <- all_s3_methods(environment(object@value))
    matching <- all[all[, 1] == object@name, ]

    new("TagDefaultExport", S3method = matching, exports = object@name)
  }
)
setMethod("defaultTag", c("TagDefaultExport", "S4ClassObject"), 
  function(tag, object) {
    new("TagDefaultExport", exportClass = as.vector(object@value@className))
  }
)

