
library(shiny)

shinyServer(function(input, output) {
  
  output$time_output1 <- renderText(strftime(input$time_input1, "%T"))
  
  output$time_output2 <- renderText(strftime(input$time_input2, "%R"))
  
  
  
  observeEvent(input$to_current_time, {
    
    updateTimeInput(session, "time_input1", value = Sys.time())
    
    updateTimeInput(session, "time_input2", value = Sys.time())
    
  })
  
  
  
}
)



