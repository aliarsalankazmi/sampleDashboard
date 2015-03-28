#
#
# load libraries, scripts, data

library(shiny)
library(shinyapps)
library(htmlwidgets)

mainImgPath <- './img/aimia_mainImg.jpg'


## body of shiny server side program

shinyServer(function(input, output, session) {


mainFileInfo <- reactive({ input$mainFile })
mainData <- reactive({ read.csv(mainFileInfo$datapath, header = TRUE, sep = ',') })


output$mainImg <- renderImage({
			expr = list(src = mainImgPath)
			}, deleteFile = FALSE)

output$imgPath <- renderPrint({mainImgPath})

})
