# Household survey on solid waste management in Gulu City, Uganda, 2026

One row per household interviewed in the socio-economic household survey
of the Gulu City household solid waste study, 23 to 26 September 2026:
household characteristics, housing and utilities, income and expenditure
bands, the types of waste generated, storage and disposal, the
collection service, payment for collection, willingness to pay for an
improved service and awareness of by-laws. The 424 households live in
six areas of the two divisions of Gulu City. The household coordinates
and the three free text answers of the questionnaire are not included in
this version of the package.

## Usage

``` r
guluswm_survey
```

## Format

A tibble with 424 rows and 43 variables

- household_id:

  Identifier of the interviewed household as assigned by the study team:
  two letters for the enumerator, the survey month (2309 for
  September 2026) and a running number, for example AC-2309-001.

- enumerator:

  Code of the enumerator who conducted the interview, E1 to E5; the
  codes replace the mWater user names and are shared with guluswm_waste.

- survey_date:

  Date of the interview, between 23 and 26 September 2026.

- area:

  Study area in which the household lives: Limo, Vanguard or Highland
  (Laroo-Pece Division), Kanyagoga, Pabbo Quarters or Goans Quarters
  (Bardege-Layibi Division). The raw file spells Pabbo Quarters as Pabwo
  Quarters in this sheet.

- division:

  Administrative division of Gulu City in which the household lives:
  Bardege-Layibi or Laroo-Pece.

- household_size:

  Number of people living in the household.

- respondent_is_head:

  Whether the respondent is the head of the household (Yes or No).

- education_head:

  Highest level of education of the household head, in rising order:
  None, Primary, Secondary, Tertiary/vocational, University and above.

- livelihood:

  Main source of livelihood of the household: Trading/business, Casual
  labour, Salaried employment, Remittances/Donations or Other.

- income_band:

  Monthly household income in Ugandan shillings, in six bands from
  None/no regular income to Above UGX 1,000,000.

- income_class:

  Income class derived from income_band: Low (no regular income or below
  UGX 300,000), Middle (UGX 300,000 to 600,000) or High (above UGX
  600,000).

- expenditure_band:

  Monthly household expenditure on basic needs in Ugandan shillings, in
  five bands from Below UGX 100,000 to Above UGX 1,000,000.

- wall_material:

  Main material of the walls of the dwelling: Mud/wattle, Unburnt
  bricks, Burnt bricks unplastered, Burnt bricks plastered or Other.

- roof_material:

  Main material of the roof of the dwelling: Grass thatch, Iron sheets
  (old/rusted), Iron sheets (new) or Tiles/permanent.

- piped_water:

  Whether the household has access to piped water (Yes or No).

- electricity:

  Whether the household has access to electricity (Yes or No).

- waste_types:

  Types of waste the household generates, as named by the respondent:
  Food preparation waste, Food leftovers, Plastic, Paper, Glass or
  Other; several answers are separated by a semicolon.

- disposal_container:

  Container in which the household stores its waste before disposal:
  Kavera (a polyethylene bag), Sack, Bucket or Bag; several answers are
  separated by a semicolon.

- disposal_method:

  How the household disposes of its waste: Burning, Collected by service
  provider, Taken to collection point/skip, Backyard dumping, Rubbish
  pit, Roadside dumping, Open drain, Burying, Garden/compost or Other;
  several answers are separated by a semicolon.

- waste_collector:

  Who collects the household's waste: City/Division Council, Private
  Operator, Informal Collector, Community Group, Self (household), No
  one or Other; asked of households with a collection arrangement.

- preferred_frequency:

  Collection frequency the household would prefer: Daily, More than once
  a week, Three times a week, Twice a week, Weekly, Collection points
  every month or Other.

- preferred_time:

  Time of day the household considers best for collection: Morning, Day
  time, Evening, No specific time or Other.

- service_reliable:

  Whether the household considers its collection service reliable (Yes
  or No); asked of households with a service.

- irregular_collection_problem:

  Main problem the household experiences from irregular collection:
  Dirty neighborhood, Unhealthy environment, Spread of diseases, Bad
  reputation of the area or Other; asked of households that call their
  service unreliable.

- enough_collection_points:

  Whether the household considers the number of skips or collection
  points in its area enough (Yes or No).

- distance_disposal_point:

  Distance from the household to the nearest disposal point, in bands:
  Less than 50 Metres, 50 - 100 Metres, 200 - 300 Metres or More than
  500 Metres.

