# Validation checks for the guluswm data objects.
#
# Run from the package root: Rscript analysis/validate_data.R
# The script reads data/*.rda directly and needs no installed package and no
# package beyond base R. It prints one line per check. Structural checks stop
# the script when they fail; the comparisons with the draft manuscript of
# 27 October 2026 (Feni, Batte, Omal and Niwagaba) and its supplement are
# reported with their numbers and never fail, because a difference is a
# question for the authors, not an error in the package.

e <- new.env()
for (f in list.files("data", pattern = "[.]rda$", full.names = TRUE)) load(f, envir = e)
sv <- e$guluswm_survey
ws <- e$guluswm_waste

check <- function(label, ok, detail = "") {
  cat(sprintf("%-78s %s%s\n", label, if (isTRUE(ok)) "ok" else "FAIL",
              if (nzchar(detail)) paste0(" (", detail, ")") else ""))
  if (!isTRUE(ok)) stop("check failed: ", label)
}
report <- function(label, detail) cat(sprintf("%-78s %s\n", label, detail))
pct <- function(x, digits = 1) round(100 * x, digits)
yes <- function(x) x == "Yes"

cat("\n## Household survey: structure\n")
check("424 rows, household_id unique", nrow(sv) == 424 && !anyDuplicated(sv$household_id))
check("household_id pattern AA-YYMM-NNN", all(grepl("^[A-Z]{2}-[0-9]{4}-[0-9]{3}$", sv$household_id)))
check("survey_date within 2026-09-23 to 2026-09-26",
      all(sv$survey_date >= as.Date("2026-09-23") & sv$survey_date <= as.Date("2026-09-26")))
check("enumerator codes E1 to E5", setequal(sv$enumerator, paste0("E", 1:5)))
check("household_size within 1 to 20", all(sv$household_size >= 1 & sv$household_size <= 20, na.rm = TRUE),
      sprintf("%d NA", sum(is.na(sv$household_size))))
check("no empty strings or sentinel values in character columns",
      !any(unlist(lapply(sv[sapply(sv, is.character)],
                         function(x) x %in% c("", "NULL", "N/A", "n/a", "-99", "99", "999")))))

cat("\n## Household survey: areas and divisions\n")
division_of <- c(Limo = "Laroo-Pece", Vanguard = "Laroo-Pece", Highland = "Laroo-Pece",
                 Kanyagoga = "Bardege-Layibi", `Pabbo Quarters` = "Bardege-Layibi",
                 `Goans Quarters` = "Bardege-Layibi")
check("division matches the area (manuscript, Methods 2.1)", all(sv$division == division_of[sv$area]))
report("households per area", paste(names(table(sv$area)), table(sv$area), sep = " ", collapse = ", "))
report("households per division (manuscript: 251 Bardege-Layibi, 173 Laroo-Pece)",
       paste(names(table(sv$division)), table(sv$division), sep = " ", collapse = ", "))

cat("\n## Household survey: derived classes and skip logic\n")
class_rule <- c(`None/no regular income` = "Low", `Below UGX 100,000` = "Low",
                `UGX 100,000–300,000` = "Low", `UGX 300,000–600,000` = "Middle",
                `UGX 600,000–1,000,000` = "High", `Above UGX 1,000,000` = "High")
report("income_class equals the band rule (below 300k low, 300k to 600k middle, above high)",
       sprintf("%d of %d rows differ", sum(class_rule[as.character(sv$income_band)] != as.character(sv$income_class), na.rm = TRUE),
               sum(!is.na(sv$income_band))))
report("current_fee_band answered by households that do not pay",
       sprintf("%d", sum(!is.na(sv$current_fee_band) & !yes(sv$pays_for_collection), na.rm = TRUE)))
report("payment_channel answered: total, by payers, by non-payers",
       sprintf("%d, %d, %d", sum(!is.na(sv$payment_channel)),
               sum(!is.na(sv$payment_channel) & yes(sv$pays_for_collection), na.rm = TRUE),
               sum(!is.na(sv$payment_channel) & sv$pays_for_collection == "No", na.rm = TRUE)))
