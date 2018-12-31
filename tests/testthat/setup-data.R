test_entries <- data.frame(
  what = c("Award", "Award", "_&*!@#"),
  date = c(Sys.Date() - 10, Sys.Date() - 10, Sys.Date()),
  with = c("testthat", "testthat", "testthat"),
  at = c("Earth", "Earth", "Mars"),
  extra = c("first success", "second success", NA)
)
