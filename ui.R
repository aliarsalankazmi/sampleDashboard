### load libraries

library(shiny)


### body for Shiny UI


shinyUI(navbarPage("Dashboard",
  tabPanel("Details Section"),
  tabPanel("Experiments Section"), inverse = TRUE)
)
