# guluswm

R data package of the Gulu City household solid waste study (household
survey and seven day waste characterisation, September and October 2026),
built with washr 1.2.0 for openwashdata. Read this before changing anything.

## Files that stay out of git

- `data-raw/Gulu_SWM_Complete_Field_data.xlsx` is the authors' original
  workbook. It holds household coordinates and the enumerators' mWater user
  names, so `.gitignore` keeps it out of the repository until the authors
  and the maintainer have decided what may be published (issue labelled
  `pii`). Never add it with `git add -f`. The processing script reads it
  from this path; without the file the script cannot run, the committed
  `data/` and `inst/extdata/` are the current result.
- `dev/source/` holds the unpublished draft manuscript and its supplement
  (docx and a pandoc markdown copy). They are reference material for this
  package only. Do not commit them, do not quote their results in files of
  this repository, in issues or in commit messages beyond what the README
  already says. The repository is private while the manuscript is
  unpublished.

## Decisions recorded in the processing script

- The household coordinates, the identifiers that carry an enumerator's
  name (`Original ID`, `Response Code`) and the three free text answers of
  the survey are not in the data objects. The enumerator is kept as a code
  (E1 to E5, alphabetical order of the user names, the same code in both
  tables). The mapping exists only in the raw workbook.
- The survey sheet spells one area "Pabwo Quarters"; the package uses
  "Pabbo Quarters" as the characterisation sheet and the manuscript do.
- Ordered categories (education, income and expenditure bands, income
  class, distance, fee and willingness to pay bands, fee rating) are
  factors with the questionnaire's order. Multi-answer questions stay as
  one string with answers separated by a semicolon.
- Every variable description in `data-raw/dictionary.csv` is an agent
  draft (also in `dev/drafts/dictionary-descriptions.csv`) and waits for
  confirmation by the authors.

## Rebuilding

From the package root, in this order:

```r
source("data-raw/data_processing.R")   # needs the ignored raw workbook
washr::update_dictionary()
devtools::document()
washr::update_metadata()
devtools::build_readme()
```

`Rscript analysis/validate_data.R` recomputes the manuscript's figures
from the data objects and prints the checks the author questions rest on.
`washr::check_publication_readiness()` and `devtools::check()` must stay
clean.

The pkgreview standards file (`/review-package`) is appended to this file
when the review starts; do not start the review before the PII decision.
