#
#
# load libraries, scripts, data

library(shiny)
library(dplyr)
library(tidyr)
library(lubridate)
library(shinyapps)
library(htmlwidgets)

options(shiny.trace = TRUE,
	  shiny.maxRequestSize=300*1024^2)


mainImgPath <- './img/aimia_mainImg.jpg'


## body of shiny server side program

shinyServer(function(input, output, session) {


dataList <- reactive({
		mainFileInfo <- input$mainFile
		uploadData <- read.csv(mainFileInfo$datapath, header = TRUE, stringsAsFactors = FALSE)
		uploadData$yearmonth <- as.Date(uploadData$yearmonth, '%d/%m/%Y')

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

		dfList <- list(sumData1 = sumData1, sumData2 = sumData2, sumData3 = sumData3,
				   sumData4 = sumData4, earnData = earnData, redempData = redempData,
				   custData = custData)

		return(dfList)
})

})
