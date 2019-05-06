context("test-templates")

expect_knit <- function(object){
  expect_output(expect_message(object, "Output created"), "pandoc")
}

test_that("hyndman", {
  expect_knit(
    rmarkdown::render(system.file("rmarkdown", "templates", "hyndman",
                                  "skeleton", "skeleton.Rmd",
                                  package = "vitae"
    ), output_file = out_pdf <- tempfile())
  )
  cat(file = paste0(out_pdf, ".log"))
})

test_that("twentyseconds", {
  expect_knit(
    rmarkdown::render(system.file("rmarkdown", "templates", "twentyseconds",
                                  "skeleton", "skeleton.Rmd",
                                  package = "vitae"
    ), output_file = out_pdf <- tempfile())
  )
  cat(file = paste0(out_pdf, ".log"))
})

test_that("awesomecv", {
  expect_knit(
    rmarkdown::render(system.file("rmarkdown", "templates", "awesomecv",
                                  "skeleton", "skeleton.Rmd",
                                  package = "vitae"
    ), output_file = out_pdf <- tempfile())
  )
  cat(file = paste0(out_pdf, ".log"))
})

test_that("moderncv", {
  expect_knit(
    rmarkdown::render(system.file("rmarkdown", "templates", "moderncv",
                                  "skeleton", "skeleton.Rmd",
                                  package = "vitae"
    ), output_file = out_pdf <- tempfile())
  )
  cat(file = paste0(out_pdf, ".log"))
})

test_that("latexcv", {
  expect_knit(
    rmarkdown::render(system.file("rmarkdown", "templates", "latexcv",
                                  "skeleton", "skeleton.Rmd",
                                  package = "vitae"
    ), output_file = out_pdf <- tempfile())
  )
  cat(file = paste0(out_pdf, ".log"))
})
