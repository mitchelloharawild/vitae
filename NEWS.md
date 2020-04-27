# vitae 0.2.2

## Bug fixes

* This patch resolves knit issues introduced by tibble v3.0.0.

# vitae 0.2.1

## Bug fixes

* Fixed issue with `bibliography_entries()` not working on Windows.
* Fixed issue with using `brief_entires()` / `detailed_entries()` mismatching argument order in variable names

# vitae 0.2.0

## Breaking changes

* Simplified `bibliography_entries` entries by removing `title` and `sorting`
  arguments. The title can be included using markdown, and sorting now respects
  the order of the tibble created by the function.

## Improvements

* Added theme support for `moderncv`: classic, banking, oldstyle, fancy.
* Added `latexcv` template using the classic theme.
* Added `docname` to change the document name (@chrisumphlett, #42).
* Added support for template specific formatting of surnames with `surname`.
* Added *Data sources for vitae* vignette for using CV data from extermal sources.
* Added surnames to bibliography_entries dataset.
* Improved usage of dplyr verbs for manipulating and re-ordering outputs.
* Extended skeleton template to include examples of using CV functions.
* Bugfixes and documentation improvements.

# vitae 0.1.0

First release of the package, containing:
* Four CV templates: `hyndman`, `twentyseconds`, `awesomecv`, `moderncv`.
* Three CV entries functions: `detailed_entries()`, `brief_entries()` and
  `bibliography_entries()`.
* Two vignettes: *Creating vitae templates* and *Introduction to vitae*.
