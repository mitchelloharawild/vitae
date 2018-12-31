context("test-entries")

test_that("brief_entries", {
  entries <- test_entries %>%
    brief_entries(what, date, with) %>%
    distinct
  expect_s3_class(entries, "vitae_brief")
  print <- knitr::knit_print(entries)

  expect_match(print, "briefsection")
  expect_equal(NROW(entries), 2)
  expect_equal(stringr::str_count(print, "briefitem"), 2)

  expect_equal(stringr::str_count(print, "Award"), 1)
  expect_equal(stringr::str_count(print, "testthat"), 2)
  expect_match(print, as.character(Sys.Date() - 10))
})

test_that("detailed_entries", {
  entries <- test_entries %>%
    detailed_entries(what, date, with, at, extra)
  expect_s3_class(entries, "vitae_detailed")
  print <- knitr::knit_print(entries)

  expect_match(print, "detailedsection")
  expect_equal(NROW(entries), 2)
  expect_equal(stringr::str_count(print, "detaileditem"), 2)

  expect_equal(stringr::str_count(print, "\\\\item"), 2)

  expect_equal(stringr::str_count(print, "\\\\_\\\\&*"), 1)
  expect_equal(stringr::str_count(print, "Mars"), 1)
  expect_match(print, as.character(Sys.Date() - 10))

  entries <- test_entries %>%
    detailed_entries(what, date, with, at, extra, .protect = FALSE)
  expect_s3_class(entries, "vitae_detailed")
  print <- knitr::knit_print(entries)

  expect_match(print, "detailedsection")
  expect_equal(NROW(entries), 2)
  expect_equal(stringr::str_count(print, "detaileditem"), 2)

  expect_equal(stringr::str_count(print, "\\\\item"), 2)

  expect_equal(stringr::str_count(print, "\\_\\&*"), 1)
  expect_equal(stringr::str_count(print, "Mars"), 1)
  expect_match(print, as.character(Sys.Date() - 10))
})



test_that("bibliography_entries", {
  tmpbib <- tempfile()
  knitr::write_bib(c("vitae", "testthat"), file = tmpbib)

  entries <- bibliography_entries(tmpbib)

  expect_s3_class(entries, "vitae_bibliography")
  print <- knitr::knit_print(entries)

  expect_match(print, "defbibheading")
  expect_equal(NROW(entries), 2)

  expect_match(print, "vitae")
  expect_match(print, "testthat")
})
