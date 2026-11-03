# guluswm (development version)

- The raw data are now the authors' final copy of 3 November 2026, archived
  in `data-raw/`: coded enumerators, no coordinates, no free text, and the
  wealth index and survey weights as a third sheet. The before-deduction
  weights of inert fines and miscellaneous waste are rounded in the re-keyed
  records and swapped between CH-1002-021 and CH-1002-022 (asked of the
  authors). The tie rule of `wealth_index_class` is documented.

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