report("payment_schedule answered: total, by payers, by non-payers",
       sprintf("%d, %d, %d", sum(!is.na(sv$payment_schedule)),
               sum(!is.na(sv$payment_schedule) & yes(sv$pays_for_collection), na.rm = TRUE),
               sum(!is.na(sv$payment_schedule) & sv$pays_for_collection == "No", na.rm = TRUE)))
report("wtp_band answered by households not willing to pay",
       sprintf("%d", sum(!is.na(sv$wtp_band) & sv$willing_to_pay == "No", na.rm = TRUE)))
report("reason_willing given by unwilling, reason_not_willing given by willing",
       sprintf("%d, %d", sum(!is.na(sv$reason_willing) & sv$willing_to_pay == "No", na.rm = TRUE),
               sum(!is.na(sv$reason_not_willing) & yes(sv$willing_to_pay), na.rm = TRUE)))
report("service_reliable answered without a waste_collector",
       sprintf("%d", sum(!is.na(sv$service_reliable) & is.na(sv$waste_collector))))
report("irregular_collection_problem answered: total, by service_reliable == No",
       sprintf("%d, %d", sum(!is.na(sv$irregular_collection_problem)),
               sum(!is.na(sv$irregular_collection_problem) & sv$service_reliable == "No", na.rm = TRUE)))
report("complained_to answered by households that never complained",
       sprintf("%d", sum(!is.na(sv$complained_to) & sv$ever_complained == "No", na.rm = TRUE)))
n_methods <- lengths(strsplit(sv$disposal_method, ";"))
report("households reporting two or more disposal methods (manuscript 3.6: 63, revised 68 counting every answer incl. Other and Garden/compost)",
       sprintf("%d (three methods: %d)", sum(n_methods >= 2, na.rm = TRUE), sum(n_methods >= 3, na.rm = TRUE)))

cat("\n## Household survey: valid responses against supplement Table S2\n")
s2 <- c(household_size = 424, education_head = 408, livelihood = 418, income_band = 421,
        disposal_method = 422, waste_collector = 247, service_reliable = 256,
        enough_collection_points = 415, distance_disposal_point = 404,
        pays_for_collection = 406, current_fee_band = 89, willing_to_pay = 401,
        wtp_band = 130, aware_of_bylaws = 422)
for (v in names(s2)) {
  n_valid <- sum(!is.na(sv[[v]]))
  report(sprintf("valid %s: data %d, Table S2 %d", v, n_valid, s2[[v]]),
         if (n_valid == s2[[v]]) "same" else "DIFFERS")
}
report("education_head: None plus NA (Table S2 counts 16 missing)",
       sprintf("%d None, %d NA", sum(sv$education_head == "None", na.rm = TRUE), sum(is.na(sv$education_head))))

cat("\n## Household survey: unweighted figures of the manuscript\n")
report("mean household size (3.4: 5.26, SD 3.11, median 5)",
       sprintf("%.2f, SD %.2f, median %g", mean(sv$household_size, na.rm = TRUE),
               sd(sv$household_size, na.rm = TRUE), median(sv$household_size, na.rm = TRUE)))
report("mean household size by division (2.9.4: 5.25 and 5.24)",
       paste(names(tapply(sv$household_size, sv$division, mean, na.rm = TRUE)),
             round(tapply(sv$household_size, sv$division, mean, na.rm = TRUE), 2), collapse = ", "))
report("respondent is household head (3.4: 76.9%)", sprintf("%.1f%%", pct(mean(yes(sv$respondent_is_head), na.rm = TRUE))))
ed <- sv$education_head[!is.na(sv$education_head) & sv$education_head != "None"]
report("education of head excluding None, n (3.4: n = 408; secondary 45.6, primary 37.3, tertiary+ 17.2)",
       sprintf("n = %d; secondary %.1f, primary %.1f, tertiary+ %.1f", length(ed),
               pct(mean(ed == "Secondary")), pct(mean(ed == "Primary")),
               pct(mean(ed %in% c("Tertiary/vocational", "University and above")))))
report("livelihood (3.4: trading 51.4, casual 22.0, salaried 17.2)",
       sprintf("trading %.1f, casual %.1f, salaried %.1f",
               pct(mean(sv$livelihood == "Trading/business", na.rm = TRUE)),
               pct(mean(sv$livelihood == "Casual labour", na.rm = TRUE)),
               pct(mean(sv$livelihood == "Salaried employment", na.rm = TRUE))))
