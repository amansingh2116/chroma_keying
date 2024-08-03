> **_NOTE:_** For detailed explanation with illustration go to documentation section to find the [project report](https://github.com/amansingh2116/chroma_keying/blob/main/documentation/chroma_keying_report.pdf) and [presentation](https://github.com/amansingh2116/chroma_keying/blob/main/documentation/CHROMA-KEYING_presentation.pdf).

# Chroma Keying (green screen removal)
Chroma keying, commonly known as green screen or blue screen removal, is a transformative technique in film, television, and digital media production.

Chroma keying offers filmmakers and content creators unparalleled creative freedom, allowing them to composite multiple elements seamlessly. Whether placing actors in exotic locations, creating fantastical worlds, or adding dynamic backgrounds to news broadcasts, chroma keying unlocks endless storytelling and visual expression possibilities.

Our project at ISI Kolkata delves into chroma keying, a fundamental technique in visual media production. By combining elements from various techniques, including Min-Max Bound and Pixel Predominantly Green, we crafted a novel solution called the Grey Bound approach. This integrated methodology overcomes previous limitations, offering a promising avenue for future advancements in chroma keying.

### Approach 1: Minimum and Maximum Bound

Initially, we explored the Min-Max Bound approach, which involved setting thresholds for the red, green, and blue components of pixels to identify and replace the green screen background. Despite its simplicity, this method proved inadequate in handling real-world scenarios' nuances, particularly color spill and complex green shades.
[Here is the code](https://github.com/amansingh2116/chroma_keying/blob/main/code/Approach_1.r)

### Approach 2: Pixel Predominantly Green

Next, we investigated the Pixel Predominantly Green approach, which focused on identifying pixels where the green component exceeded the red and blue components. While promising, this approach struggled with issues related to green balance variation, foreground variations, and edge artifacts, highlighting the need for a more sophisticated solution.
[Here is the code](https://github.com/amansingh2116/chroma_keying/blob/main/code/Approach_2.r)

### Approach 3: The Grey Bound Solution

Drawing from the strengths of previous methods and addressing their shortcomings, we developed the Grey Bound approach. This innovative methodology employs dynamic thresholding to identify and remove pixels with a predominant green component while preserving essential details and minimizing artifacts. By integrating user-configurable thresholds and considerations for grey pixels, we achieved a robust and adaptable solution that delivers superior results across diverse photographic scenarios.
[Here is the code](https://github.com/amansingh2116/chroma_keying/blob/main/code/Approach_3.r)

### Shiny Implementation

To enhance usability and interactivity, we developed a Shiny app using R. This web application framework allows users to dynamically adjust thresholds, fine-tuning the chroma keying process for optimal results. The Shiny implementation adds flexibility and accessibility to our project, catering to novice and experienced users.

To provide users with more flexibility and address corner cases, the final R software allows users to choose between the two approaches for applying chroma keying. [Here is the GitHub repository](https://github.com/amansingh2116/chroma_keying) of the project, and [here is the software](https://amansingh2116.shinyapps.io/akmc/) you can use to apply chroma keying to your images. Experiment with the settings to understand the algorithms better.
