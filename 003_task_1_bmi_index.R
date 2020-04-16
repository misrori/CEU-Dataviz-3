

library(shiny)

source('000_functions.R')
# library(devtools)
# source_url('bit.ly/ceushiny')


ui <- fluidPage(
  
  # Application title
  titlePanel("BMI calculator"),
  sliderInput('weight', label = 'Your weight(kg)', min = 0, max = 130,step = 1, value = 65),
  sliderInput('height', label = 'Your height(cm)', min = 100, max = 250, value = 150),
  br(),
  verbatimTextOutput('bmi_number_text'),
  h2('Based on your BMI You are:'),
  textOutput('bmi_text')
  
  #
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$bmi_number_text <- renderPrint({
    return(paste0('Your BMI is: ', as.character(   round(input$weight / ( ((input$height)/100)^2)  ,2)   )  ))
  })
  
  output$bmi_text <- renderText({
    get_bmi_by_index_number(round(input$weight / ( ((input$height)/100)^2)  ,2))
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

