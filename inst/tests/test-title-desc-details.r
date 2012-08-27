content("Title, description, details")

test_that("title and description taken from first line if only one", {
  out <- block_parse("
    #' description
    #' @name a
    NULL")
  expect_equal(out$description, "description")
  expect_equal(out$title, "description")
})

test_that("title, description and details extracted correctly", {
  out <- block_parse("
    #' title
    #'
    #' description
    #'
    #' details
    #' @name a
    NULL")
  expect_equal(out$description, "description")
  expect_equal(out$details, "details")
})

test_that("title taken from first paragraph", {
  out <- block_parse("
    #' Description with sentence. 
    #'
    #' That continueth.
    #' @name a
    NULL")
  expect_equal(out$title, "Description with sentence.")
  expect_equal(out$description, 
    "That continueth.")
})

test_that("@title overrides default title", {
  out <- block_parse("
    #' Would be title
    #' @title Overridden title
    #' @name a
    NULL")
  expect_equal(out$title, "Overridden title")
  expect_equal(out$description, "Would be title")
})

test_that("docs parsed correctly if no blank text", {
  out <- block_parse("
    #' @title My title
    #' @description My description
    #' @param x value
    a <- function(x) {}")
  
  expect_equal(out$title, "My title")
  expect_equal(out$description, "My description")
})

test_that("question mark ends sentence", {
  out <- block_parse("
    #' Is a number odd?
    is.odd <- function(a) {}")
  expect_equal(out$title, "Is a number odd?")
  
})

test_that("no ending punctuation does not produce ellipsis", {
  out <- block_parse("
    #' Whether a number is odd
    is.odd <- function(a) {}")
  expect_equal(out$title, "Whether a number is odd")
})