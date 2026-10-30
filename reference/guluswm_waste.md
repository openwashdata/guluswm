# Seven day household waste characterisation in Gulu City, Uganda, 2026

One row per household in the waste characterisation study of the Gulu
City household solid waste study. Each household stored the waste it
generated over seven consecutive days in bags provided by the study
team; the bags were weighed on 1 to 3 October 2026 and the waste was
sorted by hand into 16 fractions adapted from ASTM D5231. The table
holds the total weights, the per capita generation rate, the bulk
density measured with a 10 litre bucket and the weight of every fraction
before and after the deduction of the container weight, for 95
households of which 94 are included in the averages of the study. The
waste records cannot be linked to the households of guluswm_survey.

## Usage

``` r
guluswm_waste
```

## Format

A tibble with 95 rows and 55 variables

- record_id:

  Identifier of the characterisation record: CH, a batch number and a
  running number, for example CH-1001-001.

- enumerator:

  Code of the enumerator who recorded the measurement, one of the codes
  E1 to E5 shared with guluswm_survey.

- measurement_date:

  Date on which the household's waste was weighed and sorted, between 1
  and 3 October 2026, at the end of the storage period.

- area:

  Study area of the household after correction by the study team: Limo,
  Vanguard, Highland, Kanyagoga, Pabbo Quarters or Goans Quarters.

- area_recorded:

  Study area as recorded on the field form, before the correction; it
  differs from area for 14 households.

- division:

  Administrative division of Gulu City in which the household lives:
  Bardege-Layibi or Laroo-Pece.

- household_form_id:

  Household number written on the field form and the bags, for example
  HH-01; it restarts per enumerator and area and is not unique.

- occupants:

  Number of people living in the household.

- people_home_daytime:

  Number of household members at home during the day.

- days_stored:

  Number of days over which the household stored its waste in the bags
  provided: 7 for every household but one, which stored for 14 days.

- person_days:

  Occupants multiplied by days_stored, the denominator of the per capita
  generation rate.

- weight_recorded_kg:

  Total weight of the household's waste as recorded in the field, in
  kilograms, before the correction of keying errors.

- weight_fractions_sum_kg:

  Sum of the weights of the 16 sorted fractions after the container
  deduction, in kilograms.

- weight_used_kg:

  Total weight of the household's waste used in the analysis, in
  kilograms, after the correction of keying errors.

- mass_balance_diff_pct:

  Difference between the recorded total weight and the sum of the sorted
  fractions, as a percentage of the recorded total weight.

- generation_kg_cap_day:

  Per capita waste generation rate in kilograms per person and day:
  weight_used_kg divided by person_days.

- generation_excl_inert_kg_cap_day:

  Per capita waste generation rate without the inert fines (sand, soil
  and stones), in kilograms per person and day.

- included_in_averages:

  Whether the household is included in the averages of the study: Yes
  for 94 households, No (outlier \> 2.0) for the one household with a
  generation rate above 2 kilograms per person and day.

- bucket_empty_kg:

  Weight of the empty 10 litre bucket used to measure the bulk density,
  in kilograms.

- bucket_filled_kg:

  Weight of the 10 litre bucket filled loosely with the household's
  waste, in kilograms.

- bulk_density_kg_m3:

  Bulk density of the loose waste in kilograms per cubic metre: the
  weight of waste in the 10 litre bucket divided by its volume.

- container_deduction_kg:

  Total weight deducted for the containers in which the fractions were
  weighed, in kilograms, summed over the fractions.

- container_weight_per_fraction_kg:

  Container weight deducted from each fraction with a recorded weight,
  in kilograms.

- food_kitchen_kg:

  Weight of food and kitchen waste, in kilograms, after the container
  deduction.

- garden_kg:

  Weight of garden, yard and park waste (green waste), in kilograms,
  after the container deduction.

- wood_kg:

  Weight of wood and wood products, in kilograms, after the container
  deduction.

- textiles_kg:

  Weight of textiles and wool, in kilograms, after the container
  deduction.

- paper_kg:

  Weight of mixed paper and pulp, in kilograms, after the container
  deduction.

- plastics_kg:

  Weight of mixed plastics, in kilograms, after the container deduction.

- rubber_leather_kg:

  Weight of rubber and leather, in kilograms, after the container
  deduction.

- glass_kg:

  Weight of glass, in kilograms, after the container deduction.

- metals_kg:

  Weight of metals, in kilograms, after the container deduction.

- diapers_kg:

  Weight of disposable diapers (recorded as Pampers), in kilograms,
  after the container deduction.

- polyethylene_bags_kg:

  Weight of polyethylene bags, in kilograms, after the container
  deduction.

- cardboard_kg:

  Weight of cardboard, in kilograms, after the container deduction.

