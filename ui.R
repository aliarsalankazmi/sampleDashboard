#
#
## load libraries

library(shiny)


## body for Shiny UI


shinyUI(fluidPage(

title = 'My Dashboard',

imageOutput('mainImg'),

hr(),

fluidRow(
	column(2,
		fileInput(inputId = 'mainFile', label = 'Select your file to upload', multiple = FALSE)
		),
	column(3,
		h4('Cumulative Accrued Points'),
		verbatimTextOutput('imgPath')#,
#		plotOutput(...)
		),
	column(4,
		h4('Cumulative Redeemed Points')#,
#		verbatimTextOutput(...),
#		plotOutput(...)
		),
	column(5,
		h4('Cumulative Extra Metric')#,
#		verbatimTextOutput(...),
#		plotOutput(...)
		)
	)

))
