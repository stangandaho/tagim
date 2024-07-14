#' Create or Add Hierarchical Subject Values in Image Metadata
#'
#' @inheritParams mm_get_hs
#' @param value named character vector specifying the new hierarchical subjects to add.
#' Each value must have a parent specified as the name, e.g c("Species" = "Vulture").
#'
#' @inheritParams mm_remove_hs
#' @export
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
#' # Get Hierarchical Subject from the image - Before use ti_create_hs()
#' ti_get_hs(path = temp_image_path) #==> NULL
#'
#' ti_create_hs(path = temp_image_path, value = c("Species" = "Vulture"))
#'
#' # Get Hierarchical Subject from the image - Before use ti_create_hs()
#' ti_get_hs(path = temp_image_path) #==> "Species|Vulture"
#'
mm_create_hs <- function(path, value = c()) {

  exiftoll_path <- system.file(package = "tagim")
  all_have_name <- unlist(lapply(names(value), FUN = function(x){is.null(x) | x == ""}))
  if (any(all_have_name)) {
    stop(sprintf("Hierarchy must have a parent. Give a name to %s. For example, c(\"Parent\" = \"%s\") for %s",
                 paste(value[all_have_name], collapse = ", "), value[all_have_name][1L], value[all_have_name][1L][1L]))
  }

  if (!is.null(ti_get_hs(path = path))) {
    existing <- paste0(" -HierarchicalSubject=", ti_get_hs(path = path))
  }else{existing <- NULL}

  if (length(value)> 1) {
    if (!is.null(existing)) {
      parse_value <- paste(unique(c(paste0(" -HierarchicalSubject=", names(value), "|", value),
                                    existing)), collapse = "")
    }else{
      parse_value <- paste(unique(c(paste0(" -HierarchicalSubject=", names(value), "|", value))), collapse = "")
    }
  }else{

    if (!is.null(existing)) {
      parse_value <- paste0(unique(c(paste0(" -HierarchicalSubject=", names(value), "|", value), existing)))
    }else{
      parse_value <- paste0(unique(c(paste0(" -HierarchicalSubject=", names(value), "|", value))))
    }
  }

  cmd <- paste0(normalizePath(paste0(exiftoll_path, "/exiftool/exiftool.exe ")),
                parse_value, " ",
               shQuote(normalizePath(path)))

  response <- system(cmd, intern = TRUE)
  return(message(trimws(response)))

}
