## maimer
*'maimer'* is an R package designed for efficient management of image metadata, with a particular focus on camera trap images and videos. It provides tools to edit, extract, and manage metadata seamlessly, streamlining workflows for researchers, conservationists, and anyone working with large collections of camera trap data.

## **Key Features:**
   - ✏️🖥️ Edit metadata fields directly within R through [exiftool](https://exiftool.org/) or using the integrated Graphical User Interface (GUI) without requiring extensive coding knowledge.s
   - 🗂️ Batch editing capabilities to modify metadata for multiple files simultaneously.  
   - 🖼️ Extract metadata, including timestamps, GPS coordinates, camera settings, and more from various image and video formats commonly used in camera traps.  

![Maimer App User Interface](https://github.com/stangandaho/maimer/tree/main/inst/app/app_interface.jpg)


The functions are designed to work well with other R packages such as 
[camtrapR](https://github.com/jniedballa/camtrapR), [overlap](https://github.com/mikemeredith/overlap), etc. for further processing and analysis.


## **Installation:**
You can install 'maimer' directly from GitHub using the following command:

```R
# Install devtools package if you haven't already
if(!'devtools' %in% rownames(installed.packages())){
  install.packages("devtools")
}

# Install maimer from GitHub
devtools::install_github("stangandaho/maimer")
```

Once installed, *'maimer'* can be loaded and used in R scripts or through the GUI. For consistency and understanbaility, the most package function name started by mm_* . Here’s a simple example to get started:

```R
# Load the maimer package
library(maimer)

# Example: Extract metadata from a camera trap image
metadata <- mm_get_metadata("path/to/image.jpg")
head(metadata)

# Example: Edit metadata
mm_edit_metadata("path/to/image.jpg", list(author = "Author Name", location = "Research Site"))

# Launch the GUI
mm_app()
```

## **Meta**
- I welcome [contributions](#) including bug reports.
- License: MIT
- Get [citation information](#) for camtrapdp in R doing `citation("maimer")`.
- Please note that this project is released with a [Contributor Code of Conduct](#). By participating in this project you agree to abide by its terms.