library(readr)
library(dplyr)

vehicles_dataset <- read_csv("data-raw/vehicles_dataset.csv")

vehicles_clean <- vehicles_dataset %>%
filter(!is.na(year) & !is.na(price)) %>%
filter(price > quantile(price, 0.01), price < quantile(price, 0.99))

usethis::use_data(vehicles_clean, overwrite = TRUE)
