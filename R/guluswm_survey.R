#' Household survey on solid waste management in Gulu City, Uganda, 2026
#'
#' One row per household interviewed in the socio-economic household survey of
#' the Gulu City household solid waste study, 23 to 26 September 2026:
#' household characteristics, housing and utilities, income and expenditure
#' bands, the types of waste generated, storage and disposal, the collection
#' service, payment for collection, willingness to pay for an improved service
#' and awareness of by-laws. The 424 households live in six areas of the two
#' divisions of Gulu City. The table also holds the survey weight by division
#' and the wealth index computed by the study team. At the authors' decision,
#' the household coordinates (the consent did not cover locations) and the
#' free text answers of the questionnaire are not published, and the
#' enumerators are coded.
#' 
#' @format A tibble with 424 rows and 46 variables
#' \describe{
#'   \item{household_id}{Identifier of the interviewed household as assigned by the study team: the enumerator's initials, the survey date as day and month (2309 for 23 September 2026) and a running number per enumerator, for example AC-2309-001.}
#'   \item{enumerator}{Code of the enumerator who conducted the interview, E1 to E5; the codes replace the mWater user names and are shared with guluswm_waste.}
#'   \item{survey_date}{Date of the interview, between 23 and 26 September 2026.}
#'   \item{area}{Study area in which the household lives: Limo, Vanguard or Highland (Laroo-Pece Division), Kanyagoga, Pabbo Quarters or Goans Quarters (Bardege-Layibi Division). Only two interviews were completed in Highland. The raw file spells Pabbo Quarters as Pabwo Quarters in this sheet.}
#'   \item{division}{Administrative division of Gulu City in which the household lives: Bardege-Layibi or Laroo-Pece.}
#'   \item{household_size}{Number of people living in the household.}
#'   \item{respondent_is_head}{Whether the respondent is the head of the household (Yes or No).}
#'   \item{education_head}{Highest level of education of the household head, in rising order: None (no formal education), Primary, Secondary, Tertiary/vocational, University and above.}
#'   \item{livelihood}{Main source of livelihood of the household: Trading/business, Casual labour, Salaried employment, Remittances/Donations or Other.}
#'   \item{income_band}{Monthly household income in Ugandan shillings, in six bands from None/no regular income to Above UGX 1,000,000.}
#'   \item{income_class}{Income class derived from income_band: Low (no regular income or below UGX 300,000), Middle (UGX 300,000 to 600,000) or High (above UGX 600,000). The proportions of these classes set the cut points of wealth_index_class.}
#'   \item{expenditure_band}{Monthly household expenditure on basic needs in Ugandan shillings, in five bands from Below UGX 100,000 to Above UGX 1,000,000.}
#'   \item{wall_material}{Main material of the walls of the dwelling: Mud/wattle, Unburnt bricks, Burnt bricks, unplastered, Burnt bricks, plastered or Other.}
#'   \item{roof_material}{Main material of the roof of the dwelling: Grass thatch, Iron sheets (old/rusted), Iron sheets (new) or Tiles/permanent.}
#'   \item{piped_water}{Whether the household has access to piped water (Yes or No).}
#'   \item{electricity}{Whether the household has access to electricity (Yes or No).}
#'   \item{waste_types}{Types of waste the household generates, as named by the respondent: Food preparation waste, Food leftovers, Plastic, Paper, Glass or Other; several answers are separated by a semicolon.}
#'   \item{disposal_container}{Container in which the household stores its waste before disposal: Kavera (a polyethylene bag), Sack, Bucket or Bag; several answers are separated by a semicolon.}
#'   \item{disposal_method}{How the household disposes of its waste: Burning, Collected by service provider, Taken to collection point/skip, Backyard dumping, Rubbish pit, Roadside dumping, Open drain, Burying, Garden/compost or Other; several answers are separated by a semicolon.}
#'   \item{waste_collector}{Who collects the household's waste: City/Division Council, Private Operator, Informal Collector, Community Group, Self (household), No one or Other; asked of households with a collection arrangement.}
#'   \item{preferred_frequency}{Collection frequency the household would prefer: Daily, More than once a week, Three times a week, Twice a week, Weekly or Other; the answer Collection points every month was recorded under Other as an open answer.}
#'   \item{preferred_time}{Time of day the household considers best for collection: Morning, Day time, Evening, No specific time or Other.}
#'   \item{service_reliable}{Whether the household considers waste collection in its area reliable (Yes or No). The question was independent of waste_collector: some households whose waste is not collected take it to the municipal skips.}
#'   \item{irregular_collection_problem}{Main problem the household experiences from irregular collection: Dirty neighborhood, Unhealthy environment, Spread of diseases, Bad reputation of the area or Other; asked of households that call their service unreliable.}
#'   \item{enough_collection_points}{Whether the household considers the number of skips or collection points in its area enough (Yes or No).}
#'   \item{distance_disposal_point}{Distance from the household to the nearest disposal point, in bands: Less than 50 Metres, 50 - 100 Metres, 200 - 300 Metres or More than 500 Metres.}
#'   \item{pays_for_collection}{Whether the household pays for waste collection (Yes or No).}
#'   \item{current_fee_band}{Monthly fee the household pays for collection in Ugandan shillings, in five bands from Below UGX 1,000 to UGX 15,000 and above; asked of paying households.}
#'   \item{current_fee_rating}{How the household rates the fee it pays: Affordable, Manageable or Expensive; asked of paying households.}
#'   \item{payment_channel}{How the household pays for collection: Direct to City/Division Council, Through the landlord or Other. The question was shown to every household; for households that do not pay (pays_for_collection is No) the answer is not applicable, and for paying households Other covers channels not listed.}
#'   \item{payment_schedule}{How often the household pays for collection: Daily, Whenever collected, Bi-weekly or Monthly. The question was shown to every household; for households that do not pay (pays_for_collection is No) the answer is not applicable.}
#'   \item{willing_to_pay}{Whether the household is willing to pay for an improved and regular collection service, or to pay more than now if it pays already (Yes or No).}
#'   \item{reason_willing}{Main reason for being willing to pay: Desire for a cleaner environment, Reduced risk of disease, Convenience/saves time, Improves property value or Other.}
#'   \item{reason_not_willing}{Main reason for not being willing to pay: Income is too low/irregular, Government/City should bear the cost, Already pay enough / rent includes it, Current service is unreliable so won't pay more, or Other.}
#'   \item{wtp_band}{Monthly amount the household is willing to pay in Ugandan shillings, in five bands from Below UGX 1,000 to UGX 15,000 and above; asked of willing households.}
#'   \item{preferred_payment_structure}{Payment structure the household prefers: Flat monthly fee, Pay-per-visit/per-collection, Pay-per-bag/per-bin collected, Included in property rent/rates or No preference.}
#'   \item{participates_cleanups}{Whether the household takes part in community clean-up exercises (Yes or No).}
#'   \item{ever_complained}{Whether the household has ever complained about solid waste management (Yes or No).}
#'   \item{complained_to}{To whom the household complained: LCI Chairman (the chairperson of the Local Council I), Land Lord, City/Division Council, Private Operator or Other.}
#'   \item{receives_swm_information}{Whether the household receives information on solid waste management from the City (Yes or No).}
#'   \item{aware_of_bylaws}{Whether the household is aware of any solid waste management by-law (Yes or No).}
#'   \item{swm_challenges}{Challenges of solid waste management in the area, coded by the study team from the respondent's answer; several codes are separated by a semicolon.}
#'   \item{improvement_themes}{Improvements suggested by the respondent, coded by the study team from the free text answer; several codes are separated by a semicolon.}
#'   \item{survey_weight}{Post-stratification weight by division: the division's share of the population of Gulu City divided by its share of the sample. Bardege-Layibi 0.680 (population 93,848, sample 251) and Laroo-Pece 1.465 (population 139,423, sample 173), population figures from UBOS (2024).}
#'   \item{wealth_index_score}{Wealth index score computed by the study team: the first principal component of five standardised household indicators (roof of new iron sheets or tiles, plastered burnt brick walls, electricity, head with tertiary/vocational or university education, salaried employment as main livelihood); higher values mean wealthier. Missing for 18 households with a missing indicator.}
#'   \item{wealth_index_class}{Wealth class from wealth_index_score: households ranked by score and cut into Low, Middle and High in the proportions of income_class (63.4, 25.2 and 11.4 percent). Missing for 18 households.}
#' }
#' @examples
#' head(guluswm_survey)
#' # households paying for collection, by area
#' table(guluswm_survey$area, guluswm_survey$pays_for_collection)
#' @source Field data of Ivan Feni, Abubakar Batte, James Omal and Charles B.
#'   Niwagaba (Makerere University, University of Stuttgart and Gulu City
#'   Council), collected with the mWater platform from 23 to 26 September 2026
#'   for the manuscript "Household waste generation, composition and
#'   willingness to pay for collection in Gulu City, Uganda" (in preparation),
#'   and shared with openwashdata as a workbook in October and November 2026.
#'   The fieldwork was funded by Integers Company Limited.
"guluswm_survey"
