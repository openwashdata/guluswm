# Description ------------------------------------------------------------------
# R script to process the field data of the Gulu City household solid waste
# study (Feni, Batte, Omal and Niwagaba, draft manuscript of 27 October 2026,
# "Household waste generation, composition and willingness to pay for
# collection in Gulu City, Uganda") into two tidy data frames:
#   guluswm_survey   one row per interviewed household (424 rows), the
#                    socio-economic household survey of 23 to 26 September
#                    2026, collected with mWater by five enumerators
#   guluswm_waste    one row per household in the seven day waste
#                    characterisation study (95 rows), weighed and sorted on
#                    1 to 3 October 2026
# The raw file is the authors' re-export of 30 October 2026,
# Gulu_SWM_OpenWashData.xlsx (sha256 f0a5f05b5f89e35506bfb484939f1e8f86643437150919325e5bcb3995c563ee),
# sent on 2 November 2026 with the answers to the author questions. Two
# sheets: Gulu_Household_survey (424 x 46) and Gulu_Waste_Characterisation
# (95 x 55). Against the first workbook of 27 October it drops the household
# coordinates, Original ID, Response Code and one free text column, and it
# moves sand and soil that had been entered under miscellaneous waste in Limo
# and Vanguard to inorganic non combustible (answer to Q44). The workbook
# still holds the enumerators' user names and two free text columns and is
# git-ignored until the authors send the final coded copy.
#
# data-raw/guluswm_additional_data.csv (from extract_additional_data.R) adds
# per household the survey weight and the wealth index score and class,
# computed by the authors (answers to Q33 to Q36).
#
# Decisions of the authors (answers of 2 November 2026 to Q11 to Q13):
#   - no household coordinates (the consent did not cover locations)
#   - the enumerators stay codes E1 to E5 (alphabetical order of the mWater
#     user names, the same code in both tables)
#   - no free text answers (SWM Challenges other, Suggested Improvements,
#     Complaint about SWM); their coded versions are kept
# Load packages ----------------------------------------------------------------
## Run the following code in console if you don't have the packages
## install.packages(c("usethis", "fs", "here", "readr", "readxl", "openxlsx",
##                    "dplyr", "stringr"))
library(usethis)
library(fs)
library(here)
library(readr)
library(readxl)
library(openxlsx)
library(dplyr)
library(stringr)

# Read data --------------------------------------------------------------------
raw <- here::here("data-raw", "Gulu_SWM_OpenWashData.xlsx")
survey_in <- readxl::read_excel(raw, sheet = "Gulu_Household_survey",
                                col_types = "text", na = c("", "NA"))
waste_in <- readxl::read_excel(raw, sheet = "Gulu_Waste_Characterisation",
                               na = c("", "NA"))
stopifnot(dim(survey_in) == c(424, 46), dim(waste_in) == c(95, 55))
additional <- readr::read_csv(here::here("data-raw", "guluswm_additional_data.csv"),
                              col_types = "cdiiiiidc")
stopifnot(nrow(additional) == 424, !anyDuplicated(additional$household_id))

# Tidy data --------------------------------------------------------------------
## Enumerators: one code per mWater user name across both sheets, in
## alphabetical order of the user names. The names themselves are not
## stored in the package.
enumerators <- sort(unique(c(survey_in$Enumerator, waste_in$Enumerator)))
enumerator_code <- setNames(paste0("E", seq_along(enumerators)), enumerators)
stopifnot(length(enumerators) == 5)

## Factor levels of the ordered categories, as worded in the questionnaire.
lv_education <- c("None", "Primary", "Secondary", "Tertiary/vocational",
                  "University and above")
lv_income <- c("None/no regular income", "Below UGX 100,000",
               "UGX 100,000–300,000", "UGX 300,000–600,000",
               "UGX 600,000–1,000,000", "Above UGX 1,000,000")
lv_expenditure <- lv_income[-1]
lv_class <- c("Low", "Middle", "High")
lv_distance <- c("Less than 50 Metres", "50 - 100 Metres", "200 - 300 Metres",
                 "More than 500 Metres")
lv_fee <- c("Below UGX 1,000", "UGX 1,000–4,999", "UGX 5,000–9,999",
            "UGX 10,000–14,999", "UGX 15,000 and above")
lv_rating <- c("Affordable", "Manageable", "Expensive")

## A factor conversion must not turn a recorded answer into NA.
as_levels <- function(x, levels) {
  f <- factor(x, levels = levels)
  stopifnot(sum(is.na(f)) == sum(is.na(x)))
  f
}

