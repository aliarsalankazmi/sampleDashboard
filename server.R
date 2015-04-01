#
#
# load libraries, scripts, data

library(shiny)
library(shinyapps)
library(shinydashboard)
library(dplyr)
library(tidyr)
library(lubridate)
library(htmlwidgets)

options(shiny.trace = TRUE,
	  shiny.maxRequestSize=300*1024^2)



## body of shiny server side program

shinyServer(function(input, output, session) {


dataList <- reactive({
		if(is.null(input$uploadFile)){     
		return(NULL)
		}
		uploadFileInfo <- input$uploadFile
		uploadData <- read.csv(uploadFileInfo$datapath, header = TRUE, stringsAsFactors = FALSE)

		uploadedData <- tbl_df(uploadData) %>% 
				mutate(yearValue = year(dateValues), monthValue = month(dateValues))

		sumData1 <- uploadedData %>% 
			select(yearValue, earnPts, earnCount, redemPts, redemCount, churnCount, acquisCount) %>% 
			gather(metrics, totals, -yearValue) %>%
			group_by(yearValue, metrics) %>%
			summarise(yearlyTotals = sum(totals)) %>%
			arrange(yearlyTotals)

		sumData2 <- uploadedData %>%  
			select(yearValue, monthValue, earnPts, earnCount, redemPts, redemCount, churnCount, acquisCount) %>%
			gather(metrics, totals, -c(yearValue, monthValue)) %>%
			group_by(yearValue, monthValue, metrics) %>%
			summarise(yearmonthTotals = sum(totals)) %>%
			arrange(yearValue, monthValue) %>%
			group_by(yearValue, metrics) %>%
			mutate(cumulatives = cumsum(yearmonthTotals))

		sumData3 <- uploadedData %>% 
			select(yearValue, monthValue, earnPts, earnCount, redemPts, redemCount, churnCount, acquisCount) %>%
			group_by(yearValue, monthValue) %>%
			summarise_each(funs(mean)) %>% 
			round()

		sumData4 <- uploadedData %>% 
			group_by(dateValues) %>%
			summarise_each(funs(sum))

		earnData <- sumData4 %>%
			select(earnPts, earnCount)
		row.names(earnData) <- sumData4$dateValues

		redempData <- sumData4 %>%
			select(redemPts, redemCount)
		row.names(earnData) <- sumData4$dateValues

		custData <- sumData4 %>%
			select(churnCount, acquisCount)
		row.names(earnData) <- sumData4$dateValues

		sumData5 <- uploadedData %>% 
			group_by(dateValues) %>%
			summarise_each(funs(sum))

		earnTSData <- sumData5 %>%
			select(earnPts, earnCount)
		row.names(earnTSData) <- sumData5$dateValues

		redemTSData <- sumData5 %>%
			select(redemPts, redemCount)
		row.names(redemTSData) <- sumData5$dateValues

		custTSData <- sumData5 %>%
			select(acquisCount, churnCount)
		row.names(custTSData) <- sumData5$dateValues


		dfList <- list(sumData1 = sumData1, sumData2 = sumData2, sumData3 = sumData3,
				   sumData4 = sumData4, earnData = earnData, redempData = redempData,
				   custData = custData, sumData5 = sumData5, earnTSData = earnTSData,
				   redemTSData = redemTSData, custTSData = custTSData)

		return(dfList)
})


### The main chart

output$outlinesChart <- renderChart2({
	myData <- dataList()$sumData1
	mainPlot <- nPlot(yearlyTotals ~ metrics, 
			  group = 'yearValue', data = myData, type = 'multiBarChart')
	mainPlot$chart(margin=list(left=100)) 
	rm(myData)
	return(mainPlot)
})


### Information boxes

output$infoBox1 <- renderInfoBox({
    infoBox(
      "Progress", 10*2, icon = icon("line-chart"),
      color = "blue"
    )
})

output$infoBox2 <- renderInfoBox({
    infoBox(
      "Progress", 10*2, icon = icon("line-chart"),
      color = "blue"
    )
})

output$infoBox3 <- renderInfoBox({
    infoBox(
      "Progress", 10*2, icon = icon("line-chart"),
      color = "blue"
    )
})

output$infoBox4 <- renderInfoBox({
    infoBox(
      "Progress", 10*2, icon = icon("line-chart"),
      color = "blue"
    )
})

output$infoBox5 <- renderInfoBox({
    infoBox(
      "Progress", 10*2, icon = icon("smile-o"),
      color = "blue"
    )
})

output$infoBox6 <- renderInfoBox({
    infoBox(
      "Progress", 10*2, icon = icon("frown-o"),
      color = "purple", fill = TRUE
    )
})



### Cumulative chart for points earned

output$cEarnPtsChart <- renderChart2({
	myData <- dataList()$sumData2
	interimData <- myData %>% filter( metrics == 'earnPts')
	myPlot <- nPlot(cumulatives ~ monthValue, group = 'yearValue', 
			data = interimData, type = 'lineChart')
	rm(myData)
	rm(interimData)
	return(myPlot)
})


### Cumulative chart for count of earn transactions

output$cEarnCountChart <- renderChart2({
	myData <- dataList()$sumData2
	interimData <- myData %>% filter( metrics == 'earnCount')
	myPlot <- nPlot(cumulatives ~ monthValue, group = 'yearValue', 
			data = interimData, type = 'lineChart')
	rm(myData)
	rm(interimData)
	return(myPlot)
})


### Cumulative chart for points redeemed

output$cRedemPtsChart <- renderChart2({
	myData <- dataList()$sumData2
	interimData <- myData %>% filter( metrics == 'redemPts')
	myPlot <- nPlot(cumulatives ~ monthValue, group = 'yearValue', 
			data = interimData, type = 'lineChart')
	rm(myData)
	rm(interimData)
	return(myPlot)
})


### Cumulative chart for count of redemption transactions

output$cRedemCountChart <- renderChart2({
	myData <- dataList()$sumData2
	interimData <- myData %>% filter( metrics == 'redemCount')
	myPlot <- nPlot(cumulatives ~ monthValue, group = 'yearValue', 
			data = interimData, type = 'lineChart')
	rm(myData)
	rm(interimData)
	return(myPlot)
})


### Cumulative chart for Customer Acquisition

output$cAcquisChart <- renderChart2({
	myData <- dataList()$sumData2
	interimData <- myData %>% filter( metrics == 'acquisCount')
	myPlot <- nPlot(cumulatives ~ monthValue, group = 'yearValue', 
			data = interimData, type = 'lineChart')
	rm(myData)
	rm(interimData)
	return(myPlot)
})


### Cumulative chart for Customer Acquisition

output$cChurnChart <- renderChart2({
	myData <- dataList()$sumData2
	interimData <- myData %>% filter( metrics == 'churnCount')
	myPlot <- nPlot(cumulatives ~ monthValue, group = 'yearValue', 
			data = interimData, type = 'lineChart')
	rm(myData)
	rm(interimData)
	return(myPlot)
})


})
