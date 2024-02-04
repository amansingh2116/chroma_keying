
# Define the server for the Shiny app
server <- function(input, output) {
  observe({
    req(input$image_file)
    
    image <- readJPEG(input$image_file$datapath)
    
    # Function to process the image (Basic Chroma Keying)
    process_image_basic <- function(image, threshold, threshold2, threshold3) {
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
    
    # Function to process the image (Advanced Chroma Keying)
    process_image_advanced <- function(image, minValues, maxValues) {
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
      
      return(result)
    }
    
    output$original_image <- renderImage({
      list(src = input$image_file$datapath,
           contentType = "image/jpeg",
           width = "80%")
    })
    
    output$processed_image <- renderImage({
      if (input$advanced) {
        processed <- process_image_advanced(image, c(input$minR, input$minG, input$minB), c(input$maxR, input$maxG, input$maxB))
      } else {
        processed <- process_image_basic(image, input$threshold, input$threshold2, input$threshold3)
      }
      
      outfile <- tempfile(fileext = '.jpeg')
      writeJPEG(processed, target = outfile)
      
      list(src = outfile, contentType = "image/jpeg", width = "80%")
    })
  })
}

