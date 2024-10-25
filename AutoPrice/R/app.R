#' Shiny App for Vehicle Price Analysis
#'
#' This Shiny application allows users to interactively explore vehicle price distributions
#' based on year, price range, make, transmission type, and body type. The app visualizes
#' the price distribution with a histogram and provides an option to download the filtered data.
#'
#' @section Main Features:
#' - Users can filter vehicle data based on the production year (2023–2025), price range, make, transmission, and body type.
#' - A dynamic histogram visualizes the price distribution of vehicles based on the selected filters.
#' - The filtered dataset can be downloaded as a CSV file.
#'
#' @import shiny
#' @import ggplot2
#' @import dplyr
#'
#' @examples
#' # Run the Shiny app
#' shinyApp(ui = ui, server = server)
#'
#' @name VehiclePriceAnalysisApp
NULL

#' User Interface (UI) for the Shiny App
#'
#' The UI defines the layout and appearance of the Shiny app. It includes selectors for year, price range,
#' vehicle make, transmission type, and body type. A download button allows users to download the filtered dataset.
#'
#' @section Features:
#' - **Select Year**: Choose the vehicle production year (2023, 2024, 2025).
#' - **Price Range Slider**: Adjust the price range to filter vehicles based on their price.
#' - **Select Make**: Choose one or more vehicle manufacturers.
#' - **Select Transmission Type**: Filter vehicles based on transmission type (e.g., Automatic, Manual).
#' - **Select Body Type**: Filter vehicles based on the body type (e.g., SUV, Sedan).
#' - **Download Button**: Download the filtered data as a CSV file.
#'
#' @return The UI layout for the Shiny app.
#'
#' @export
ui <- fluidPage(
  # Add some custom styling
  tags$head(
    tags$style(HTML("
      body {background-color: #f4f4f9;}
      h1 {color: #006DAE;}
      .well {background-color: #e0f7fa;}
    "))
  ),

  # Application title
  titlePanel("Vehicle Price Analysis (2023-2025)"),

  # Sidebar layout with input and output definitions
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "yearInput",
        label = "Select Year:",
        choices = c("2023", "2024", "2025"),
        selected = "2023"
      ),
      sliderInput(
        inputId = "priceRange",
        label = "Select Price Range:",
        min = min(vehicles_clean$price),
        max = max(vehicles_clean$price),
        value = c(min(vehicles_clean$price), max(vehicles_clean$price))
      ),
      selectInput(
        inputId = "makeInput",
        label = "Select Make:",
        choices = unique(vehicles_clean$make),
        selected = unique(vehicles_clean$make)[1],
        multiple = TRUE
      ),
      checkboxGroupInput(
        inputId = "transmissionInput",
        label = "Select Transmission Type:",
        choices = unique(vehicles_clean$transmission),
        selected = unique(vehicles_clean$transmission)
      ),
      selectInput(
        inputId = "bodyInput",
        label = "Select Body Type:",
        choices = unique(vehicles_clean$body),
        selected = unique(vehicles_clean$body)[1],
        multiple = TRUE
      ),
      downloadButton(outputId = "downloadData", label = "Download Filtered Data")
    ),

    # Main panel for displaying outputs
    mainPanel(
      h3("Vehicle Price Distribution"),
      plotOutput(outputId = "pricePlot"),
      br(),
      h3("Instructions:"),
      p("Use the selector on the left to choose a year and the price range slider to filter the data. The plot below will update based on your selections."),
      h4("Field Descriptions:"),
      p("Year: The production year of the vehicle (2023-2025)."),
      p("Price: The price of the vehicle in USD."),
      p("Make: Manufacturer (e.g., Toyota, Ford)."),
      p("Model: Vehicle model."),
      p("Fuel: Type of fuel (e.g., Gasoline, Diesel)."),
      p("Mileage: Vehicle mileage."),
      p("Transmission: Transmission type (e.g., Automatic, Manual)."),
      p("Body: Vehicle body type (e.g., SUV, Sedan)."),
      h4("How to interpret the output:"),
      p("The plot shows the distribution of vehicle prices for the selected year. You can adjust the price range to explore how many vehicles fall into specific price brackets. This helps in understanding pricing trends for different categories of vehicles.")
    )
  )
)
#' Server Logic for the Shiny App
#'
#' The server logic manages the interactive behavior of the Shiny app. It filters the dataset
#' based on user input and renders a histogram that shows the distribution of vehicle prices.
#' Additionally, users can download the filtered data as a CSV file.
#'
#' @param input User input from the UI (e.g., year, price range, make, transmission, and body type).
#' @param output The output displayed in the app (e.g., plot and download handler).
#'
#' @return The reactive plot and download handler for the filtered data.
#'
#' @export
server <- function(input, output) {

  # Reactive data filtering based on inputs
  filteredData <- reactive({
    vehicles_clean %>%
      filter(year == input$yearInput &
               price >= input$priceRange[1] & price <= input$priceRange[2] &
               make %in% input$makeInput &
               transmission %in% input$transmissionInput &
               body %in% input$bodyInput)
  })

  # Create the plot based on the filtered data
  output$pricePlot <- renderPlot({
    ggplot(filteredData(), aes(x = price)) +
      geom_histogram(binwidth = 5000, fill = "#006DAE", color = "white") +
      labs(title = paste("Price Distribution for Vehicles in", input$yearInput),
           x = "Price (USD)",
           y = "Count of Vehicles") +
      theme_minimal()
  })

  # Provide a download handler for the filtered dataset
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("filtered-vehicles-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(filteredData(), file, row.names = FALSE)
    }
  )
}
#' Run the Shiny Application
#'
#' This function runs the Shiny application for exploring vehicle prices from 2023 to 2025. It provides
#' interactive features to filter the data by year, price range, make, transmission, and body type. Users can
#' view the distribution of vehicle prices and download the filtered dataset as a CSV file.
#'
#' @examples
#' shinyApp(ui = ui, server = server)
#'
#' @export
shinyApp(ui = ui, server = server)
