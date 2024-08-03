library(shiny)
library(jpeg)

# Define the UI for the Shiny app
ui <- fluidPage(
  titlePanel("Chroma - Keying"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("image_file", "Select an Image"),
      selectInput("approach", "Choose Approach", choices = c("Approach 1", "Approach 2", "Both"), selected = "Approach 1"),
      uiOutput("approach1_ui"),
      uiOutput("approach2_ui"),
      uiOutput("approach3_ui")
    ),
    
    mainPanel(
      imageOutput("original_image"),
      imageOutput("processed_image")
    )
  )
)

# Define the server for the Shiny app
server <- function(input, output, session) {
  img_data <- reactiveValues(img = NULL)
  
  observe({
    req(input$image_file)
    img_data$img <- readJPEG(input$image_file$datapath)
  })
  
  output$original_image <- renderImage({
    if (!is.null(img_data$img)) {
      list(src = input$image_file$datapath,
           contentType = "image/jpeg",
           width = "80%")
    }
  }, deleteFile = FALSE)
  
  output$processed_image <- renderImage({
    if (is.null(img_data$img)) return(NULL)
    
    if (input$approach == "Approach 1") {
      processed <- process_image_approach1(img_data$img, input$threshold, input$threshold2, input$threshold3)
    } else if (input$approach == "Approach 2") {
      processed <- process_image_approach2(img_data$img, input$minG, input$maxG, input$minR, input$maxR, input$minB, input$maxB)
    } else if (input$approach == "Both") {
      processed <- process_image_both_approaches(img_data$img, input$threshold3, input$minG3, input$maxG3, input$minR3, input$maxR3, input$minB3, input$maxB3)
    }
    
    outfile <- tempfile(fileext = '.jpeg')
    writeJPEG(processed, target = outfile)
    
    list(src = outfile, contentType = "image/jpeg", width = "73%")
  }, deleteFile = FALSE)
  
  # Approach 1 UI
  output$approach1_ui <- renderUI({
    if (input$approach %in% c("Approach 1")) {
      tagList(
        sliderInput("threshold", "Green Lower Bound", min = 0, max = 1, value = 0.28, step = 0.01),
        sliderInput("threshold2", "Green Upper Bound", min = 0, max = 1, value = 0.97, step = 0.01),
        sliderInput("threshold3", "Grey Bound", min = 0, max = 1, value = 0, step = 0.005)
      )
    }
  })
  
  # Approach 2 UI
  output$approach2_ui <- renderUI({
    if (input$approach %in% c("Approach 2")) {
      tagList(
        sliderInput("minG", "Min Green Value", 0, 1, 0, 0.01),
        sliderInput("maxG", "Max Green Value", 0, 1, 0.97, 0.01),
        sliderInput("minR", "Min Red Value", 0, 1, 0, 0.01),
        sliderInput("maxR", "Max Red Value", 0, 1, 0.4, 0.01),
        sliderInput("minB", "Min Blue Value", 0, 1, 0, 0.01),
        sliderInput("maxB", "Max Blue Value", 0, 1, 0.4, 0.01)
      )
    }
  })
  
  # Approach 3 UI
  output$approach3_ui <- renderUI({
    if (input$approach == "Both") {
      tagList(
        sliderInput("minG3", "Min Green Value", 0, 1, 0, 0.01),
        sliderInput("maxG3", "Max Green Value", 0, 1, 0.97, 0.01),
        sliderInput("minR3", "Min Red Value", 0, 1, 0, 0.01),
        sliderInput("maxR3", "Max Red Value", 0, 1, 0.4, 0.01),
        sliderInput("minB3", "Min Blue Value", 0, 1, 0, 0.01),
        sliderInput("maxB3", "Max Blue Value", 0, 1, 0.4, 0.01),
        sliderInput("threshold3", "Grey Bound", min = 0, max = 1, value = 0, step = 0.005)
      )
    }
  })
}

# Function to process the image (Approach 1)
process_image_approach1 <- function(image, threshold, threshold2, threshold3) {
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

# Function to process the image (Approach 2)
process_image_approach2 <- function(image, minG, maxG, minR, maxR, minB, maxB) {
  dimn <- dim(image)
  result <- array(0, dim = dimn)
  
  for (i in 1:dimn[1]) {
    for (j in 1:dimn[2]) {
      pixel <- image[i, j, ]
      r <- pixel[1]
      g <- pixel[2]
      b <- pixel[3]
      
      if (
        g >= minG && g <= maxG &&
        r >= minR && r <= maxR &&
        b >= minB && b <= maxB
      ) {
        result[i, j, ] <- c(1, 1, 1)
      } else {
        result[i, j, ] <- pixel
      }
    }
  }
  
  return(result)
}

# Function to process the image (Both Approaches)
process_image_both_approaches <- function(image, threshold3, minG3, maxG3, minR3, maxR3, minB3, maxB3) {
  dimn <- dim(image)
  result <- array(0, dim = dimn)
  
  for (i in 1:dimn[1]) {
    for (j in 1:dimn[2]) {
      pixel <- image[i, j, ]
      r <- pixel[1]
      g <- pixel[2]
      b <- pixel[3]
      
      if (
        g >= minG3 && g <= maxG3 &&
        r >= minR3 && r <= maxR3 &&
        b >= minB3 && b <= maxB3 &&
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

# Run the Shiny app
shinyApp(ui = ui, server = server)
