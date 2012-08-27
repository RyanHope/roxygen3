#' @auto_imports
parse_intro <- function(roc, obj, ...) {
  if (!is.null(roc$`_intro`)) {
    paragraphs <- str_trim(str_split(roc$`_intro`, fixed('\n\n'))[[1]])
  } else {
    paragraphs <- NULL
  }

  # 1st paragraph = title (unless has @title)
  if (!is.null(roc$title)) {
    title <- roc$title
  } else if (length(paragraphs) > 0) {
    title <- paragraphs[1]
    paragraphs <- paragraphs[-1]
  } else {
    title <- NULL
  }

  # 2nd paragraph = description (unless has @description)
  if (!is.null(roc$description)) {
    description <- roc$description
  } else if (length(paragraphs) > 0) {
    description <- paragraphs[1]
    paragraphs <- paragraphs[-1]
  } else {
    # Description is required, so if missing description, repeat title.
    description <- title
  }

  # Every thing else = details, combined with @details.
  details <- c(paragraphs, roc$details)
  if (length(details) > 0) {
    details <- paste(details, collapse = "\n\n")
  } else {
    details <- NULL
  }
  
  list(
    `_intro` = NULL, 
    title = title, 
    description = description, 
    details = details
  )
}

#' Title, description and details.
#'
#' @usage The first line becomes the topic title.
#'
#' The next paragraph goes into the descrption section.  Any of these
#' sections can span multiple lines.
#'
#' The third and subsequent paragraph go into the details.
#'
#' @seealso \code{\link{tag_title}}, \code{\link{tag_description}},
#'  \code{\link{tag_details}} to set each component individually.
add_roccer("_intro", roc_parser(one = parse_intro))
base_prereqs[["_intro"]] <- c("title", "description", "details")
