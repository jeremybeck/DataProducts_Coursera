library(shiny)
library(rCharts)  # for the diamonds dataset
#options(RCHART_LIB = "polycharts")

shinyUI(fluidPage(
  titlePanel('Exploratory Analysis App Demo'),
    sidebarPanel(h4("Global Options"),
      selectInput("target", label="Target Variable",
                  choices = names(mtcars)),
      checkboxGroupInput("pred_vars", label="Predictor Variables",
                         choices = names(mtcars),
                         selected = names(mtcars))
    ),
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel('Description', 
        h4("Application Overview:"),
        p("This app provides some basic exploratory analysis capabilities to begin building a model. 
          In this example, the mtcars data set is used."),
        h4("Step 1:"),
        p("The first step to using this app is to set the global options on the left hand side of this page. 
          This includes selecting a target variable (mpg by default), as well as which other columns in 
          the data set you want to include as predictors. The selection of the target variable here will 
          propagate throughout the entire app."), 
        h4("Step 2:"),
        p("Select the 'Information Criteria Metrics' tab to obtain a ranking of variables' predictive power to the target variable using 
          one of three metrics, Akaike Information Criteria (AIC), Bayesian Information Criteria (BIC), 
          and Adjusted R-Squared. For AIC and BIC, the lower values indicate more predictive power, and 
          for adjusted R-squared, the higher values indicate more predictive power."),
        p("On the bottom of the 'Information Criteria Metrics' tab you can also use the slider input to return the N best predictors."),
        h4("Step 3:"),
        p("To gain a better understanding of the relationship between the target variable and the predictors, 
          switch to the 'Exploratory Plots' tab, and use the dropdown menu to select any of the columns in the data set to plot against the target."),
        h4("Step 4:"),
        p("If you really want to dig into the raw data, switch to the 'Data' tab"),
        h4("Step 5:"),
        p("Take what you've learned from this app, and start trying to model your data.  With mtcars, there are only a few predictors, but imagine if there were hundreds you had to dig through!")
        ),
        tabPanel('Information Criteria Metrics', fluidPage(
          fluidRow(h4("How Predictive are the variables?"),
            p("Information criteria metrics can be used to assess the goodness of fit for models. When training univariate models, 
                     the Akaike Information criteria (AIC) or Bayesian Information criteria (BIC) can distinguish which predictors are related to the target variable."),
            p("For more information on these metrics, see these links:",a("AIC", href="https://en.wikipedia.org/wiki/Akaike_information_criterion"),",",
              a("BIC", href="https://en.wikipedia.org/wiki/Bayesian_information_criterion"),",",
              a("Adjusted R-Squared", href="https://en.wikipedia.org/wiki/Coefficient_of_determination#Adjusted_R2"))),
          fluidRow(selectInput("metric", label="Select A Metric",
                               choices = list("Bayesian Information Criteria" = "BIC", 
                                              "Akaike Information Criteria" = "AIC",
                                              "Adjusted R-Squared" = "rsq")),
          fluidRow(chartOutput("mychart1", "polycharts")),
          fluidRow(sliderInput("slider1", label = h3("Top N Variables:"), min = 1, 
                               max = ncol(mtcars), value = 5, step=1)),
          fluidRow(tableOutput('imp_table'))))),
        
        tabPanel('Exploratory Plots', fluidPage(
          fluidRow(p(textOutput("mytext"))),
          fluidRow(selectInput("var2", label="Predictor to Compare",
                               choices = names(mtcars),
                               selected = names(mtcars)[2])),
          fluidRow(chartOutput("mychart2", "highcharts")))),
        
        tabPanel('Data', dataTableOutput('mytable1'))
      )
    )
  )
)