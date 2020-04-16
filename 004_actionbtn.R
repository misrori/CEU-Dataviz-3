
#BMI calculator with action btn


library(shiny)

source('000_functions.R')
ui <- fluidPage(
  
  # Application title
  titlePanel("BMI calculator"),
  sliderInput('weight', label = 'Your weight(kg)', min = 0, max = 130,step = 1, value = 65),
  sliderInput('height', label = 'Your height(cm)', min = 100, max = 250, value = 150),
  actionButton('go', 'Calculate'),
  br(),
  verbatimTextOutput('bmi_number_text'),
  h2('Based on your BMI You are:'),
  textOutput('bmi_text')
  
  #
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  #explane also observe
  observeEvent(input$go,{
    my_weight <- isolate(input$weight)
    my_height <- isolate(input$height)
    
    output$bmi_number_text <- renderPrint({
      return(paste0('Your BMI is: ', as.character(   round(my_weight / ( ((my_height)/100)^2)  ,2)   )  ))
    })
    
    output$bmi_text <- renderText({
      get_bmi_by_index_number(round(my_weight / ( ((my_height)/100)^2)  ,2))
    })
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