- ewaste_kg:

  Weight of electronic waste, in kilograms, after the container
  deduction.

- aluminium_kg:

  Weight of aluminium, in kilograms, after the container deduction.

- inert_fines_kg:

  Weight of inert fines (sand, soil and stones from compound sweeping,
  recorded as inorganic non combustible), in kilograms, after the
  container deduction.

- miscellaneous_kg:

  Weight of miscellaneous waste (residual fine material that could not
  be sorted further), in kilograms, after the container deduction.

- food_kitchen_raw_kg:

  Weight of food and kitchen waste as weighed in the field, in
  kilograms, before the container deduction.

- garden_raw_kg:

  Weight of garden, yard and park waste (green waste) as weighed in the
  field, in kilograms, before the container deduction.

- wood_raw_kg:

  Weight of wood and wood products as weighed in the field, in
  kilograms, before the container deduction.

- textiles_raw_kg:

  Weight of textiles and wool as weighed in the field, in kilograms,
  before the container deduction.

- paper_raw_kg:

  Weight of mixed paper and pulp as weighed in the field, in kilograms,
  before the container deduction.

- plastics_raw_kg:

  Weight of mixed plastics as weighed in the field, in kilograms, before
  the container deduction.

- rubber_leather_raw_kg:

  Weight of rubber and leather as weighed in the field, in kilograms,
  before the container deduction.

- glass_raw_kg:

  Weight of glass as weighed in the field, in kilograms, before the
  container deduction.

- metals_raw_kg:

  Weight of metals as weighed in the field, in kilograms, before the
  container deduction.

- diapers_raw_kg:

  Weight of disposable diapers (recorded as Pampers) as weighed in the
  field, in kilograms, before the container deduction.

- polyethylene_bags_raw_kg:

  Weight of polyethylene bags as weighed in the field, in kilograms,
  before the container deduction.

- cardboard_raw_kg:

  Weight of cardboard as weighed in the field, in kilograms, before the
  container deduction.

- ewaste_raw_kg:

  Weight of electronic waste as weighed in the field, in kilograms,
  before the container deduction.

- aluminium_raw_kg:

  Weight of aluminium as weighed in the field, in kilograms, before the
  container deduction.

- inert_fines_raw_kg:

  Weight of inert fines (sand, soil and stones, recorded as inorganic
  non combustible) as weighed in the field, in kilograms, before the
  container deduction.

- miscellaneous_raw_kg:

  Weight of miscellaneous waste (residual fine material) as weighed in
  the field, in kilograms, before the container deduction.

## Source

Field data of Ivan Feni, Abubakar Batte, James Omal and Charles B.
Niwagaba (Makerere University, University of Stuttgart and Gulu City
Council), measured from 1 to 3 October 2026 for the manuscript
"Household waste generation, composition and willingness to pay for
collection in Gulu City, Uganda" (in preparation), and shared with
openwashdata as a workbook in October 2026.

## Examples

``` r
head(guluswm_waste)
#> # A tibble: 6 × 55
#>   record_id   enumerator measurement_date area  area_recorded division  
#>   <chr>       <chr>      <date>           <chr> <chr>         <chr>     
#> 1 CH-1001-001 E1         2026-10-01       Limo  Limo          Laroo-Pece
#> 2 CH-1001-002 E1         2026-10-01       Limo  Limo          Laroo-Pece
#> 3 CH-1001-003 E1         2026-10-01       Limo  Limo          Laroo-Pece
#> 4 CH-1001-004 E1         2026-10-01       Limo  Limo          Laroo-Pece
#> 5 CH-1001-005 E1         2026-10-01       Limo  Limo          Laroo-Pece
#> 6 CH-1001-006 E1         2026-10-01       Limo  Limo          Laroo-Pece
#> # ℹ 49 more variables: household_form_id <chr>, occupants <int>,
#> #   people_home_daytime <int>, days_stored <int>, person_days <int>,
#> #   weight_recorded_kg <dbl>, weight_fractions_sum_kg <dbl>,
#> #   weight_used_kg <dbl>, mass_balance_diff_pct <dbl>,
#> #   generation_kg_cap_day <dbl>, generation_excl_inert_kg_cap_day <dbl>,
#> #   included_in_averages <chr>, bucket_empty_kg <dbl>, bucket_filled_kg <dbl>,
#> #   bulk_density_kg_m3 <dbl>, container_deduction_kg <dbl>, …
# per capita generation of the 94 analysed households, kg per person and day
summary(guluswm_waste$generation_kg_cap_day[guluswm_waste$included_in_averages == "Yes"])
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>  0.0310  0.1532  0.2886  0.3601  0.4398  1.4357 
```
