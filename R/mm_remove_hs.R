#' Remove Specific or All HierarchicalSubject Values from Image Metadata
#'
#'The mm_remove_hs function removes a specific hierarchy from the
#'`Hierarchical Subject` field in an image's metadata, or it removes the entire
#'field if no specific hierarchy is provided. It uses exiftool
#'to manipulate the metadata and ensure that only the desired changes are applied.
#'
#' @inheritParams mm_get_hs
#' @param hierarchy A named character vector, e.g c("Species" = "Vulture") specifying the hierarchy to be removed.
#' If NULL, the entire `Hierarchical Subject` field is removed.
#'
#' @return message indicating image updated
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
#' no_hs <- mm_get_hs(path = temp_image_path)
#' mm_create_hs(temp_image_path, c("A" = "AB"))
#' mm_remove_hs(temp_image_path, c("A" = "AB"))
#'
#' @export
#'
mm_remove_hs <- function(path, hierarchy = NULL) {

  exiftool_path <- paste0(base::system.file(package = "maimer"), "/app/exiftool.exe")
  cmd_remove_all <- sprintf('%s -HierarchicalSubject= %s',
                            exiftool_path, shQuote(normalizePath(path)))

  if (is.null(hierarchy)) {
    response <- system(cmd_remove_all, intern = TRUE)
  }

  current_hs <- mm_get_hs(path = path)
  hierarchy <- paste0(names(hierarchy), "|", hierarchy)

  if (is.character(hierarchy) & !hierarchy %in% current_hs) {
    return(message(sprintf("Hierarchy %s does not exist. No change applied to %s" ,
                           hierarchy, basename(path = path))))
  }

  if (hierarchy %in% current_hs) {
    updated_hs <- current_hs[current_hs != hierarchy]
    #system(cmd_remove_all, intern = TRUE)
    if (length(updated_hs) == 0) {
      updated_hs <- ""
    }

    cmd_update <- sprintf('%s -HierarchicalSubject=%s %s',
                          exiftool_path, updated_hs, shQuote(normalizePath(path)))
    response <- system(cmd_update, intern = TRUE)
  }

  return(message(trimws(response)))
}
