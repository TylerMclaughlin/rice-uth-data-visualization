#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Protein Contact Map"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("datapoints",
                     "Number of DataPoints:",
                     min = 50,
                     max = 500,
                     value = 200),
         selectInput("size.map",
                     "Map to size:",
                   choices = c("r_sco","s_sco","prob"),
                   selected = "r_sco"
                     )
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         rbokehOutput("Plot")
      )
   )
)

# Define server logic required to plot contact map
server <- function(input, output) {
   
   output$Plot <- renderRbokeh({
      # generate bins based on input$bins from ui.R
     n <- nrow(dt[1:input$datapoints])
     ramp <- colorRampPalette(c("red", "blue"))(n)
  
      
      # draw the histogram with the specified number of bins
      p <- figure() %>%
        ly_points(a,b,data=dt[1:input$datapoints],hover = list(a,b),size=input$size.map,color = ramp) 
      p
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

