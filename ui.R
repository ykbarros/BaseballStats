# 
# Yeji Kim-Barros
# ui.R for Shiny App in R
# 
# Stattleship xCase
# March 2018
# 

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Do Pitchers' Height and Weight Impact Performance?"),
  
  # Sidebar with reactive parameters
  sidebarLayout(
    sidebarPanel(
      # Show x & y dropdown
      h4("Independent Variable:"),
      selectInput("x",
                  label = NULL,
                  choices = c("Height", "Weight")), 
      # independent variable boxplot
      plotlyOutput("boxplot"),
      HTML("<hr>"),
      h4("Dependent Variable:"),
      selectInput("y",
                  label = NULL,
                  choices = c("Earned Run Average", "Innings Pitched / Game", "Hits / 9 Innings",
                              "Home Run / 9 Innings", "Strikeouts / 9 Innings", "Strikeout Rate",
                              "Walks / 9 Innings", "WHIP")),
      htmlOutput("Explain"),
      HTML("<hr>"),
      h4("Summary of Regression:"),
      verbatimTextOutput("LinearEq"),
      verbatimTextOutput("Summary")
    ),
    
    # Main Outputs
    mainPanel(
      # plotlyOutput("scatterplot"),
      plotlyOutput("regression"),
      HTML("<br><hr><br>"),
      plotOutput("diagnostics")
    )
  )
)
)
