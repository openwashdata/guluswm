# guluswm

R data package of the Gulu City household solid waste study (household
survey and seven day waste characterisation, September and October
2026), built with washr for openwashdata. Released as 1.0.0 on 3
November 2026 (DOI 10.5281/zenodo.23918126); the repository and the
website (<https://openwashdata.github.io/guluswm/>) are public. dev
carries the development version. Read this before changing anything.

## Raw data and files that stay out of git

- `data-raw/Gulu_SWM_OpenWashData_final.xlsx` is the archived raw data:
  the authors’ corrected final copy of 3 November 2026 with coded
  enumerators (E1 to E5), no coordinates, no identifiers carrying names
  and no free text. Its third sheet holds the authors’ survey weight and
  wealth index. It is committed.
- Every earlier workbook of the authors (with coordinates, enumerator
  user names or free text) is git-ignored and lives in `dev/source/`.
  Never add one with `git add -f`.
- `dev/source/` holds the unpublished draft manuscript, its supplement,
  the first workbook and the authors’ replies of 2 and 3 November 2026
  (`2026-11-02-author-response/`). Reference material only. Do not
  commit it, do not quote the manuscript’s results in files of this
  repository, in issues or in commit messages. The revised manuscript is
  a Google Doc of the authors.
- Package texts (README, DESCRIPTION Description, @source) describe the
  data only and do not mention the manuscript. Once the article is
  published, Ivan Feni sends its DOI; then add the article reference to
  the README, the Description, the @source blocks and the Zenodo record.

## Decisions recorded in the processing script

- At the authors’ decision (2 November 2026, Q11 to Q13): no household
  coordinates (the consent did not cover locations), enumerators as
  codes (E1 to E5, alphabetical order of the user names, the same code
  in both tables), no free text answers. At their decision of 3 November
  2026 the household ID carries the enumerator code instead of the
  enumerator’s initials (E1-2309-001); the script re-keys it and checks
  the pattern.
- The script joins the authors’ survey weight, wealth index score and
  class (third sheet of the raw file) to the survey table. Ties of the
  score were ranked by file order, so the class cut splits one tied
  group.
- The survey sheet spells one area “Pabwo Quarters”; the package uses
  “Pabbo Quarters”, confirmed by the authors.
- Ordered categories (education, income and expenditure bands, income
  class, wealth index class, distance, fee and willingness to pay bands,
  fee rating) are factors with the questionnaire’s order. Multi-answer
  questions stay as one string with answers separated by a semicolon.
- The variable descriptions in `data-raw/dictionary.csv` are confirmed
  by the authors (2 November 2026) and carry their answers.
  `dev/drafts/dictionary-descriptions.csv` is the superseded agent
  draft.

## Rebuilding

From the package root, in this order:

``` r

source("data-raw/data_processing.R")   
# then rewrite the \\describe blocks of R/*.R from data-raw/dictionary.csv
washr::update_dictionary()
devtools::document()
washr::update_metadata()
devtools::build_readme()
```

`Rscript analysis/validate_data.R` recomputes summary figures of the
study from the data objects and prints the checks the author questions
rest on; `Rscript analysis/data_quality.R` reports missing values,
duplicates, ranges and cross-field checks.
`washr::check_publication_readiness()` and `devtools::check()` must stay
clean.

The pkgreview standards file (standard 1.7.0) was appended below when
the review started on 3 November 2026 (issues \#9, \#11, \#13, \#15,
final PR \#17). At the next release, add `Config/washr/withheld` to
DESCRIPTION (household coordinates and free text answers are not
included, to protect the privacy of the respondents), so
`washr::data_availability_statement()` writes that sentence. This file
moves to `.claude/CLAUDE.md` in the fleet pass after washr 1.3.0
(openwashdata/pkgreview#102).

# — pkgreview standards (from openwashdata/pkgreview) —

# openwashdata package standards

Standard version: 1.7.0 Organization profile: openwashdata Source:
<https://github.com/openwashdata/pkgreview>

This package was reviewed against the pkgreview standards recorded in
this file, applied with the openwashdata organization profile. It guides
every future Claude session working in this package, including sessions
by student contributors and external collaborators who have no review
tooling installed. Do not delete this file: it is the only record of
which standard version and organization profile this package was
reviewed against. The `/review-package` command writes it at review
start; the stamps above pin the standard and the org values for the
whole review.

Note: pkgdown renders every top-level `.md` file, so this file appears
on the package website as `CLAUDE.html`. That is accepted behavior (it
publicly records the standard the package was reviewed against); pkgdown
offers no configuration to exclude it. Do not delete the file to hide
it.

## Required floor and advisory tier

The standard has two tiers. Required items are the publication floor and
block publication: raw data preserved in `data-raw/` with a processing
script, the PII and sensitivity check done up front, a description of
the data, a dictionary with a description per variable, plus the
publication mechanics (CC BY 4.0 license, valid citation files,
`devtools::check()` passes, data loads, `.rda` in `data/` with CSV/XLSX
exports in `inst/extdata/`, the website deployed by the pkgdown
workflow). Advisory items are quality improvements (for example
tidyverse style in the processing script or NA coding); fix them when
practical, record the rest as optional follow-ups, and never let them
block publication.

## Rules a future session must not undo

- PII and sensitivity come first: no data is pushed anywhere public
  before the PII and sensitivity check has run over the column names and
  sampled values of every dataset. The check covers every revision in
  the git history, not only the current files: identifying data removed
  in an earlier commit stays recoverable from any clone, so a clean
  working tree is not enough. No direct identifiers (person names, phone
  numbers, email addresses, national or beneficiary IDs, household-level
  GPS coordinates) in any data file or in any historical revision.
  Household- or person-level data requires a named human sign-off on the
  review issue; an agent never certifies this on its own. Identifying
  data found in the history blocks publication until the history is
  cleaned.
- `data-raw/dictionary.csv` covers every variable in every dataset, each
  with a one-sentence plain-language description. The description is the
  most important field; it is written or confirmed by a human, never
  invented by an agent. The file keeps the five washr columns
  (`directory`, `file_name`, `variable_name`, `variable_type`,
  `description`), UTF-8 without a byte order mark, one class name per
  `variable_type` value; the organization catalog parses it that way.
- Vignettes live in `vignettes/articles/`, never directly in
  `vignettes/`. This keeps pkgdown rendering correct and avoids CRAN
  issues.
- `_pkgdown.yml` follows the standard configuration below, including the
  analytics header and the funding sidebar from the organization
  profile, and the brand wiring when the profile defines a brand. Do not
  remove or reorganize these blocks.
- The website is deployed by the pkgdown GitHub Actions workflow
  (`.github/workflows/pkgdown.yaml`) to the `gh-pages` branch on every
  push to `main`. `docs/` is ignored and never committed; a local
  [`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html)
  is a preview only.
- Analysis, validation, and testing scripts live in `analysis/` at the
  package root. They are intentionally outside `R/` and are not built
  into the installed package. Do not move or delete them; they exist for
  reproducibility.
- The license is CC BY 4.0. Do not change it.
- Missing values are coded as `NA`, never as empty strings, “NULL”,
  “N/A”, or sentinel numbers such as -99.
- Keywords and coverage live in DESCRIPTION, in `X-schema.org-keywords`
  (comma separated), `X-schema.org-spatialCoverage` (a place name), and
  `X-schema.org-temporalCoverage` (`YYYY-MM-DD/YYYY-MM-DD`).
  `washr::update_citation()` carries the keywords into CITATION.cff and
  `washr::update_metadata()` reads all three into the site metadata; do
  not type keywords into CITATION.cff by hand.
- After editing DESCRIPTION, run `washr::update_description()`.
- After version or author changes, run `washr::update_citation()` so
  DESCRIPTION, CITATION.cff, and inst/CITATION stay in sync. It keeps a
  DOI already on file and owns the DOI badge in README.Rmd; do not edit
  the badge by hand. washr 1.2.0 or newer is the floor for these calls.
- Raw data stays in `data-raw/`, processed `.rda` data in `data/`, and
  CSV/XLSX exports in `inst/extdata/`.

## Package structure

    package-name/
    ├── DESCRIPTION
    ├── NAMESPACE
    ├── R/package-name.R          # roxygen data documentation
    ├── data/package-name.rda     # single dataset: named after the package
    ├── data-raw/
    │   ├── data_processing.R
    │   └── dictionary.csv
    ├── inst/
    │   ├── CITATION
    │   └── extdata/              # CSV and XLSX exports
    ├── man/
    ├── vignettes/articles/       # all vignettes go here
    ├── analysis/                 # analysis scripts, not built
    ├── pkgdown/templates/in-header.html   # schema.org JSON-LD from washr::update_metadata(), Rbuildignored
    ├── _brand.yml                # only when the org profile defines a brand (washr::use_brand())
    ├── logos/                    # the brand's logo files, same condition
    ├── README.Rmd / README.md
    ├── NEWS.md
    ├── CITATION.cff
    ├── _pkgdown.yml
    ├── .gitignore                # ignores docs/ (the site is built in CI)
    └── .github/workflows/
        ├── R-CMD-check.yaml      # washr::setup_ci(); triggers include dev
        └── pkgdown.yaml          # builds and deploys the site to gh-pages

Multi-dataset packages: one `.rda` in `data/` and one roxygen `.R` file
per dataset, each with a unique, descriptive name; no dataset is named
after the package. The `_pkgdown.yml` reference index lists every
dataset.

## Standard \_pkgdown.yml

Replace `packagename` with the actual package name. `url` is the site
base URL (canonical links, sitemap.xml, redirects), so it must be the
Pages URL, never the GitHub repo URL; the repo link lives in
`home.links`. The two commented `bslib` lines are written by
`washr::use_brand()` when the organization profile defines a brand (it
rewrites the file through the yaml package, which drops the comments);
leave them out otherwise.

``` yaml
url: https://openwashdata.github.io/packagename/
template:
  bootstrap: 5
  # bslib:
  #   brand: _brand.yml
  includes:
    in_header: |
      <script defer data-domain="openwashdata.github.io" src="https://plausible.io/js/script.js"></script>

home:
  links:
    - icon: github
      text: GitHub repository
      href: https://github.com/openwashdata/packagename
  sidebar:
    structure: [links, citation, authors, dev, custom]
    components:
      custom:
        title: Funding
        text: This project was funded by the [Open Research Data Program of the ETH Board](https://ethrat.ch/en/eth-domain/open-research-data/).

authors:
  footer:
    roles: [cre, fnd]
    text: "Crafted by"
  sidebar:
    roles: [cre, aut, ctb]
    before: "So *who* does the work?"
    after: "Thanks all!"

reference:
- title: "Data"
  desc: "Access the packagename dataset"
  contents:
  - packagename
```

Multi-dataset packages: list one entry per data object under `contents`,
each with its unique, descriptive name; none of them is named after the
package.

## Code style

- 2 spaces for indentation, no tabs; maximum 80 characters per line
- tidyverse style for R code; snake_case for functions and variables

## Useful commands

- Rebuild README: `R -e "devtools::build_readme()"`
- Rebuild documentation: `R -e "devtools::document()"`
- Full check: `R -e "devtools::check()"`
- Refresh the site metadata after DESCRIPTION, dictionary, or citation
  changes: `R -e "washr::update_metadata()"`
- Preview the website locally: `R -e "pkgdown::build_site()"` (writes
  the ignored `docs/`; the published site is built by the pkgdown
  workflow on the next push to `main`)
