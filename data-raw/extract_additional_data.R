# Extracts the sheet "Additional_Data" of the authors' workbook
# 02112026_Gulu_SWM_Data_and_Figures.xlsx (sent 2 November 2026, kept in the
# git-ignored dev/source/2026-11-02-author-response/) into
# data-raw/guluswm_additional_data.csv: per household the survey weight, the
# five wealth index indicators, the wealth index score and the wealth index
# class (answers to Q33 to Q36 of the author questions). The rest of that
# workbook holds the household coordinates and is not read here.
# Run once from the package root; the CSV is committed.
library(readxl)
f <- here::here("dev", "source", "2026-11-02-author-response",
                "02112026_Gulu_SWM_Data_and_Figures.xlsx")
a <- read_excel(f, sheet = "Additional_Data", skip = 15, col_types = "text")
stopifnot(names(a)[1] == "Household ID", nrow(a) == 424)
out <- data.frame(
  household_id = a[["Household ID"]],
  survey_weight = round(as.numeric(a[["Survey weight"]]), 3),
  improved_roof = as.integer(a[["Improved roof (1/0)"]]),
  plastered_brick_walls = as.integer(a[["Plastered burnt-brick walls (1/0)"]]),
  electricity = as.integer(a[["Electricity (1/0)"]]),
  head_tertiary_education = as.integer(a[["Head with tertiary education (1/0)"]]),
  salaried_employment = as.integer(a[["Salaried employment (1/0)"]]),
  wealth_index_score = round(as.numeric(a[["Wealth index score (PC1)"]]), 4),
  wealth_index_class = a[["Wealth index class"]]
)
stopifnot(!anyDuplicated(out$household_id))
write.csv(out, here::here("data-raw", "guluswm_additional_data.csv"), row.names = FALSE, na = "")
