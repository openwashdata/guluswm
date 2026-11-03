# guluswm (development version)

# guluswm 1.0.0

Initial release.

- Two data objects from the Gulu City household solid waste study:
  `guluswm_survey`, a household survey of 424 households (23 to 26
  September 2026, 46 variables, with the survey weight by division and the
  wealth index score and class), and `guluswm_waste`, a seven day waste
  characterisation of 95 households (1 to 3 October 2026, 55 variables,
  with the weights of 16 fractions before and after the container
  deduction).
- The raw data are the authors' corrected final copy of 3 November 2026,
  archived in `data-raw/`. At the authors' decision, household
  coordinates, enumerator user names and free text answers are not
  published; enumerators appear as codes E1 to E5, also in `household_id`.
- The data dictionary carries the variable descriptions confirmed by the
  authors.
- `analysis/validate_data.R` recomputes summary figures of the study, and
  `analysis/data_quality.R` reports missing values, duplicates, range and
  cross-field checks and outliers.
- Everyone who contributed to the data is listed as an author: the study
  team, the four enumerators and Charles Wakhata (logistics and field
  support).
- Reviewed against the pkgreview standard 1.7.0 (#9, #11, #13, #15).