report("no regular income (3.4: 19.0%)", sprintf("%.1f%%", pct(mean(sv$income_band == "None/no regular income", na.rm = TRUE))))
report("income class shares of 421 (3.4: 63.4 low, 25.2 middle, 11.4 high)",
       paste(names(table(sv$income_class)), pct(prop.table(table(sv$income_class))), collapse = ", "))
report("pays for collection, unweighted (3.5: 21.9%, n = 406)",
       sprintf("%.1f%%, n = %d", pct(mean(yes(sv$pays_for_collection), na.rm = TRUE)), sum(!is.na(sv$pays_for_collection))))
report("pays by division (3.5: 33.5 Bardege-Layibi, 4.3 Laroo-Pece)",
       paste(names(tapply(yes(sv$pays_for_collection), sv$division, mean, na.rm = TRUE)),
             pct(tapply(yes(sv$pays_for_collection), sv$division, mean, na.rm = TRUE)), collapse = ", "))
report("pays by area (3.5: none in Limo to 58.3 in Goans Quarters)",
       paste(names(tapply(yes(sv$pays_for_collection), sv$area, mean, na.rm = TRUE)),
             pct(tapply(yes(sv$pays_for_collection), sv$area, mean, na.rm = TRUE)), collapse = ", "))
report("fee band 1,000 to 4,999 among payers (3.5: 67.4%, n = 89); fee expensive (55.1%)",
       sprintf("%.1f%%, n = %d; %.1f%%", pct(mean(sv$current_fee_band == "UGX 1,000–4,999", na.rm = TRUE)),
               sum(!is.na(sv$current_fee_band)), pct(mean(sv$current_fee_rating == "Expensive", na.rm = TRUE))))
report("willing households and stated amounts (3.7: 222 willing, 130 stated)",
       sprintf("%d, %d", sum(yes(sv$willing_to_pay), na.rm = TRUE), sum(!is.na(sv$wtp_band))))
report("stated amount shares (3.7: 25.4 below 1,000; 64.6 1,000 to 4,999; 10.0 at least 5,000)",
       sprintf("%.1f, %.1f, %.1f", pct(mean(sv$wtp_band == "Below UGX 1,000", na.rm = TRUE)),
               pct(mean(sv$wtp_band == "UGX 1,000–4,999", na.rm = TRUE)),
               pct(mean(as.integer(sv$wtp_band) >= 3, na.rm = TRUE))))
report("reasons willing (3.7: cleaner 62.2, disease 27.0); flat fee preferred (72.4)",
       sprintf("%.1f, %.1f; %.1f", pct(sum(sv$reason_willing == "Desire for a cleaner environment", na.rm = TRUE) / sum(yes(sv$willing_to_pay), na.rm = TRUE)),
               pct(sum(sv$reason_willing == "Reduced risk of disease", na.rm = TRUE) / sum(yes(sv$willing_to_pay), na.rm = TRUE)),
               pct(mean(sv$preferred_payment_structure == "Flat monthly fee", na.rm = TRUE))))
report("reasons not willing (3.7: low income 73.6, government should pay 7.9)",
       sprintf("%.1f, %.1f", pct(mean(sv$reason_not_willing == "Income is too low/irregular", na.rm = TRUE)),
               pct(mean(sv$reason_not_willing == "Government/City should bear the cost", na.rm = TRUE))))

cat("\n## Household survey: division weighted figures (weights 0.680 and 1.465, Methods 2.9.4)\n")
w <- ifelse(sv$division == "Bardege-Layibi", 0.680, 1.465)
check("survey_weight is 0.680 for Bardege-Layibi and 1.465 for Laroo-Pece", isTRUE(all.equal(sv$survey_weight, w)))
check("weights follow population share / sample share (UBOS 2024: 93,848 and 139,423)",
      isTRUE(all.equal(round(c(93848, 139423) / (93848 + 139423) / (c(251, 173) / 424), 3), c(0.680, 1.465))))
