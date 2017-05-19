#  Make an interactive plot with Shiny!
# This is the server logic for your Shiny web application.

library(shiny)
#library(data.table)
#library(reshape)
#library(ggplot2)
#library(rbokeh)

# Define server logic required to draw contact map

shinyServer(function(input, output) {
  
  output$rbokeh <- renderRbokeh({
    
    dt.plot <- dt.grd.sym[1:input$data.points] 
    n <- nrow(dt.plot)
    ramp <- colorRampPalette(c("red", "blue"))(n)
    p <- figure() %>%
      ly_points(i, j, data = dt.plot,
                color = ramp, size = 13*prob,
                hover = list(i, j))
    p %>%                                                                                                         
      x_range(c(957,1350)) %>%
      y_range(c(1350,957)) %>%
      x_axis(label = "amino acid j") %>%
      y_axis(label = "amino acid i")
  })
  
})