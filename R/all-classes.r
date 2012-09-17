setOldClass("srcref")
#' @export
setClass("NullSrcref", contains = "srcref")

#' @rdname Tag
#' @export
setClass("Tag", contains = "VIRTUAL",
  representation(
    text = "character",
    srcref = "srcref"
  ),
  prototype(
    text = character(),
    srcref = new("NullSrcref")
  )
)

#' The object being documented.
#'
#' @rdname Object
#' @export
#' @dev
setClass("Object",
  representation(
    name = "character",
    value = "ANY",
    srcref = "srcref",
    docType = "character"
  )
)
#' @export
setClass("NullObject", contains = "Object")

#' @rdname Usage
#' @export
setClass("Usage")
#' @export
setClass("NullUsage", contains = "Usage")

#' @rdname Block
#' @export
setClass("Block",
  representation(
    tags = "list",
    srcref = "srcref",
    object = "Object"
  ),
  prototype(
    tags = list(),
    srcref = new("NullSrcref"),
    object = new("NullObject")
  )
)

#' An object representing processing behaviour.
#'
#' @rdname Behaviour
#' @export
#' @dev
setClass("Behaviour",
  representation(
    tags = "character",
    processors = "character",
    writers = "character"
  )
)

#' An object representing a bundle of blocks in multiple files.
#'
#' @rdname Bundle
#' @export
#' @dev
setClass("Bundle",
  representation(
    blocks = "list",
    behaviour = "Behaviour"
  )
)

#' @rdname DirectoryBundle
#' @export
setClass("DirectoryBundle", contains = "Bundle",
  representation(
    path = "character"
  )
)

#' @rdname PackageBundle
#' @export
setClass("PackageBundle", contains = "DirectoryBundle",
  representation(
    name = "character"
  )
)
