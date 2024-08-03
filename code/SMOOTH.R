# an attempt to smoothen the boundaries/edges of the image after green screen removal using connected objects approach
create_disc_se <- function(radius) {
  # Calculate the size of the square matrix to hold the disc
  size <- 2 * radius + 1
  # Create an empty matrix of zeros
  se <- matrix(0, nrow = size, ncol = size)
  # Calculate the coordinates of the center
  center <- radius + 1
  # Loop through the matrix and set values to 1 if they are inside the disc
  for (i in 1:size) {
    for (j in 1:size) {
      if ((i - center)^2 + (j - center)^2 <= radius^2) {
        se[i, j] <- 1
      }
    }
  }
  return(se)
}

# Example: Create a disc structuring element with a radius of 2
radius <- 2
se <- create_disc_se(radius)
print(se)





dilate <- function(binary_image, se) {
  result <- matrix(0, nrow = nrow(binary_image), ncol = ncol(binary_image))
  for (i in 1:nrow(binary_image)) {
    for (j in 1:ncol(binary_image)) {
      if (binary_image[i, j] == 1) {
        # Check the neighborhood defined by the structuring element
        for (se_row in 1:nrow(se)) {
          for (se_col in 1:ncol(se)) {
            ni <- i + (se_row - 1)
            nj <- j + (se_col - 1)
            if (ni >= 1 && ni <= nrow(binary_image) && nj >= 1 && nj <= ncol(binary_image)) {
              result[ni, nj] <- 1
            }
          }
        }
      }
    }
  }
  return(result)
}







erode <- function(binary_image, se) {
  result <- matrix(0, nrow = nrow(binary_image), ncol = ncol(binary_image))
  for (i in 1:nrow(binary_image)) {
    for (j in 1:ncol(binary_image)) {
      all_ones <- TRUE
      for (se_row in 1:nrow(se)) {
        for (se_col in 1:ncol(se)) {
          ni <- i + (se_row - 1)
          nj <- j + (se_col - 1)
          if (ni >= 1 && ni <= nrow(binary_image) && nj >= 1 && nj <= ncol(binary_image)) {
            if (binary_image[ni, nj] == 0) {
              all_ones <- FALSE
              break
            }
          } else {
            all_ones <- FALSE
          }
        }
        if (!all_ones) {
          break
        }
      }
      if (all_ones) {
        result[i, j] <- 1
      }
    }
  }
  return(result)
}
