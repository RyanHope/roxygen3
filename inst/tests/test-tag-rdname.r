context("Tag: @rdname")

test_that("All rocs with the same @rdfile are merged into one", {
  out <- test_rd("
    #' Function a
    #' @param a a
    #' @rdname shared
    a <- function(a) {}

    #' Function b
    #' @param b a
    #' @rdname shared
    b <- function(b) {}
    ")

  shared <- out$`man/shared.Rd`
  expect_equal(length(shared$alias@values), 2)
  expect_equal(length(shared$arguments@values), 2)
  expect_equal(format(shared$title), "\\title{Function a}")

  usage <- format(shared$usage)
  expect_match(usage, fixed("a(a)"), all = FALSE)
  expect_match(usage, fixed("b(b)"), all = FALSE)
})

test_that("Manual usage lines are merged", {
  out <- test_rd("
    #' Function a
    #' @usage a() # a is for apple
    #' @rdname shared
    a <- function() {}

    #' Function b
    #' @usage b() # b is for ball
    #' @rdname shared
    b <- function() {}
    ")
  shared <- out$`man/shared.Rd`
  expect_equal(length(shared$usage@values), 2)
  expect_equal(shared$usage@values[[2]], "b() # b is for ball")

})

test_that("functions with non-syntactic characters are ok", {
  out <- test_rd("
    #' Change names.
    'names<-' <- function(x, value) {}

    #' Change values
    '[<-' <- function(x, value) {}
  ")

  expect_equal(names(out), c("man/names-set.Rd", "man/open-brace-set.Rd"))
})
