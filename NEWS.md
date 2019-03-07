# vitae 0.1.0.9000

* Added support for other `moderncv` themes: classic, banking, oldstyle, fancy
* Simplified `bibliography_entries` entries by removing `title` and `sorting`
  arguments. The title can be included using markdown, and sorting now respects
  the order of the tibble created by the function.
* Bugfixes

# vitae 0.1.0

First release of the package, containing:
* Four CV templates: `hyndman`, `twentyseconds`, `awesomecv`, `moderncv`.
* Three CV entries functions: `detailed_entries()`, `brief_entries()` and
  `bibliography_entries()`.
* Two vignettes: *Creating vitae templates* and *Introduction to vitae*