## Household survey. The area name "Pabwo Quarters" of this sheet is the
## "Pabbo Quarters" of the characterisation sheet and of the manuscript.
guluswm_survey <- survey_in |>
  transmute(
    household_id = `Household ID`,
    enumerator = unname(enumerator_code[Enumerator]),
    survey_date = as.Date(`Survey Date`),
    area = if_else(Area == "Pabwo Quarters", "Pabbo Quarters", Area),
    division = Division,
    household_size = as.integer(`Household Size`),
    respondent_is_head = `Respondent is HH Head`,
    education_head = as_levels(`Education of HH Head`, lv_education),
    livelihood = `Primary Livelihood`,
    income_band = as_levels(`Monthly Income Band`, lv_income),
    income_class = as_levels(`Income Class`, lv_class),
    expenditure_band = as_levels(`Monthly Expenditure Band`, lv_expenditure),
    wall_material = `Wall Material`,
    roof_material = `Roof Material`,
    piped_water = `Piped Water`,
    electricity = Electricity,
    waste_types = `Waste Types`,
    disposal_container = `Disposal Container`,
    disposal_method = `Disposal Method`,
    waste_collector = `Who Collects Waste`,
    preferred_frequency = `Preferred Collection Frequency`,
    preferred_time = `Best Collection Time`,
    service_reliable = `Service Reliable`,
    irregular_collection_problem = `Problem from Irregular Collection`,
    enough_collection_points = `Enough Skips/Collection Points`,
    distance_disposal_point = as_levels(`Distance to Disposal Point`, lv_distance),
    pays_for_collection = `Pays for Collection`,
    current_fee_band = as_levels(`Current Fee Band (per month)`, lv_fee),
    current_fee_rating = as_levels(`Current Fee Rating`, lv_rating),
    payment_channel = `Payment Channel`,
    payment_schedule = `Payment Schedule`,
    willing_to_pay = `Willing to Pay (More)`,
    reason_willing = `Reason Willing`,
    reason_not_willing = `Reason Not Willing`,
    wtp_band = as_levels(`WTP Amount Band (per month)`, lv_fee),
    preferred_payment_structure = `Preferred Payment Structure`,
    participates_cleanups = `Participates in Clean-ups`,
    ever_complained = `Ever Complained`,
    complained_to = `Complained To`,
    receives_swm_information = `Receives SWM Information`,
    aware_of_bylaws = `Aware of SWM Bylaws`,
    swm_challenges = `SWM Challenges (coded)`,
    improvement_themes = `Improvement Themes (coded)`
  ) |>
  left_join(select(additional, household_id, survey_weight,
                   wealth_index_score, wealth_index_class),
            by = "household_id") |>
  mutate(wealth_index_class = as_levels(wealth_index_class, lv_class)) |>
  arrange(survey_date, household_id)
stopifnot(nrow(guluswm_survey) == 424, ncol(guluswm_survey) == 46,
          !anyNA(guluswm_survey$survey_weight),
          !anyDuplicated(guluswm_survey$household_id),
          !anyNA(guluswm_survey$survey_date),
          setequal(guluswm_survey$area, c("Limo", "Vanguard", "Highland",
                                          "Kanyagoga", "Pabbo Quarters",
                                          "Goans Quarters")))

## Waste characterisation. The 16 sorting categories are named as in the
## manuscript (Methods 2.5 and Table 2); the workbook headings are mapped
## here. Each category has a net weight and the raw weight before the
## container deduction.
fractions <- c(
  food_kitchen = "Food/kitchen waste",
  garden = "Garden/yard/park waste (green waste)",
  wood = "Wood and wood products",
  textiles = "Textiles and wool",
  paper = "Mixed paper and pulp",
  plastics = "Mixed plastics",
  rubber_leather = "Rubber & leather",
  glass = "Glass",
  metals = "Metals",
  diapers = "Pampers",
  polyethylene_bags = "Polyethylene bags",
  cardboard = "Card board",
  ewaste = "E-waste",
  aluminium = "Aluminium waste",
  inert_fines = "Inorganic non combustible",
  miscellaneous = "Miscellaneous waste"
)
net_cols <- setNames(paste0(fractions, " (kg)"), paste0(names(fractions), "_kg"))
raw_cols <- setNames(paste0(fractions, " (kg, raw incl. container)"),
                     paste0(names(fractions), "_raw_kg"))
stopifnot(all(c(net_cols, raw_cols) %in% names(waste_in)))

guluswm_waste <- waste_in |>
  transmute(
    record_id = `Record ID`,
    enumerator = unname(enumerator_code[Enumerator]),
    measurement_date = as.Date(`Measurement Date`),
    area = `Area (corrected)`,
    area_recorded = `Area (as recorded)`,
    division = Division,
    household_form_id = `Household ID (form)`,
    occupants = as.integer(Occupants),
    people_home_daytime = as.integer(`People at Home During Day`),
    days_stored = as.integer(`Days Stored`),
    person_days = as.integer(`Person-Days`),
    weight_recorded_kg = `Total Weight Recorded (kg)`,
    weight_fractions_sum_kg = `Sum of Sorted Fractions (kg)`,
    weight_used_kg = `Total Weight Used (kg)`,
    mass_balance_diff_pct = `Mass Balance Diff (%)`,
    generation_kg_cap_day = `Per Capita Generation (kg/cap/day)`,
    generation_excl_inert_kg_cap_day = `Per Capita excl. Inert Fines (kg/cap/day)`,
    included_in_averages = `Included in Averages`,
    bucket_empty_kg = `Bucket Empty (kg)`,
    bucket_filled_kg = `Bucket Filled (kg)`,
    bulk_density_kg_m3 = `Bulk Density (kg/m3, 10 L bucket)`,
    container_deduction_kg = `Container Deduction Applied (kg, total)`,
    container_weight_per_fraction_kg = `Implied Container Weight per Fraction (kg)`,
    across(all_of(net_cols)),
    across(all_of(raw_cols))
  ) |>
  arrange(measurement_date, record_id)
stopifnot(nrow(guluswm_waste) == 95, ncol(guluswm_waste) == 55,
          !anyDuplicated(guluswm_waste$record_id),
          !anyNA(guluswm_waste$measurement_date),
          setequal(guluswm_waste$area, guluswm_survey$area))

# Export Data ------------------------------------------------------------------
usethis::use_data(guluswm_survey, overwrite = TRUE)
usethis::use_data(guluswm_waste, overwrite = TRUE)
fs::dir_create(here::here("inst", "extdata"))
for (name in c("guluswm_survey", "guluswm_waste")) {
  obj <- get(name)
  readr::write_csv(obj, here::here("inst", "extdata", paste0(name, ".csv")))
  openxlsx::write.xlsx(obj, here::here("inst", "extdata", paste0(name, ".xlsx")))
}
