# Chroma Keying Project

A comprehensive implementation of chroma keying (green screen removal) algorithms developed at ISI Kolkata. This project explores multiple approaches to background removal and provides an interactive web application for real-time image processing.

## Overview

Chroma keying is a fundamental technique in visual media production that enables the replacement of a specific color (typically green or blue) with other imagery. This project implements three distinct approaches to chroma keying, culminating in a novel Grey Bound methodology that addresses common limitations found in traditional methods.

The implementation includes both standalone R scripts for individual algorithm testing and a comprehensive Shiny web application that allows users to experiment with different parameters and compare results across approaches.

## Features

- Three distinct chroma keying algorithms with different strengths and use cases
- Interactive web interface built with R Shiny
- Real-time parameter adjustment and preview
- Support for JPEG and PNG image formats
- Comparative analysis tools for algorithm evaluation
- Deployed web application for immediate testing

## Algorithms

### Approach 1: Min-Max Bound Method

The Min-Max Bound approach establishes threshold ranges for red, green, and blue color components to identify pixels that fall within the green screen color space. The algorithm processes each pixel by comparing its RGB values against predefined minimum and maximum bounds.
[Here](https://github.com/amansingh2116/chroma_keying/blob/main/code/Approach_1.R) is the code.

**Implementation Details:**
- Sets independent thresholds for each color channel (R, G, B)
- Identifies pixels where all three components fall within specified ranges
- Replaces matching pixels with white (background removal indicator)
- Simple and computationally efficient but limited in handling color variations

**Strengths:** Fast processing, clear parameter interpretation
**Limitations:** Struggles with color spill, lighting variations, and complex green shades

### Approach 2: Pixel Predominantly Green Method

This approach focuses on identifying pixels where the green component is dominant compared to red and blue values. The algorithm examines the relative intensity of color channels rather than absolute values.
[Here](https://github.com/amansingh2116/chroma_keying/blob/main/code/Approach_2.R) is the code.

**Implementation Details:**
- Compares green channel intensity against red and blue channels
- Identifies pixels where green is the maximum component
- Does not require explicit threshold setting for green dominance
- More adaptive to varying lighting conditions

**Strengths:** Better handling of lighting variations, simplified parameter setup
**Limitations:** Can incorrectly identify non-green pixels with slight green dominance, edge artifacts

### Approach 3: Grey Bound Solution (Novel Method)

The Grey Bound approach combines strengths from both previous methods while introducing additional constraints to handle edge cases more effectively. This method incorporates dynamic thresholding with considerations for grey pixels and color difference calculations.
[Here](https://github.com/amansingh2116/chroma_keying/blob/main/code/Approach_3.R) is the code.

**Implementation Details:**
- Requires green to be the dominant color component
- Applies upper and lower bounds for green channel intensity
- Calculates absolute differences between color channels
- Introduces grey bound threshold to preserve near-neutral pixels
- Combines multiple conditions for more precise pixel classification

**Key Innovation:** The grey bound parameter prevents the removal of pixels where color channels are too similar, preserving important detail in shadows, edges, and neutral-colored objects.

**Advantages:** Superior edge preservation, reduced artifacts, better handling of mixed lighting conditions

## Project Structure

```
chroma_keying/
├── akmc/                          # Main Shiny application
│   ├── server.r                   # Server-side logic
│   ├── ui.r                       # User interface definition
│   └── rsconnect/                 # Deployment configuration
├── code/                          # Algorithm implementations
│   ├── Approach_1.R              # Min-Max Bound implementation
│   ├── Approach_2.R              # Predominantly Green implementation
│   ├── Approach_3.R              # Grey Bound implementation
│   ├── SMOOTH.R                   # Edge smoothing utilities
│   └── aproaches_combined.R       # Multi-algorithm comparison tool
├── documentation/                 # Project documentation
│   ├── chroma_keying_report.pdf   # Detailed technical report
│   └── CHROMA-KEYING_presentation.pdf # Project presentation
└── sample_output/                 # Example results and outputs
```

## Dependencies

The project requires the following R packages:

```r
# Core packages
install.packages(c("shiny", "jpeg", "png"))

# Optional packages for extended functionality
install.packages(c("grid", "tools"))
```

**Package Details:**
- `shiny`: Web application framework for interactive interfaces
- `jpeg`: Reading and writing JPEG image files
- `png`: Reading and writing PNG image files
- `grid`: Graphics utilities for image display
- `tools`: File extension handling utilities

## Installation and Setup

### Local Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/amansingh2116/chroma_keying.git
   cd chroma_keying
   ```

2. **Install required R packages:**
   ```r
   install.packages(c("shiny", "jpeg", "png", "grid", "tools"))
   ```

3. **Run individual algorithms:**
   ```r
   # Test Approach 1 (Min-Max Bound)
   source("code/Approach_1.R")
   
   # Test Approach 2 (Predominantly Green)
   source("code/Approach_2.R")
   
   # Test Approach 3 (Grey Bound)
   source("code/Approach_3.R")
   ```

4. **Launch the main application:**
   ```r
   # Run the comprehensive Shiny app
   shiny::runApp("akmc/")
   
   # Or run the comparison tool
   source("code/aproaches_combined.R")
   ```

### Web Application Access

To enhance usability and interactivity, we developed a Shiny app using R. This web application framework allows users to dynamically adjust thresholds, fine-tuning the chroma keying process for optimal results. The Shiny implementation adds flexibility and accessibility to our project, catering to novice and experienced users.

To provide users with more flexibility and address corner cases, the final R software allows users to choose between the two approaches for applying chroma keying. [Here](https://github.com/amansingh2116/chroma_keying) is the GitHub repository of the project, and [here](https://amansingh2116.shinyapps.io/akmc/) is the software you can use to apply chroma keying to your images. Experiment with the settings to understand the algorithms better.

## Usage Guide

### Basic Operation

1. **Image Upload:** Select a JPEG or PNG image file using the file input control
2. **Algorithm Selection:** Choose between basic chroma keying (Grey Bound) or advanced mode (Min-Max Bound)
3. **Parameter Adjustment:** Use the slider controls to fine-tune the processing parameters
4. **Real-time Preview:** View the original and processed images side by side

### Parameter Configuration

**Grey Bound Method (Basic Mode):**
- **Green Lower Bound (0.28):** Minimum green intensity threshold
- **Green Upper Bound (0.97):** Maximum green intensity threshold
- **Grey Bound (0.0):** Minimum difference required between color channels

**Min-Max Bound Method (Advanced Mode):**
- **Min/Max Red Values:** Threshold range for red channel
- **Min/Max Green Values:** Threshold range for green channel
- **Min/Max Blue Values:** Threshold range for blue channel

### Optimization Tips

- Start with default parameter values and make incremental adjustments
- Use lower grey bound values for images with subtle color variations
- Increase green bounds for images with varying lighting conditions
- Test multiple parameter combinations to achieve optimal results

## Documentation

Comprehensive technical documentation is available in the documentation directory:

- **Technical Report:** [chroma_keying_report.pdf](documentation/chroma_keying_report.pdf) - Detailed algorithmic analysis and comparative evaluation
- **Presentation:** [CHROMA-KEYING_presentation.pdf](documentation/CHROMA-KEYING_presentation.pdf) - Project overview and key findings

These documents provide in-depth coverage of the theoretical foundations, implementation details, and experimental results.

