library(shiny)
require(rCharts)
options(RCHART_WIDTH = 800)


shinyServer(function(input, output) {
  
  # a large table, reative to input$show_vars
  output$mychart1 <- renderChart({
    if (input$metric == "AIC") {
    IC_dat <- sapply(names(mtcars)[names(mtcars) %in% input$pred_vars & !(names(mtcars) %in% input$target)], function(x) { AIC(lm(as.formula(paste(input$target,"~",x, sep=" ")), data=mtcars))})
    }
    else if (input$metric == "BIC") {
      IC_dat <- sapply(names(mtcars)[names(mtcars) %in% input$pred_vars & !(names(mtcars) %in% input$target)], function(x) { BIC(lm(as.formula(paste(input$target,"~",x, sep=" ")), data=mtcars))})  
    }
    else {
      IC_dat <- sapply(names(mtcars)[names(mtcars) %in% input$pred_vars & !(names(mtcars) %in% input$target)], function(x) { summary(lm(as.formula(paste(input$target,"~",x, sep=" ")), data=mtcars))$adj.r.squared})
    }
    
    IC_dat <- data.frame(IC_dat)
    IC_dat$VAR <- attr(IC_dat, "row.names")
    colnames(IC_dat)[2] <- "Predictor"
    
    IC_dat <<- IC_dat
    
    if (input$metric == "AIC") {
      colnames(IC_dat)[1] <- "AIC"
      p1 <- rPlot(AIC ~ Predictor, data=IC_dat, type="bar")
    } else if (input$metric == "BIC") {
      colnames(IC_dat)[1] <- "BIC"
      p1 <- rPlot(BIC ~ Predictor, data=IC_dat, type="bar")
    } else { 
      colnames(IC_dat)[1] <- "R_Squared"
      p1 <- rPlot(R_Squared ~ Predictor, data=IC_dat, type="bar")
    }
    
    p1$addParams(height = 300, dom = 'mychart1')
    p1$guides(x = list(title = "", ticks = unique(IC_dat$Predictor)))
    return(p1)
    
  })
  
  output$mychart2 <- renderChart2({
    formulaText <- reactive({
      paste(input$target, "~", input$var2) })
    p2 <- hPlot(as.formula(formulaText()),data=mtcars, type="scatter")
    p2$addParams(height = 400, dom = 'mychart2')
    return(p2)
  })
  
  # customize the length drop-down menu; display 30 rows per page by default
  output$mytable1 <- renderDataTable({
    mtcars[names(mtcars) %in% union(input$target, input$pred_vars)]
  }, options = list(lengthMenu = c(5, 30, 50), pageLength = 30))
  
  # Text output for target variable
  output$mytext <- renderText({
    mytext <- paste("The Selected Target Variable is ",input$target,sep=" ")
    return(mytext) })
  
  output$imp_table <- renderTable({
    rownames(IC_dat) <- NULL
    if (input$metric == 'rsq') {
      IC_dat <- IC_dat[order(IC_dat[,1], decreasing=T),] }
    else {
      IC_dat <- IC_dat[order(IC_dat[,1]),]}
    return(IC_dat[1:input$slider1,])})
  
})