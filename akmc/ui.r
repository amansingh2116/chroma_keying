library(shiny)
library(png)
library(jpeg)
library(grid)

# Define the UI for the Shiny app
ui <- fluidPage(
  titlePanel("Chroma - Keying"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("image_file", "Select an Image"),
      sliderInput("threshold", "Green Lower Bound", min = 0, max = 1, value = 0.28, step = 0.01),
      sliderInput("threshold2", "Green Upper Bound", min = 0, max = 1, value = 0.97, step = 0.01),
      sliderInput("threshold3", "Grey Bound", min = 0, max = 1, value = 0, step = 0.005),
      checkboxInput("advanced", "Advanced Chroma Keying", FALSE),
      conditionalPanel(
        condition = "input.advanced == true",
        sliderInput("minR", "Min Red Value", 0, 1, 0, 0.01),
        sliderInput("minG", "Min Green Value", 0, 1, 0.3, 0.01),
        sliderInput("minB", "Min Blue Value", 0, 1, 0, 0.01),
        sliderInput("maxR", "Max Red Value", 0, 1, 0.4, 0.01),
        sliderInput("maxG", "Max Green Value", 0, 1, 1, 0.01),
        sliderInput("maxB", "Max Blue Value", 0, 1, 0.4, 0.01)
      )
    ),
    
    mainPanel(
      imageOutput("original_image"),
      imageOutput("processed_image")
    )
  )
)
