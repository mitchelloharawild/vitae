context("test-templates")

skip_on_cran()
skip_on_ci()

expect_knit <- function(template){
  expect_output(
    expect_message(
      rmarkdown::render(
        system.file("rmarkdown", "templates", template, "skeleton", "skeleton.Rmd", package = "vitae"),
        output_file = sprintf("%s-test", template),
        output_dir = file.path(getwd(), "rendered")),
    "Output created"),
  "pandoc")
}

test_that("hyndman", {
  expect_knit("hyndman")
})

test_that("twentyseconds", {
  expect_knit("twentyseconds")
})

test_that("awesomecv", {
  expect_knit("awesomecv")
})

test_that("moderncv", {
  expect_knit("moderncv")
})

test_that("latexcv", {
  expect_knit("latexcv")
})
test_that("markdowncv", {
  expect_knit("markdowncv")
})
