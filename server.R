# 
# Yeji Kim-Barros
# server.R for Shiny App in R
# 
# Stattleship xCase
# March 2018
# 

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  # Explain Metrics
  output$Explain <- renderText({
    if (input$y == "Earned Run Average") HTML(paste("Number of runs earned while pitching in comparison to the number of innings pitched.", "Lower the better.", sep="<br/>"))
    else if (input$y == "Innings Pitched / Game") HTML(paste("Mean innings pitched for each game started.", "Higher value may be an indicator of ability and stamina.", sep="<br/>"))
    else if (input$y == "Hits / 9 Innings") HTML(paste("How many hits a pitcher has given up every 9 innings.", "Lower the better.", sep="<br/>"))
    else if (input$y == "Home Run / 9 Innings") HTML(paste("How many home runs a pitcher has allowed every 9 innings.", "Lower the better.", sep="<br/>"))
    else if (input$y == "Strikeouts / 9 Innings") HTML(paste("Mean of strikeouts per nine innings pitched.", "Higher the better.", sep="<br/>"))
    else if (input$y == "Strikeout Rate") HTML(paste("Frequency of strikeouts.", "Higher the better.", sep="<br/>"))
    else if (input$y == "Walks / 9 Innings") HTML(paste("Measures how frequently a pitcher walks batters.", "Lower the better, as it means the pitcher walks fewer batters for each inning pitched.", sep="<br/>"))
    else HTML(paste("Walks and Hits allowed for each inning pitched.", "Lower the better, as it means the pithcer allowed fewer batters on base for each inning pitched.", sep="<br/>"))
  })
  
  # Plot using plotly
  
  # Dependent Variable Box Plot
  output$boxplot <- renderPlotly({
    if (input$x == "Height") plot_ly(y=xCase_metrics$Height, type ="box", name = input$x)
    else plot_ly(y=xCase_metrics$Weight, type ="box", name = input$x)
  })
  
  # Scatterplot Without Reactive
  # output$scatterplot <- renderPlotly({
  #   xCase <- xCase_metrics %>%
  #     filter(!is.na(WHIP))
  # 
  #   fit <- lm(WHIP ~ Height, data = xCase)
  # 
  #   xCase %>%
  #     plot_ly(x = ~Height) %>%
  #     add_markers(y = ~WHIP) %>%
  #     add_lines(x = ~Height, y = fitted(fit)) %>%
  #     layout(showlegend = FALSE)
  # })
  
  # Reactive Scatterplot
  output$regression <- renderPlotly({
    
    df <- xCase_metrics
    df$xx <- df[[input$x]]
    df$yy <- df[[input$y]]
    
    fit <- lm(yy ~ xx, data = df)
    
    plot<-plot_ly(df, x = ~xx, y = ~yy, mode = "markers", type = "scatter") %>%
      add_lines(x = ~xx, y = fitted(fit)) %>%
      layout( title = "Simple Linear Regression",
              xaxis = list( title=input$x),
              yaxis = list( title=input$y),
              showlegend = FALSE)
    plot
  })
  
  # Residuals & Normality Testing Diagnostics Plots
  output$diagnostics <- renderPlot ({
    df <- xCase_metrics
    df$xx <- df[[input$x]]
    df$yy <- df[[input$y]]
    
    fit <- lm(yy ~ xx, data = df)
    autoplot(fit, colour = 'orange', size = 1.5 )
  })
  
  # Regression Summary
  output$LinearEq <- renderText({
    df <- xCase_metrics
    df$xx <- df[[input$x]]
    df$yy <- df[[input$y]]
    
    fit <- lm(yy ~ xx, data = df)
    m <- round(coefficients(fit)[2], 4)
    b <- round(coefficients(fit)[1], 4)
    if (b < 0) paste("y =", m,"x -",abs(b))
    else paste("y =", m,"x +",b)
  })
  
  output$Summary <- renderText({
    df <- xCase_metrics
    df$xx <- df[[input$x]]
    df$yy <- df[[input$y]]
    
    fit <- lm(yy ~ xx, data = df)
    cor <- cor(df$xx, df$yy)
    cod <- paste("R-Squared = ", round(cor^2, 4))
    cor <- paste("R = ", round(cor, 4))
    pval <- round(summary(fit)$coefficients[1,4], 4)
    pval <- paste("P-Value = ", pval)
    paste(cor, cod, pval, sep = "\n")
  }) 
  
})