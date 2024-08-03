# Load required libraries
library(shiny)
library(png)
library(jpeg)

# Define the UI for the Shiny app
ui <- fluidPage(
  titlePanel("Chroma - Keying"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("image_file", "Select an Image"),
      sliderInput("threshold", "Green Lower Bound", min = 0, max = 1, value = 0.28, step = 0.01),
      sliderInput("threshold2", "Green Upper Bound", min = 0, max = 1, value = 0.97, step = 0.01),
      sliderInput("threshold3", "Grey Bound", min = 0, max = 1, value = 0, step = 0.005)
    ),
    
    mainPanel(
      imageOutput("original_image"),
      imageOutput("processed_image")
    )
  )
)

# Define the server for the Shiny app
server <- function(input, output) {
  observe({
    req(input$image_file)
    
    image <- readPNG(input$image_file$datapath)
    
    # Function to process the image
    process_image <- function(image, threshold, threshold2, threshold3) {
      dimn <- dim(image)
      result <- array(0, dim = dimn)
      
      for (i in 1:dimn[1]) {
        for (j in 1:dimn[2]) {
          pixel <- image[i, j, ]
          r <- pixel[1]
          g <- pixel[2]
          b <- pixel[3]
          
          if (
            which.max(pixel) == 2 &&
            g > threshold &&
            g <= threshold2 &&
            (abs(r - b) >= threshold3) &&
            (abs(r - g) >= threshold3) &&
            (abs(b - g) >= threshold3)
          ) {
            result[i, j, ] <- c(1, 1, 1)
          } else {
            result[i, j, ] <- pixel
          }
        }
      }
      
      return(result)
    }
    
    output$original_image <- renderImage({
      list(src = input$image_file$datapath,
           contentType = "image/jpeg",
           width = "80%")
    })
    
    output$processed_image <- renderImage({
      processed <- process_image(image, input$threshold, input$threshold2, input$threshold3)
      outfile <- tempfile(fileext = '.jpeg')
      writeJPEG(processed, target = outfile)
      
      list(src = outfile, contentType = "image/jpeg", width = "80%")
    })
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)