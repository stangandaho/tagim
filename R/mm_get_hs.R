#' Retrieve Hierarchical Subject Values from Image Metadata
#'
#'The function retrieves the values from the `Hierarchical Subject`
#' field of an image's metadata. It uses exiftool to read the metadata and processes
#' the results to extract and return the unique hierarchical subjects.
#'
#' @param path A character vector specifying the full path of the image file.
#'
#' @return A character vector of unique hierarchical subjects if they exist, otherwise NULL.
#'
#' @examples
#'
#' # Define the URL of the image to be downloaded
#' image_url <- "https://cdn.britannica.com/02/162502-050-FEEA94DE/Vulture.jpg"
#'
#' # Define the path to save the downloaded image
#' temp_image_path <- file.path(tempdir(), "image.jpg")
#'
#' # Download the image from the internet
#' download.file(url = image_url, destfile = temp_image_path, mode = "wb")
#'
#' # Get Hierarchical Subject from the image
#' ti_get_hs(path = temp_image_path)
#'
#' @export
#'

mm_get_hs <- function(path){

  exiftool_path <- paste0(system.file(package = "tagim"), "/exiftool/exiftool.exe")
  cmd_read <- sprintf('%s -HierarchicalSubject %s',
                      exiftool_path, shQuote(normalizePath(path)))
  current_values <- system(cmd_read, intern = TRUE)
  hierar_exist <- "Hierarchical Subject" %in% colnames(get_metadata(path))

  if (hierar_exist) {
    current_subjects <- unlist(lapply(current_values, function(line) {
      linesplit <- strsplit(sub(".*: ", "", line), split = ",")
      linesplit <- unlist(linesplit)
      return(unique(trimws(linesplit)))
    }))
  }else{
    current_subjects <- NULL
  }

  return(current_subjects)
}

