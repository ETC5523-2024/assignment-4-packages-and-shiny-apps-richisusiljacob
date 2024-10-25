#' vehicles_clean Dataset
#'
#' A cleaned dataset of vehicle data containing information on vehicle prices, production year, and various technical attributes. This dataset includes vehicles from 2023 to 2025 and is used to analyze vehicle pricing trends.
#'
#' @format A data frame with `n` rows and `m` variables:
#' \describe{
#'   \item{year}{Numeric. The production year of the vehicle (2023-2025).}
#'   \item{price}{Numeric. The price of the vehicle in USD.}
#'   \item{make}{Character. The manufacturer of the vehicle (e.g., Toyota, Ford).}
#'   \item{model}{Character. The model name of the vehicle.}
#'   \item{fuel}{Character. The type of fuel used (e.g., Gasoline, Diesel).}
#'   \item{mileage}{Numeric. The mileage of the vehicle in miles per gallon.}
#'   \item{transmission}{Character. The type of transmission (e.g., Automatic, Manual).}
#'   \item{body}{Character. The type of vehicle body (e.g., SUV, Sedan, Pickup Truck).}
#' }
#'
#' @source The dataset was sourced from Kaggle and contains vehicle data from 2023 to 2025.
#' @examples
#' data(vehicles_clean)
#' head(vehicles_clean)
"vehicles_clean"


#' Prepare AutoPrice Dataset
#'
#' This function prepares the `AutoPrice` dataset by reading in raw vehicle data from a CSV file, removing missing values, and filtering out price outliers. The cleaned dataset is stored in the `vehicles_clean` object.
#'
#' @param file_path The file path to the raw dataset CSV file.
#' @param overwrite Logical. Whether to overwrite the existing `vehicles_clean` dataset.
#'
#' @return A cleaned dataset of vehicle data (`vehicles_clean`) is saved in the package’s data folder.
#'
#' @details The cleaning process involves filtering out rows where the year or price is missing, and removing price outliers using the 1st and 99th quantiles.
#'
#' @examples
#' prepare_autoprice_dataset("data-raw/vehicles_dataset.csv", overwrite = TRUE)
#'
#' @importFrom readr read_csv
#' @importFrom dplyr filter
#' @export
prepare_autoprice_dataset <- function(file_path, overwrite = TRUE) {
  vehicles_dataset <- read_csv(file_path)

  vehicles_clean <- vehicles_dataset %>%
    filter(!is.na(year) & !is.na(price)) %>%
    filter(price > quantile(price, 0.01), price < quantile(price, 0.99))

  usethis::use_data(vehicles_clean, overwrite = overwrite)
}

