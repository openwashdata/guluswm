# guluswm

R data package of the Gulu City household solid waste study (household
survey and seven day waste characterisation, September and October 2026),
built with washr 1.2.0 for openwashdata. Read this before changing anything.

## Raw data and files that stay out of git

- `data-raw/Gulu_SWM_OpenWashData_final.xlsx` is the archived raw data: the
  authors' final copy of 3 November 2026 with coded enumerators (E1 to E5),
  no coordinates, no identifiers carrying names and no free text. Its third
  sheet holds the authors' survey weight and wealth index. It is committed.
- Every earlier workbook of the authors (with coordinates, enumerator user
  names or free text) is git-ignored and lives in `dev/source/`. Never add
  one with `git add -f`.
- `dev/source/` holds the unpublished draft manuscript, its supplement,
  the first workbook and the authors' replies of 2 and 3 November 2026
  (`2026-11-02-author-response/`). Reference material only. Do not commit
  it, do not quote the manuscript's results in files of this repository,
  in issues or in commit messages beyond what the README already says. The
  repository is private while the manuscript is unpublished. The revised
  manuscript is a Google Doc of the authors.

## Decisions recorded in the processing script

- At the authors' decision (2 November 2026, Q11 to Q13): no household
  coordinates (the consent did not cover locations), enumerators as codes
  (E1 to E5, alphabetical order of the user names, the same code in both
  tables), no free text answers.
- The script joins the authors' survey weight, wealth index score and
  class (third sheet of the raw file) to the survey table. Ties of the
  score were ranked by file order, so the class cut splits one tied group.
- The survey sheet spells one area "Pabwo Quarters"; the package uses
  "Pabbo Quarters", confirmed by the authors.
- Ordered categories (education, income and expenditure bands, income
  class, wealth index class, distance, fee and willingness to pay bands,
  fee rating) are factors with the questionnaire's order. Multi-answer
  questions stay as one string with answers separated by a semicolon.
- The variable descriptions in `data-raw/dictionary.csv` are confirmed by
  the authors (2 November 2026) and carry their answers.
  `dev/drafts/dictionary-descriptions.csv` is the superseded agent draft.

## Rebuilding

From the package root, in this order:

```r
source("data-raw/data_processing.R")   
# then rewrite the \\describe blocks of R/*.R from data-raw/dictionary.csv
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
when the review starts. The PII decision is made and the final raw copy is in;
the review can start.
