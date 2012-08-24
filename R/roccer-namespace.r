ns_roccer <- function(name, input, output) {
  roccer(name, 
    roc_parser(tag = input),
    namespace_out(output))
}

# But how would you document these? Generally, how to do you create and
# document bundles of related roccers?

ns_each <- function(directive) {
  function(values) {
    lines(directive, "(", values, ")")
  }
}
ns_call <- function(directive) {
  function(values) {
    args <- paste(names(values), " = ", values, collapse = ", ", sep = "")
    lines(directive, "(", args, ")")
  }
}
ns_repeat1 <- function(directive) {
  function(values) {
    lines(directive, "(", values[1], ",", values[-1], ")")
  }
}

lines <- function(...) paste(..., sep = "", collapse = "\n")

ns_import <- ns_roccer(
  "import", 
  words_tag(), 
  ns_each("import")
)
ns_import_from <- ns_roccer(
  "importFrom", 
  words_tag(), 
  ns_repeat1("importFrom")
)
ns_import_classes_from <- ns_roccer(
  "importClassesFrom", 
  words_tag(), 
  ns_repeat1("importClassesFrom")
)
ns_import_methods_from <- ns_roccer(
  "importMethodsFrom", 
  words_tag(), 
  ns_repeat1("importMethodsFrom")
)
ns_use_dyn_lib <- ns_roccer(
  "useDynLib", 
  arguments_tag(), 
  ns_each("useDynLib")
)
ns_s3_method <- roccer("S3method",
  roc_parser(
    words_tag(0, 2),
    one = function(roc, obj, ...) {
      n <- length(roc$S3method)
      if (n == 0) return(list())
      if (n == 2) return(list())
      
      if (roc$S3method == "") {
        # Empty, so guess from name
        pieces <- str_split_fixed(obj$name, fixed("."), n = 2)[1, ]
        generic <- pieces[1]
        class <- pieces[2]
      } else {
        generic <- roc$S3method
        class <- str_replace(obj$name, fixed(str_c(generic, ".")), "")
      }
      list(S3method = c(generic, class))
  }),
  namespace_out(ns_repeat1("S3method"))
)

# process_tag(partitum, "S3method", ns_S3method),
# process_tag(partitum, "importFrom", ns_collapse),
# process_tag(partitum, 'exportClass', ns_exportClass),
# process_tag(partitum, 'exportMethod', ns_exportMethod),
# process_tag(partitum, 'exportPattern', ns_default),
# 
# process_tag(partitum, "export", ns_export),


# Also need to think about more consistent naming scheme:
# 
# @ns_dynlib
# @ns_method_s3
# @ns_import_from
# @ns_import_classes_from 
# 
# Would be fairly easy to write wrapper function so that 
# old names continue to work, but give deprecation message:
# 
# new_name("ns_dyn_lib", dynlib_tag())