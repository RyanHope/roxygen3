roc_examples <- basic_roccer("examples", text_tag())

roc_example <- roccer("example", 
  roc_parser(tag = words_tag(),
    one = function(roc, path, ...) {
      if (is.null(roc[["example"]])) return()
      
      paths <- file.path(dirname(path), str_trim(roc[["example"]]))
      examples <- unlist(lapply(paths, readLines))

      list(examples = c(roc[["examples"]], examples))
    }
  ) 
)
