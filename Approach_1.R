library(shiny)
library(png)
library(jpeg)
library(grid)

# Define the user interface
ui <- fluidPage(
  titlePanel("Image Processing Simulation"),
  sidebarLayout(
    sidebarPanel(
      fileInput("image", "Select an Image (JPEG or PNG)"),
      sliderInput("minR", "Min Red Value", 0, 1, 0, 0.01),
      sliderInput("minG", "Min Green Value", 0, 1, 0.3, 0.01),
      sliderInput("minB", "Min Blue Value", 0, 1, 0, 0.01),
      sliderInput("maxR", "Max Red Value", 0, 1, 0.4, 0.01),
      sliderInput("maxG", "Max Green Value", 0, 1, 1, 0.01),
      sliderInput("maxB", "Max Blue Value", 0, 1, 0.4, 0.01),
      actionButton("processBtn", "Process Image")
    ),
    mainPanel(
      plotOutput("outputImage")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  observeEvent(input$processBtn, {
    req(input$image)
    inFile <- input$image
    if (!is.null(inFile)) {
      ext <- tools::file_ext(inFile$name)
      if (ext %in% c("jpg", "jpeg", "png")) {
        minValues <- c(input$minR, input$minG, input$minB)
        maxValues <- c(input$maxR, input$maxG, input$maxB)
        processImage(inFile$datapath, minValues, maxValues)
      } else {
        showModal(modalDialog(
          title = "Invalid File",
          "Please select a valid JPEG or PNG image."
        ))
      }
    }
  })
  
  output$outputImage <- renderPlot({
    NULL  # Placeholder for the initial image display
  })
  
  processImage <- function(imagePath, minValues, maxValues) {
    image <- readJPEG(imagePath)
    dimn <- dim(image)
    result <- array(0, dim = dimn)
    
    for (i in 1:dimn[1]) {
      for (j in 1:dimn[2]) {
        pixel <- image[i, j, ]
        
        if (all(pixel >= minValues) && all(pixel <= maxValues)) {
          result[i, j, ] <- c(1, 1, 1)
        } else {
          result[i, j, ] <- pixel
        }
      }
    }
    
    # Display the processed image using grid graphics
    grid.raster(as.raster(result))
  }
}

# Run the Shiny app
shinyApp(ui, server)
