# guluswm

R data package of the Gulu City household solid waste study (household
survey and seven day waste characterisation, September and October 2026),
built with washr 1.2.0 for openwashdata. Read this before changing anything.

## Files that stay out of git

- `data-raw/Gulu_SWM_OpenWashData.xlsx` is the raw input: the authors'
  re-export of 30 October 2026, sent on 2 November 2026. It has no
  coordinates, Original ID or Response Code, but still holds the
  enumerators' mWater user names and two free text columns, so
  `.gitignore` keeps it out of the repository until the authors send the
  final copy with coded enumerators (they asked for the code list). That
  final copy becomes the archived raw data. Never add an xlsx of the
  authors with `git add -f`.
- `data-raw/Gulu_SWM_Complete_Field_data.xlsx` is the first workbook of
  27 October 2026, with coordinates and names. It is no longer read.
- `dev/source/` holds the unpublished draft manuscript, its supplement and
  the authors' reply of 2 November 2026 (`2026-11-02-author-response/`:
  answered questions, answered dictionary, the re-export and
  `02112026_Gulu_SWM_Data_and_Figures.xlsx`, which has every original
  column including coordinates). Reference material only. Do not commit
  it, do not quote the manuscript's results in files of this repository,
  in issues or in commit messages beyond what the README already says. The
  repository is private while the manuscript is unpublished. The revised
  manuscript is a Google Doc of the authors.

## Decisions recorded in the processing script

- At the authors' decision (2 November 2026, Q11 to Q13): no household
  coordinates (the consent did not cover locations), enumerators as codes
  (E1 to E5, alphabetical order of the user names, the same code in both
  tables), no free text answers.
- `data-raw/guluswm_additional_data.csv` (from
  `data-raw/extract_additional_data.R`) holds the authors' survey weight,
  wealth index indicators, score and class per household; the script joins
  weight, score and class to the survey table.
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
source("data-raw/data_processing.R")   # needs the ignored raw workbook
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
when the review starts. The PII decision is made (issue 2); the review can
start once the final raw copy is in.