- pays_for_collection:

  Whether the household pays for waste collection (Yes or No).

- current_fee_band:

  Monthly fee the household pays for collection in Ugandan shillings, in
  five bands from Below UGX 1,000 to UGX 15,000 and above; asked of
  paying households.

- current_fee_rating:

  How the household rates the fee it pays: Affordable, Manageable or
  Expensive; asked of paying households.

- payment_channel:

  How the household pays for collection: Direct to City/Division
  Council, Through the landlord or Other.

- payment_schedule:

  How often the household pays for collection: Daily, Whenever
  collected, Bi-weekly or Monthly.

- willing_to_pay:

  Whether the household is willing to pay for an improved and regular
  collection service, or to pay more than now if it pays already (Yes or
  No).

- reason_willing:

  Main reason for being willing to pay: Desire for a cleaner
  environment, Reduced risk of disease, Convenience/saves time, Improves
  property value or Other.

- reason_not_willing:

  Main reason for not being willing to pay: Income is too low/irregular,
  Government/City should bear the cost, Already pay enough / rent
  includes it, Current service is unreliable so won't pay more, or
  Other.

- wtp_band:

  Monthly amount the household is willing to pay in Ugandan shillings,
  in five bands from Below UGX 1,000 to UGX 15,000 and above; asked of
  willing households.

- preferred_payment_structure:

  Payment structure the household prefers: Flat monthly fee,
  Pay-per-visit/per-collection, Pay-per-bag/per-bin collected, Included
  in property rent/rates or No preference.

- participates_cleanups:

  Whether the household takes part in community clean-up exercises (Yes
  or No).

- ever_complained:

  Whether the household has ever complained about solid waste management
  (Yes or No).

- complained_to:

  To whom the household complained: LCI Chairman (the chairperson of the
  Local Council I), Land Lord, City/Division Council, Private Operator
  or Other.

- receives_swm_information:

  Whether the household receives information on solid waste management
  from the City (Yes or No).

- aware_of_bylaws:

  Whether the household is aware of any solid waste management by-law
  (Yes or No).

- swm_challenges:

  Challenges of solid waste management in the area, coded by the study
  team from the respondent's answer; several codes are separated by a
  semicolon.

- improvement_themes:

  Improvements suggested by the respondent, coded by the study team from
  the free text answer; several codes are separated by a semicolon.

## Source

Field data of Ivan Feni, Abubakar Batte, James Omal and Charles B.
Niwagaba (Makerere University, University of Stuttgart and Gulu City
Council), collected with the mWater platform from 23 to 26 September
2026 for the manuscript "Household waste generation, composition and
willingness to pay for collection in Gulu City, Uganda" (in
preparation), and shared with openwashdata as a workbook in October
2026.

## Examples

``` r
head(guluswm_survey)
#> # A tibble: 6 × 43
#>   household_id enumerator survey_date area  division   household_size
#>   <chr>        <chr>      <date>      <chr> <chr>               <int>
#> 1 AC-2309-001  E1         2026-09-23  Limo  Laroo-Pece              2
#> 2 AC-2309-002  E1         2026-09-23  Limo  Laroo-Pece              4
#> 3 AC-2309-003  E1         2026-09-23  Limo  Laroo-Pece              7
#> 4 AC-2309-004  E1         2026-09-23  Limo  Laroo-Pece              3
#> 5 AC-2309-005  E1         2026-09-23  Limo  Laroo-Pece              7
#> 6 AC-2309-006  E1         2026-09-23  Limo  Laroo-Pece              4
#> # ℹ 37 more variables: respondent_is_head <chr>, education_head <fct>,
#> #   livelihood <chr>, income_band <fct>, income_class <fct>,
#> #   expenditure_band <fct>, wall_material <chr>, roof_material <chr>,
#> #   piped_water <chr>, electricity <chr>, waste_types <chr>,
#> #   disposal_container <chr>, disposal_method <chr>, waste_collector <chr>,
#> #   preferred_frequency <chr>, preferred_time <chr>, service_reliable <chr>,
#> #   irregular_collection_problem <chr>, enough_collection_points <chr>, …
# households paying for collection, by area
table(guluswm_survey$area, guluswm_survey$pays_for_collection)
#>                 
#>                   No Yes
#>   Goans Quarters  25  35
#>   Highland         0   0
#>   Kanyagoga      111  21
#>   Limo           100   0
#>   Pabbo Quarters  27  26
#>   Vanguard        54   7
```
