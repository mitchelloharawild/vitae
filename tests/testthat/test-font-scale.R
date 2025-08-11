skip_if_not(file.exists(system.file("rmarkdown","templates","awesomecv","resources","awesome-cv.tex", package = "vitae")))

test_that("font_size_scaling injects xfp, defines ACVscale, and rewrites \\fontsize", {
  cls <- tempfile(fileext = ".cls")
  writeLines(c(
    "\\ProvidesClass{awesome-cv}",
    "\\RequirePackage[quiet]{fontspec}",
    "\\newcommand*{\\headerfirstnamestyle}[1]{{\\fontsize{32pt}{1em}#1}}",
    "\\newcommand*{\\entrytitlestyle}[1]{{\\fontsize{10pt}{1em}#1}}"
  ), cls)

  font_size_scaling(scale = 1.10, file_path = cls)

  out <- readLines(cls, warn = FALSE)
  expect_true(any(grepl("\\\\usepackage\\{xfp\\}", out)))
  expect_equal(sum(grepl("\\\\providecommand\\\\ACVscale\\{1\\}", out)), 1L)
  expect_true(any(grepl("\\\\renewcommand\\\\ACVscale\\{1\\.10", out)))
  expect_true(any(grepl("\\\\fontsize\\{\\\\fpeval\\{32\\*\\\\ACVscale\\}pt\\}\\{1em\\}", out)))
  expect_true(any(grepl("\\\\fontsize\\{\\\\fpeval\\{10\\*\\\\ACVscale\\}pt\\}\\{1em\\}", out)))

  # Run again with a different scale: updates, no duplicates
  font_size_scaling(scale = 0.95, file_path = cls)
  out2 <- readLines(cls, warn = FALSE)
  expect_equal(sum(grepl("\\\\usepackage\\{xfp\\}", out2)), 1L)
  expect_equal(sum(grepl("\\\\providecommand\\\\ACVscale\\{1\\}", out2)), 1L)
  expect_true(any(grepl("\\\\renewcommand\\\\ACVscale\\{0\\.95", out2)))
})

test_that("awesomecv copies resources and conditionally patches class", {
  tmp <- tempfile("vitae-fontscale-")
  dir.create(tmp)
  old <- getwd()
  on.exit({ setwd(old); unlink(tmp, recursive = TRUE, force = TRUE) }, add = TRUE)
  setwd(tmp)

  # No patch when font_scale = 1
  awesomecv(font_scale = 1)
  expect_true(file.exists("awesome-cv.cls"))
  base_cls <- readLines("awesome-cv.cls", warn = FALSE)
  expect_false(any(grepl("\\\\usepackage\\{xfp\\}", base_cls)))
  expect_false(any(grepl("\\\\ACVscale", base_cls)))
  expect_false(any(grepl("\\\\fontsize\\{\\\\fpeval\\{", base_cls)))

  # Patch when font_scale != 1
  awesomecv(font_scale = 1.05)
  patched <- readLines("awesome-cv.cls", warn = FALSE)
  expect_true(any(grepl("\\\\usepackage\\{xfp\\}", patched)))
  expect_true(any(grepl("\\\\renewcommand\\\\ACVscale\\{1\\.05", patched)))
  expect_true(any(grepl("\\\\fontsize\\{\\\\fpeval\\{[0-9.]+\\*\\\\ACVscale\\}pt\\}\\{", patched)))
})
