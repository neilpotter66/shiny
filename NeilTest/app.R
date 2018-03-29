library(shiny)
library(ggplot2)
library(dplyr)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Booze Prices", windowTitle = "Booze Prices"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", "Price", min=0, max=100, value=c(20,40), pre="$"),
      radioButtons("typeInput", "Product Type",
                   choices = c("BEER","WINE","SPIRITS"),
                   selected="WINE"),
      selectInput("countryInput","Country",
                  choices = c("CANADA","FRANCE","ITALY")
                  )
    ),
    mainPanel(
      plotOutput("coolplot"),
      br(),br(),
      tableOutput("cooltable")
    )
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  output$cooltable <- renderTable({
    filtered <- bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput
             )
    filtered
      
  })
  output$coolplot <- renderPlot({
    filtered <- bcl %>%
      filter(Price >= input$priceInput[1],
            Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput )
    ggplot(filtered, aes(Alcohol_Content)) +
      geom_histogram()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