wmean <- function(x) { ok <- !is.na(x); sum(w[ok] * x[ok]) / sum(w[ok]) }
report("weight check: Bardege-Layibi share of sample (59.2%) and of population (40.2%)",
       sprintf("sample %.1f%%, weighted %.1f%%", pct(mean(sv$division == "Bardege-Layibi")),
               pct(wmean(sv$division == "Bardege-Layibi"))))
report("pays for collection, weighted (3.5: 16.4%)", sprintf("%.1f%%", pct(wmean(yes(sv$pays_for_collection)))))
report("willing to pay, weighted (3.7: 54.7%)", sprintf("%.1f%%", pct(wmean(yes(sv$willing_to_pay)))))
report("open burning among disposal methods, weighted (3.6: 36.0%)",
       sprintf("%.1f%%", pct(wmean(ifelse(is.na(sv$disposal_method), NA, grepl("Burning", sv$disposal_method))))))
report("collected by service provider, weighted (3.6: 26.2%)",
       sprintf("%.1f%%", pct(wmean(ifelse(is.na(sv$disposal_method), NA, grepl("Collected by service provider", sv$disposal_method))))))
report("too few skips or collection points, weighted (3.5: 70.2%)",
       sprintf("%.1f%%", pct(wmean(sv$enough_collection_points == "No"))))
report("service unreliable among households with a service, weighted (3.5: 48.8%)",
       sprintf("%.1f%%", pct(wmean(sv$service_reliable == "No"))))
report("aware of bylaws, receives information, clean-ups, weighted (3.6: 3.9, 6.1, 87.0)",
       sprintf("%.1f, %.1f, %.1f", pct(wmean(yes(sv$aware_of_bylaws))),
               pct(wmean(yes(sv$receives_swm_information))), pct(wmean(yes(sv$participates_cleanups)))))

cat("\n## Household survey: wealth index (authors' score and class, answers to Q33 and Q34)\n")
ind <- cbind(
  roof = sv$roof_material %in% c("Iron sheets (new)", "Tiles/permanent"),
  walls = sv$wall_material == "Burnt bricks, plastered",
  electricity = yes(sv$electricity),
  tertiary = sv$education_head %in% c("Tertiary/vocational", "University and above"),
  salaried = sv$livelihood == "Salaried employment")
ind[is.na(cbind(sv$roof_material, sv$wall_material, sv$electricity, sv$education_head, sv$livelihood))] <- NA
complete <- stats::complete.cases(ind)
report("households with all five indicators; with a wealth index score",
       sprintf("%d; %d", sum(complete), sum(!is.na(sv$wealth_index_score))))
pc <- stats::prcomp(ind[complete, ] * 1, scale. = TRUE)
r <- stats::cor(pc$x[, 1], sv$wealth_index_score[complete], use = "complete.obs")
report("first principal component of the indicators vs wealth_index_score (correlation, sign free)",
       sprintf("%.4f; variance explained %.1f%% (authors: 45.7%%)", abs(r), 100 * pc$sdev[1]^2 / sum(pc$sdev^2)))
report("wealth_index_class shares Low, Middle, High (authors: 63.4, 25.2, 11.4)",
       paste(pct(prop.table(table(sv$wealth_index_class))), collapse = ", "))
check("wealth_index_class never decreases with wealth_index_score",
      all(tapply(sv$wealth_index_score, sv$wealth_index_class, max) <=
            c(tapply(sv$wealth_index_score, sv$wealth_index_class, min)[-1], Inf)))
tied <- tapply(sv$wealth_index_class, round(sv$wealth_index_score, 4), function(x) length(unique(x)) > 1)
tied <- names(tied)[tied %in% TRUE]
report("scores whose households fall into two classes (cut inside a tie)",
       if (length(tied)) paste(sapply(tied, function(t) paste0(t, ": ", paste(names(table(droplevels(sv$wealth_index_class[round(sv$wealth_index_score, 4) == as.numeric(t)]))), table(droplevels(sv$wealth_index_class[round(sv$wealth_index_score, 4) == as.numeric(t)])), collapse = " "))), collapse = "; ") else "none")

cat("\n## Waste characterisation: structure\n")
check("95 rows, record_id unique", nrow(ws) == 95 && !anyDuplicated(ws$record_id))
check("measurement_date within 2026-10-01 to 2026-10-03",
      all(ws$measurement_date >= as.Date("2026-10-01") & ws$measurement_date <= as.Date("2026-10-03")))
