setClass("TagUsage", contains = "Tag",
  list(usage = "Usage"),
  prototype = list(usage = new("NullUsage")))

setMethod("procTag", "TagUsage", function(tag) {
  if (!is.null(tag@usage)) return(tag)
  
  tag@usage <- new("TextUsage", usage@text)
  tag
})

setMethod("defaultTag", c("TagUsage", "FunctionObject"), 
  function(tag, object) {
    if (object@name == "subs") browser()
    
    usage <- new("FunctionUsage", 
      name = object@name,
      formals = as.list(formals(object@value)))
    new("TagUsage", usage = usage)
  }
)
setMethod("defaultTag", c("TagUsage", "S3MethodObject"), 
  function(tag, object) {
    method <- s3_method_info(object@value)
    
    usage <- new("S3MethodUsage", 
      generic = method[1],
      signature = method[2],
      formals = as.list(formals(object@value)))
    new("TagUsage", usage = usage)
  }
)
setMethod("defaultTag", c("TagUsage", "S4MethodObject"), 
  function(tag, object) {
    obj <- object@value
    usage <- new("S4MethodUsage", 
      generic = obj@generic,
      signature = obj@defined,
      formals = as.list(formals(obj@.Data)))
    new("TagUsage", usage = usage)
  }
)

setMethod("defaultTag", c("TagUsage", "DataObject"), 
  function(tag, object) {
    usage <- new("TextUsage", text = object@name)
    new("TagUsage", usage = usage)
  }
)

