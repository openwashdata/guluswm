# Data quality report for the pkgreview data review (issue #11).
# Run from the package root: Rscript analysis/data_quality.R
# Prints missing values, duplicates, cross-field checks, hard ranges,
# classes, factor levels and outliers for both data objects. Findings are
# reported, never corrected here; corrections belong in
# data-raw/data_processing.R.

devtools::load_all(quiet = TRUE)
sv <- guluswm_survey
ws <- guluswm_waste

count_violations <- function(label, x) {
  cat(sprintf("%-75s %d\n", label, sum(x, na.rm = TRUE)))
}

for (nm in c("guluswm_survey", "guluswm_waste")) {
  d <- get(nm)
  cat("\n##", nm, "(", nrow(d), "rows,", ncol(d), "variables )\n")

  cat("\n### Classes\n")
  print(table(vapply(d, function(x) class(x)[1], "")))

  cat("\n### Missing values per variable (count, percent)\n")
  miss <- colSums(is.na(d))
  miss <- miss[miss > 0]
  if (length(miss)) {
    print(data.frame(missing = miss, percent = round(100 * miss / nrow(d), 1)))
  } else {
    cat("none\n")
  }
  cat("empty strings:", sum(vapply(d, function(x) is.character(x) && any(x == "", na.rm = TRUE), TRUE)), "\n")

  cat("\n### Duplicate rows\n")
  id <- names(d)[1]
  cat("full duplicates:", sum(duplicated(d)), "| identical on all non-ID columns:",
      sum(duplicated(d[setdiff(names(d), id)])), "\n")

  cat("\n### Factors: levels in use and unused levels\n")
  f <- d[vapply(d, is.factor, TRUE)]
  for (v in names(f)) {
    unused <- setdiff(levels(f[[v]]), as.character(unique(f[[v]])))
    cat(sprintf("%-28s %d levels, unused: %s\n", v, nlevels(f[[v]]),
                if (length(unused)) paste(unused, collapse = ", ") else "none"))
  }

  cat("\n### Outliers (values beyond 3 IQR from the quartiles)\n")
  num <- d[vapply(d, is.numeric, TRUE)]
  for (v in names(num)) {
    x <- num[[v]]
    q <- stats::quantile(x, c(0.25, 0.75), na.rm = TRUE)
    k <- 3 * diff(q)
    n_out <- sum(x < q[1] - k | x > q[2] + k, na.rm = TRUE)
    if (n_out > 0 && k > 0) cat(sprintf("%-34s %d (max %s)\n", v, n_out, format(max(x, na.rm = TRUE))))
  }
}

cat("\n## Hard ranges\n")
count_violations("survey: household_size below 1", sv$household_size < 1)
count_violations("survey: survey_weight not positive", sv$survey_weight <= 0)
count_violations("waste: negative weight in any _kg column",
                 as.matrix(ws[grep("_kg$", names(ws))]) < 0)
count_violations("waste: mass_balance_diff_pct outside [0, 100]",
                 ws$mass_balance_diff_pct < 0 | ws$mass_balance_diff_pct > 100)
count_violations("survey: survey_date outside the fieldwork 2026-09-23 to 2026-09-26",
                 sv$survey_date < as.Date("2026-09-23") | sv$survey_date > as.Date("2026-09-26"))
count_violations("waste: measurement_date outside 2026-10-01 to 2026-10-03",
                 ws$measurement_date < as.Date("2026-10-01") |
                   ws$measurement_date > as.Date("2026-10-03"))

cat("\n## Cross-field checks (violation counts)\n")
count_violations("waste: people_home_daytime greater than occupants",
                 ws$people_home_daytime > ws$occupants)
count_violations("waste: person_days differs from occupants x days_stored",
                 ws$person_days != ws$occupants * ws$days_stored)
fr <- c("food_kitchen", "garden", "wood", "textiles", "paper", "plastics",
        "rubber_leather", "glass", "metals", "diapers", "polyethylene_bags",
        "cardboard", "ewaste", "aluminium", "inert_fines", "miscellaneous")
net <- as.matrix(ws[paste0(fr, "_kg")])
raw <- as.matrix(ws[paste0(fr, "_raw_kg")])
count_violations("waste: a net fraction weight above its raw weight (by more than 0.001 kg)",
                 net - raw > 0.001)
count_violations("waste: fractions sum differs from weight_fractions_sum_kg by more than 0.01 kg",
                 abs(rowSums(net) - ws$weight_fractions_sum_kg) > 0.01)
count_violations("waste: generation_excl_inert above generation",
                 ws$generation_excl_inert_kg_cap_day > ws$generation_kg_cap_day + 1e-9)
count_violations("survey: current_fee_band given by households that do not pay",
                 !is.na(sv$current_fee_band) & sv$pays_for_collection == "No")
count_violations("survey: wtp_band given by households not willing to pay",
                 !is.na(sv$wtp_band) & sv$willing_to_pay == "No")
count_violations("survey: complained_to given by households that never complained",
                 !is.na(sv$complained_to) & sv$ever_complained == "No")
count_violations("survey: wealth_index_class missing while the score is present",
                 is.na(sv$wealth_index_class) & !is.na(sv$wealth_index_score))

cat("\n## Identifiers\n")
cat("survey household_id unique:", !anyDuplicated(sv$household_id),
    "| waste record_id unique:", !anyDuplicated(ws$record_id),
    "| waste household_form_id repeats by design:", sum(duplicated(ws$household_form_id)), "\n")
