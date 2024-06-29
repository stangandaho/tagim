## Get metadata from images

get_metadata <- function(path){

  if (!file.exists(path)) {
    stop("Path must be a directory path or file path")
  }

  exiftoll_path <- system.file(package = "tagim")
  cmd <- paste(normalizePath(paste0(exiftoll_path, "/exiftool/exiftool.exe")), shQuote(normalizePath(path)))

  metadata_df <- system(cmd, intern = T)

  out_df <- list(); idx <- 0
  for (tgs in metadata_df) {
    idx <- idx + 1
    tgs <- strsplit(tgs, split = ":")
    colname_ <- tgs[[1]][1]; val <- tgs[[1]][2]
    df_ <- data.frame(val); colnames(df_) <- colname_
    out_df[[idx]] <- df_
  }
  rm(idx, tgs, colname_, df_, val)

  tags_df <- do.call(cbind, out_df)

  return(tags_df)

}


#' Extract image metadata
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
#' @return
#'
#' @examples
#'
#' @export
ti_get_metadata <- function(path, recursive = F, save_file = F, file_name = "") {

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
    metadata_df <- do.call(rbind, rbind_list)

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
