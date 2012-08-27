context("Parse")

test_that("empty file gives empty list", {
  out <- parse_block("")
  expect_identical(out, list())
})

test_that("NULL gives empty list", {
  out <- parse_block("NULL")
  expect_identical(out, list())
})

test_that("single comment gives empty list", {
  out <- parse_block("# comment")
  expect_identical(out, list())
})

test_that("commented out roxygen block gives empty list", {
  out <- parse_block("# #' comment")
  expect_identical(out, list())
})

test_that("empty roxygen comment doesn't give error", {
  parse_block("#'\nNULL")
})


test_that("`$` not to be parsed as assignee in foo$bar(a = 1)", {
  out <- test_process("
    #' foo object
    foo <- list(bar = function(a) a)
    foo$bar(a = 1)")
    
    expect_equal(out$name, "foo")
})

test_that("@noRd inhibits rd, but not namespace output", {
  rocblock <- test_process("
    #' Would be title
    #' @title Overridden title
    #' @name a
    #' @noRd
    NULL")
  out <- roxy_out(list(rocblock))
  expect_equal(length(out$rd_out), 0)
})

