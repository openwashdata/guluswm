# Writes the drafted descriptions of dev/drafts/dictionary-descriptions.csv
# into the description column of data-raw/dictionary.csv. Touches no other
# column. Run from the package root.
d <- readr::read_csv("data-raw/dictionary.csv", col_types = readr::cols(.default = "c"))
s <- readr::read_csv("dev/drafts/dictionary-descriptions.csv", col_types = readr::cols(.default = "c"))
key_d <- paste(d$file_name, d$variable_name)
key_s <- paste(s$file_name, s$variable_name)
stopifnot(setequal(key_d, key_s), !anyDuplicated(key_s))
d$description <- s$description[match(key_d, key_s)]
stopifnot(!anyNA(d$description), all(nchar(d$description) > 20))
readr::write_csv(d, "data-raw/dictionary.csv", na = "")
cat("descriptions written:", nrow(d), "\n")
