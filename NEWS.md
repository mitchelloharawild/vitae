# vitae 0.1.0.9000

## Breaking changes
* Simplified `bibliography_entries` entries by removing `title` and `sorting`
  arguments. The title can be included using markdown, and sorting now respects
  the order of the tibble created by the function.

## Improvements
* Added theme support for `moderncv`: classic, banking, oldstyle, fancy.
* Added `docname` to change the document name (@chrisumphlett, #42).
* Added support for template specific formatting of surnames with `surname`.
* Added vignette for obtaining CV data from various sources.
* Added surnames to bibliography_entries dataset.
* Improved usage of dplyr verbs for manipulating and re-ordering outputs.
* Extended skeleton template to include examples of using CV functions.
* Bugfixes.

# vitae 0.1.0

First release of the package, containing:
* Four CV templates: `hyndman`, `twentyseconds`, `awesomecv`, `moderncv`.
* Three CV entries functions: `detailed_entries()`, `brief_entries()` and
  `bibliography_entries()`.
* Two vignettes: *Creating vitae templates* and *Introduction to vitae*.
