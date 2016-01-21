library(markdown)
shinyUI(navbarPage("Wine Quality",
## Introduction ===============================================================================================                   
  tabPanel("Introduction",
      fluidRow(
          column(12,
              includeMarkdown("Prstat.md")
          )
      )
  ),

## Data Set ======================================================================================================
  tabPanel("Data Set",
     fluidRow(
         dataTableOutput(outputId = "table")
    )
  ),
## Exploratory Data Analysis ==========================================  
  tabPanel("Exploratory Data Analysis",
    mainPanel(
        h4("Normalized Features"),
        plotOutput('f_plot')
    )
  ),

## Random Forest ==============================================================================================
  tabPanel("Random Forest",
    sidebarLayout(
        sidebarPanel(
            h4('Random Forest Model'),
            sliderInput("fraction", "Training set (portion):", 
                min = 0.5, max = 0.9, value = 0.7, step = 0.1),
            sliderInput("ntree", "Number of trees:", 
                min = 50, max = 500, value = 100, step = 50),
            h4('N.B.: Please be patient! 
               Do not switch tabs until the results are displayed. 
               It may take up to 1 minute to run the code')
        ),
        mainPanel(
            h4("Confusion Matrix and Statistics"),
            verbatimTextOutput('confMatrix'),
            plotOutput('i_plot')                
        )
    )
  ),
## About ======================================================================================================
  tabPanel("About",
        fluidRow(
            column(12,
                   includeMarkdown("about.md")
            )
        )
  )
))