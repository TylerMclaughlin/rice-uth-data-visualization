
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Predicted Amino Acid Contacts for GAP-related domain (residues 962-1345)"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("data.points",
                  "How Many Data Points Would You Like to Plot?",
                  min = 50,
                  max = 500,
                  step = 50,
                  value = 300)
    ),
    
    # Show a plot of the generated distributions
    mainPanel(
      rbokehOutput("rbokeh")
    )
  )
))

