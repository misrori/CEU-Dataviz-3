library(shiny)
library(jsonlite)
library(data.table)
library(httr)
library(rtsdata)
library(DT)
library(TTR)
library(plotly)

source('000_functions.R')

# library(devtools)
# source_url('bit.ly/ceushiny')


my_ui <- fluidPage(
  h1('hello CEU'),
  uiOutput('my_ticker'),
  textOutput('selected_ticker'),
  dateRangeInput('my_date',label = 'Date', start = '2018-01-01', end = Sys.Date()),
  #tableOutput('my_data')
  dataTableOutput('my_data'),
  #plotlyOutput('data_plot')
  div(plotlyOutput('data_plot', width = '60%', height='800px'),align="center"),
  plotOutput('ggoutput')
)

my_server <- function(input, output) {
  sp500 <-get_sp500()
  
  output$my_ticker <- renderUI({
    selectInput('ticker', label = 'select a ticker', choices = setNames(sp500$name, sp500$description), multiple = FALSE)
  })
  
  
  output$selected_ticker <- renderText({
    return(input$ticker)
  })
  
  my_reactive_df <- reactive({
    df<- get_data_by_ticker_and_date(input$ticker, input$my_date[1], input$my_date[2])
    return(df)
  })
  output$ggoutput <- renderPlot({get_ggplot_plot(my_reactive_df())})
  
  # output$my_data <- renderTable({
  #   my_reactive_df()
  # })
  
  # #it gave me some error
  # output$my_data <- renderDataTable({
  #   my_reactive_df()
  # })
  # 
  
  # output$my_data <- DT::renderDataTable({
  #   my_reactive_df()
  # })
  # 
  
  # # go to https://rstudio.github.io/DT/shiny.html
  output$my_data <- DT::renderDataTable({
    my_render_df(my_reactive_df())
  })
  
  
  output$data_plot <- renderPlotly({
    get_plot_of_data(my_reactive_df())
  })


}

shinyApp(ui = my_ui, server = my_server) 





