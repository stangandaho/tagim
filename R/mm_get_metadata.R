## Get metadata from images

get_metadata <- function(path){

  if (!file.exists(path)) {
    stop("Path must be a directory path or file path")
  }

  exiftool_path <- system.file(package = "tagim")
  cmd <- paste(normalizePath(paste0(exiftool_path, "/exiftool/exiftool.exe")), shQuote(normalizePath(path)))

  metadata_df <- system(cmd, intern = T)

  out_df <- list(); idx <- 0
  for (tgs in metadata_df) {
    idx <- idx + 1
    tgs <- strsplit(tgs, split = ":")
    colname_ <- tgs[[1]][1]; val <- tgs[[1]][2]
    df_ <- data.frame(val); colnames(df_) <- trimws(colname_)
    out_df[[idx]] <- df_
  }
  rm(idx, tgs, colname_, df_, val)

  tags_df <- do.call(cbind, out_df)

  return(tags_df)

}


#' Extract image metadata
#'
#' The function extracts metadata from image files located at a
#' specified path. The function can handle both individual image files and
#' directories containing multiple images. It uses the exiftool utility to read
#' the metadata and can optionally save the extracted metadata to a CSV file.
#'
#' @param path a character vector of full path names. Either a directory path or file path. If the `path` specified is a
#' directory, the function looks for all image (.jpeg/JPEG, jpg/JPG) inside and extract
#' the tags and bind in a single data.frame.
#' @param recursive logical. Should the listing recurse into directories? It is applied if
#' `path` is directory.
#' @param save_file logical. Extracted metadata should be write on disk?
#' @param file_name a character specifying the name of file to save in csv format.
#' If left empty and `save_file` is TRUE, the default name is metadata.csv. Note that
#' the file is not saved if `save_file` is FALSE, even if the file name is provided.
#'
#' @return data.frame
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
#' # Extract metadata from the downloaded image
#' metadata <- ti_get_metadata(path = temp_image_path)
#'
#' # Extract metadata from all images in a directory (non-recursive)
#' metadata_dir <- ti_get_metadata(path = tempdir(), recursive = FALSE)
#'
#' @export
mm_get_metadata <- function(path, recursive = FALSE,
                            save_file = FALSE,
                            file_name = "") {

  if (dir.exists(path)) {
    img_in_path <- list.files(path = path, pattern = "\\.(jpe?g|JPE?G)$",
                              full.names = T, recursive = recursive)
    path <- img_in_path[1]
    rbind_list <- list()
    for (img in seq_along(img_in_path)) {
      message(
        paste0("Processing image ", basename(img_in_path[[img]]),
              " (", img, " of ", length(img_in_path), ")")
      )
      rbind_list[[img]] <- get_metadata(path = img_in_path[[img]])
    }
    metadata_df <- ti_stack_df(rbind_list)

  } else if (file.exists(path)) {
    metadata_df <- get_metadata(path = path)
  }


  if (save_file) {
    if (file_name == "") {
      file_name <- paste0(dirname(path), "/metadata.csv")
    }else if( grepl(".csv$", file_name) ){
      file_name <- paste0(getwd(), "/", file_name)
    }else{
      stop("Specify a correct file name (ended by .csv)")
    }

    write.csv(x = metadata_df, file = file_name)
    message(paste("File saved to ", file_name))
  }

  return(metadata_df)
}