check("division matches the area", all(ws$division == division_of[ws$area]))
check("occupants within 1 to 14, days_stored 7 or 14",
      all(ws$occupants >= 1 & ws$occupants <= 14) && all(ws$days_stored %in% c(7L, 14L)))
check("person_days equals occupants times days_stored", all(ws$person_days == ws$occupants * ws$days_stored))
check("all weights non negative", all(ws[sapply(ws, is.numeric)] >= 0, na.rm = TRUE))
check("included_in_averages: 94 Yes and 1 outlier",
      sum(ws$included_in_averages == "Yes") == 94 && sum(ws$included_in_averages != "Yes") == 1)
report("the excluded household: generation and its value in kg/cap/day",
       sprintf("%s, %.2f", ws$included_in_averages[ws$included_in_averages != "Yes"],
               ws$generation_kg_cap_day[ws$included_in_averages != "Yes"]))
report("households per area, completed (Table S4: Limo 11, Vanguard 19, Highland 13, Kanyagoga 24, Pabbo 12, Goans 16)",
       paste(names(table(ws$area)), table(ws$area), sep = " ", collapse = ", "))
report("area_recorded differs from area", sprintf("%d of 95 rows", sum(ws$area != ws$area_recorded)))
report("household_form_id distinct values", sprintf("%d of 95", length(unique(ws$household_form_id))))
report("days_stored of 14", sprintf("%d household(s)", sum(ws$days_stored == 14)))

cat("\n## Waste characterisation: internal consistency\n")
net <- grep("_kg$", names(ws), value = TRUE)
net <- setdiff(net[!grepl("_raw_kg$", net)],
               c("weight_recorded_kg", "weight_fractions_sum_kg", "weight_used_kg", "bucket_empty_kg",
                 "bucket_filled_kg", "container_deduction_kg", "container_weight_per_fraction_kg"))
rawc <- grep("_raw_kg$", names(ws), value = TRUE)
check("16 net and 16 raw fraction columns", length(net) == 16 && length(rawc) == 16)
sum_net <- rowSums(ws[net]); sum_raw <- rowSums(ws[rawc])
report("sum of net fractions equals weight_fractions_sum_kg (within 0.02 kg)",
       sprintf("%d of 95 rows", sum(abs(sum_net - ws$weight_fractions_sum_kg) <= 0.02)))
report("sum of raw fractions minus container_deduction_kg equals the net sum (within 0.02 kg)",
       sprintf("%d of 95 rows", sum(abs(sum_raw - ws$container_deduction_kg - sum_net) <= 0.02)))
report("weight_used_kg equals weight_recorded_kg; equals weight_fractions_sum_kg (within 0.02 kg)",
       sprintf("%d, %d of 95 rows", sum(abs(ws$weight_used_kg - ws$weight_recorded_kg) <= 0.02),
               sum(abs(ws$weight_used_kg - ws$weight_fractions_sum_kg) <= 0.02)))
report("rows where weight_recorded_kg exceeds 100 kg", sprintf("%d (max %.0f kg)", sum(ws$weight_recorded_kg > 100), max(ws$weight_recorded_kg)))
report("mass_balance_diff_pct equals 100 x |recorded - fractions| / recorded (within 0.6 points)",
       sprintf("%d of 95 rows; max %.1f", sum(abs(ws$mass_balance_diff_pct - 100 * abs(ws$weight_recorded_kg - ws$weight_fractions_sum_kg) / ws$weight_recorded_kg) <= 0.6),
               max(ws$mass_balance_diff_pct)))
g <- ws$weight_used_kg / (ws$occupants * ws$days_stored)
report("generation_kg_cap_day equals weight_used / (occupants x days) (within 0.005)",
       sprintf("%d of 95 rows", sum(abs(g - ws$generation_kg_cap_day) <= 0.005)))
g2 <- (ws$weight_used_kg - ws$inert_fines_kg) / (ws$occupants * ws$days_stored)
report("generation_excl_inert equals (weight_used - inert_fines) / person_days (within 0.005)",
       sprintf("%d of 95 rows", sum(abs(g2 - ws$generation_excl_inert_kg_cap_day) <= 0.005)))
