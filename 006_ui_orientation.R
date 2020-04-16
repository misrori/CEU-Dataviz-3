

#https://shiny.rstudio.com/articles/layout-guide.html



library(shiny)
library(jsonlite)
library(data.table)
library(httr)
library(rtsdata)
library(DT)
library(TTR)
library(plotly)
library(shinythemes)
library(shinydashboard)



source('000_functions.R')

# library(devtools)
# source_url('bit.ly/ceushiny')


# base --------------------------------------------------------------------


my_ui <- fluidPage(
  uiOutput('my_ticker'),
  dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date()),
  dataTableOutput('my_data'),
  div(plotlyOutput('data_plot', width = '60%', height='800px'),align="center")

)

my_server <- function(input, output) {
  sp500 <-get_sp500()

  output$my_ticker <- renderUI({
    selectInput('ticker', label = 'select a ticker', choices = setNames(sp500$name, sp500$description), multiple = FALSE)
  })


  my_reactive_df <- reactive({
    df<- get_data_by_ticker_and_date(input$ticker, input$my_date[1], input$my_date[2])
    return(df)
  })


  # # go to https://rstudio.github.io/DT/shiny.html
  output$my_data <- DT::renderDataTable({
    my_render_df(my_reactive_df())
  })


  output$data_plot <- renderPlotly({
    get_plot_of_data(my_reactive_df())
  })


}

shinyApp(ui = my_ui, server = my_server)





# sidebarlayout -----------------------------------------------------------



my_ui <- fluidPage(
  
  sidebarLayout(
    
    sidebarPanel(
      uiOutput('my_ticker'),
      dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date())
      
    ),
    mainPanel(
      dataTableOutput('my_data'),
      plotlyOutput('data_plot')
    )
  )

)

shinyApp(ui = my_ui, server = my_server)












# tabpanel ----------------------------------------------------------------



my_ui <- fluidPage(
  
  sidebarLayout(
    
    sidebarPanel(
      uiOutput('my_ticker'),
      dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date())
      
    ),
    mainPanel(
      tabsetPanel(
        tabPanel('Data', dataTableOutput('my_data')),
        tabPanel('Plot', plotlyOutput('data_plot') )
      )
      
    )
  )
)


shinyApp(ui = my_ui, server = my_server)




# just_tabset -------------------------------------------------------------



my_ui <- fluidPage(
  
   
      tabsetPanel(
        tabPanel('input_tab', 
                 uiOutput('my_ticker'),
                 dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date())
                 ),
        
        tabPanel('Data', dataTableOutput('my_data')),
        tabPanel('Plot', plotlyOutput('data_plot') )
      
    )
)
  


shinyApp(ui = my_ui, server = my_server)








# navbarpage --------------------------------------------------------------


my_ui <- navbarPage("Stock explorer",
             tabPanel("control",
                      uiOutput('my_ticker'),
                      dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date())
                      ),
             tabPanel("data",
                      dataTableOutput('my_data')
                      ),
             tabPanel("Plot",
                      plotlyOutput('data_plot')
                      )
  )
  
shinyApp(ui = my_ui, server = my_server)



# shinythemes -------------------------------------------------------------



my_ui <- 
                   navbarPage("Stock explorer", theme = shinytheme('cosmo'),
                              tabPanel("control",
                                       uiOutput('my_ticker'),
                                       dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date())
                              ),
                              tabPanel("data",
                                       dataTableOutput('my_data')
                              ),
                              tabPanel("Plot",
                                       plotlyOutput('data_plot')
                              )
                   )


shinyApp(ui = my_ui, server = my_server)


# shinydashboard ----------------------------------------------------------

#https://rstudio.github.io/shinydashboard/get_started.html
#https://rstudio.github.io/shinydashboard/structure.html#infobox

my_ui <- dashboardPage(
  dashboardHeader(title = "Stock explorer"),
  dashboardSidebar(
    uiOutput('my_ticker'),
    dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date())
  ),
  dashboardBody(
    dataTableOutput('my_data'),
    plotlyOutput('data_plot'),
    br(),
    infoBoxOutput('performance_info')
  )
)



my_server <- function(input, output) {
  sp500 <-get_sp500()
  
  output$my_ticker <- renderUI({
    selectInput('ticker', label = 'select a ticker', choices = setNames(sp500$name, sp500$description), multiple = FALSE)
  })
  
  
  my_reactive_df <- reactive({
    df<- get_data_by_ticker_and_date(input$ticker, input$my_date[1], input$my_date[2])
    return(df)
  })
  
  # # go to https://rstudio.github.io/DT/shiny.html
  output$my_data <- DT::renderDataTable({
    my_render_df(my_reactive_df())
  })
  
  output$data_plot <- renderPlotly({
    get_plot_of_data(my_reactive_df())
  })
  
  output$performance_info <- renderInfoBox({
    infoBox(
      "Positiv performance", paste0(round(sum(sp500$change >0)/nrow(sp500) *100, 0), "%" ), icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow"
    )
  })
  
  
}

shinyApp(ui = my_ui, server = my_server)

#https://github.com/misrori/r_ladies_v2



