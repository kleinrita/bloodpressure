


library(shiny)

library(shinyTime)



shinyUI(fluidPage(
  
  
  
  titlePanel("shinyTime Example App"),
  
  
  
  sidebarLayout(
    
    sidebarPanel(
      
      timeInput("time_input1", "Enter time", value = strptime("12:34:56", "%T")),
      
      timeInput("time_input2", "Enter time (5 minute steps)", value = strptime("12:34:56", "%T"), minute.steps = 5),
      
      actionButton("to_current_time", "Current time")
      
    ),
    
    
    
    mainPanel(
      
      textOutput("time_output1"),
      
      textOutput("time_output2")
      
    )
    
  )
  
)
)


