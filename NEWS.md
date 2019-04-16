# vitae 0.1.0.9000

## Breaking changes
* Simplified `bibliography_entries` entries by removing `title` and `sorting`
  arguments. The title can be included using markdown, and sorting now respects
  the order of the tibble created by the function.

## Improvements
* Added support for other `moderncv` themes: classic, banking, oldstyle, fancy.
* Added support for controlling document name with `docname` (@chrisumphlett, #42).
* Added vignette for obtaining CV data from various sources.
* Added surnames to bibliography_entries dataset.
* Better support for manipulating and re-ordering output using dplyr verbs.
* Bugfixes.

# vitae 0.1.0

First release of the package, containing:
* Four CV templates: `hyndman`, `twentyseconds`, `awesomecv`, `moderncv`.
* Three CV entries functions: `detailed_entries()`, `brief_entries()` and
  `bibliography_entries()`.
* Two vignettes: *Creating vitae templates* and *Introduction to vitae*.