bd <- (ws$bucket_filled_kg - ws$bucket_empty_kg) / 0.010
report("bulk_density equals (filled - empty) / 10 L (within 0.6 kg/m3)",
       sprintf("%d of 95 rows", sum(abs(bd - ws$bulk_density_kg_m3) <= 0.6)))
report("container_weight_per_fraction x fractions with raw weight > 0 equals container_deduction (within 0.02 kg)",
       sprintf("%d of 95 rows", sum(abs(ws$container_weight_per_fraction_kg * rowSums(ws[rawc] > 0) - ws$container_deduction_kg) <= 0.02)))

rawsum <- rowSums(ws[rawc]); netsum <- rowSums(ws[net])
bad <- ws$record_id[which(abs(rawsum - ws$container_deduction_kg - netsum) > 0.5)]
report("records with a missing raw fraction weight", paste(ws$record_id[!stats::complete.cases(ws[rawc])], collapse = ", "))
report("records where raw minus deduction misses the net sum by more than 0.5 kg", if (length(bad)) paste(bad, collapse = ", ") else "none")

cat("\n## Waste characterisation: figures of the manuscript (94 analysed households)\n")
a <- ws[ws$included_in_averages == "Yes", ]
report("per capita generation (3.1: mean 0.36, SD 0.28, median 0.29; excl. inert 0.26, SD 0.20)",
       sprintf("mean %.2f, SD %.2f, median %.2f; excl. inert %.2f, SD %.2f", mean(a$generation_kg_cap_day),
               sd(a$generation_kg_cap_day), median(a$generation_kg_cap_day),
               mean(a$generation_excl_inert_kg_cap_day), sd(a$generation_excl_inert_kg_cap_day)))
by_area <- sapply(split(a$generation_kg_cap_day, a$area), function(x) sprintf("%.2f (SD %.2f, n %d)", mean(x), sd(x), length(x)))
report("per capita generation by area (Table 1: Kanyagoga 0.52, Pabbo 0.44, Vanguard 0.34, Highland 0.28, Limo 0.27, Goans 0.22)",
       paste(names(by_area), by_area, collapse = "; "))
by_area2 <- sapply(split(a$generation_excl_inert_kg_cap_day, a$area), function(x) sprintf("%.2f", mean(x)))
report("per capita generation excl. inert by area (Table 1: Limo 0.18, Vanguard 0.25)",
       paste(names(by_area2), by_area2, collapse = "; "))
report("per capita generation by division (3.1: Bardege-Layibi 0.41, Laroo-Pece 0.30)",
       paste(names(tapply(a$generation_kg_cap_day, a$division, mean)), round(tapply(a$generation_kg_cap_day, a$division, mean), 2), collapse = ", "))
report("pooled ratio sum(weight) / sum(person days)", sprintf("%.3f kg/cap/day", sum(a$weight_used_kg) / sum(a$person_days)))
report("sorted mass per area in kg (Table 2: Limo 116.0, Vanguard 169.6, Highland 144.8, Kanyagoga 375.5, Pabbo 188.1, Goans 102.1; total 1,096.2)",
       paste(c(names(tapply(rowSums(a[net]), a$area, sum)), "total"),
             round(c(tapply(rowSums(a[net]), a$area, sum), sum(rowSums(a[net]))), 1), collapse = ", "))
comp <- round(100 * colSums(a[net]) / sum(a[net]), 2)
report("pooled composition, Gulu City (Table 2: food 29.36, garden 11.92, inert fines 23.03, miscellaneous 19.60, polyethylene 4.87, diapers 2.67)",
       paste(sub("_kg$", "", names(comp)), comp, collapse = ", "))
report("organic share: food + garden + wood (3.2: 42.0%)", sprintf("%.1f%%", sum(comp[c("food_kitchen_kg", "garden_kg", "wood_kg")])))
report("bulk density, 95 households (3.3: mean 258; Vanguard 193, Limo 295)",
       sprintf("mean %.0f; %s", mean(ws$bulk_density_kg_m3),
               paste(names(tapply(ws$bulk_density_kg_m3, ws$area, mean)), round(tapply(ws$bulk_density_kg_m3, ws$area, mean)), collapse = ", ")))
cat("\nDone.\n")
