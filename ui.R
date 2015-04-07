### load libraries

library(shiny)
library(shinythemes)
library(shinydashboard)
library(dplyr)
library(tidyr)
library(lubridate)
library(htmlwidgets)
library(rCharts)
library(dygraphs)



### setting boundaries for Google Chart, as noted by Winston Chang

xlim <- list(min = min(gcData$earn) - 500,
  		   max = max(gcData$earn) + 500)

ylim <- list(min = min(gcData$redemptions),
		   max = max(gcData$redemptions) + 3)



### body for Shiny UI


shinyUI(navbarPage("My Sample Dashboard", theme = shinytheme('readable'), inverse = TRUE,
  		tabPanel("Overview Section",
			fluidRow(
				column(6, 
					##current app only supports CSV, since this is a proof of concept...
					fileInput(inputId = 'uploadFile', label = 'Please upload your file')
					)
				  ),
			fluidRow(
				column(3,
					 h4('Main Chart goes here'),
					 showOutput('outlinesChart', 'nvd3')
#					),
#				column(3, offset = 5,
#					 h5('Info boxes go here'),
#					 infoBoxOutput('infoBox1'),
#					 infoBoxOutput('infoBox2'),
#					 infoBoxOutput('infoBox3'),
#					 infoBoxOutput('infoBox4'),
#					 infoBoxOutput('infoBox5'),
#					 infoBoxOutput('infoBox6')
					)
				   ),
			hr(),
			fluidRow(
				column(2, 
					 h5('Earned Points chart goes here'),
					showOutput('cEarnPtsChart', 'nvd3')
					),
				column(2, offset = 4,
					h5('Earn Count chart goes here'),
					showOutput('cEarnCountChart', 'nvd3')
					)
				   ),
			fluidRow(
				column(2, 
					 h5('Redeemed Points chart goes here'),
					 showOutput('cRedemPtsChart', 'nvd3')
					),
				column(2, offset = 4,
					h5('Redemption Count chart goes here'),
					 showOutput('cRedemCountChart', 'nvd3')
					)
				   ),
			fluidRow(
				column(2, 
					 h5('Customer Acquisition chart goes here'),
					 showOutput('cAcquisChart', 'nvd3')
					),
				column(2, offset = 4,
					h5('Customer Churn chart goes here'),
					 showOutput('cChurnChart', 'nvd3')
					)
				   )
			  ),
  		tabPanel("Details Section",
			fluidRow(
				column(3, offset = 4,
					sliderInput('userDate', 'Date', 
						    min = min(gcData$dates), max = max(gcData$dates),
						    value = min(gcData$dates), animate = TRUE, ticks = FALSE, pre = 'YYYYMM:', sep='')
					)
				   ),
			fluidRow(
				column(5, 
					h5('Earn Details Chart goes here'),
					dygraphOutput('earnDetails')
					),
				column(5, offset = 4,
					h5('Redemption Details Chart goes here'),
					dygraphOutput('redempDetails')
					)
				   ),
			fluidRow(
				column(5, 
					h5('Customer Base Details Chart goes here'),
					dygraphOutput('cBaseDetails')
					),
				column(5, offset = 4,
					h5('Churn Details Chart goes here'),
					dygraphOutput('churnDetails')
					)
				   )
			  ),
		tabPanel("Experiments Section")
			  )
)
