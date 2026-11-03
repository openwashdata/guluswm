# guluswm (development version)

- The README introduction, the source paragraph and the package description describe the data only; the reference to the article follows once it is published.

- `household_id` carries the enumerator code instead of the enumerator's initials (AC-2309-001 becomes E1-2309-001), at the authors' decision of 3 November 2026.

- Tests review: R CMD check runs on every push and pull request to main and dev on five platforms; no change needed (#15).

- Documentation review: the README states how `household_id` is built, as the help page does (#13).

- Data review: no change to the data. A data quality report (`analysis/data_quality.R`) counts missing values, duplicates, range and cross-field violations (none) and outliers; the household-level data are signed off for publication (#11).

- Metadata review: the package description names all nine authors of the data and the University of Stuttgart, and the citation files are regenerated (#9).

- The raw data are now the authors' final copy of 3 November 2026, archived
  in `data-raw/`: coded enumerators, no coordinates, no free text, and the
  wealth index and survey weights as a third sheet. A corrected copy of the
  same day restores the before-deduction weights of inert fines and
  miscellaneous waste of the 30 October re-export (the first copy had
  rounded them, swapped them between CH-1002-021 and CH-1002-022 and left
  one blank); the net weights are unchanged. The tie rule of `wealth_index_class` is documented. Charles
  Wakhata (logistics, support to the enumeration and the waste
  characterisation) and the four enumerators are listed as authors of the
  data, between the article's authors and its last author.

- Answers of the authors of 2 November 2026: the raw data are now their
  corrected re-export of 30 October 2026, in which sand and soil entered as
  miscellaneous waste in Limo and Vanguard are moved to inert fines (29
  records; the per capita rate without inert fines changes in 49). The
  survey table gains `survey_weight`, `wealth_index_score` and
  `wealth_index_class` (46 variables). ORCID iDs, Charles Wakhata as
  contributor, the funding of the fieldwork and the confirmed variable
  descriptions are added. Coordinates, enumerator names and free text stay
  out at the authors' decision.

- First build of the package from the authors' field data workbook: two
  data objects, `guluswm_survey` (424 households, 43 variables) and
  `guluswm_waste` (95 households, 55 variables), a dictionary with drafted
  descriptions, and `analysis/validate_data.R`, which recomputes the
  figures of the draft manuscript from the data. Household coordinates,
  identifiers carrying enumerator names and the free text answers are not
  included pending the authors' decision. Draft, not released.
