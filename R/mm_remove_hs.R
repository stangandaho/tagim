#' Remove Specific or All HierarchicalSubject Values from Image Metadata
#'
#'The ti_remove_hs function removes a specific hierarchy from the
#'`Hierarchical Subject` field in an image's metadata, or it removes the entire
#'field if no specific hierarchy is provided. It uses exiftool
#'to manipulate the metadata and ensure that only the desired changes are applied.
#'
#' @inheritParams mm_get_hs
#' @param hierarchy A named character vector, e.g c("Species" = "Vulture") specifying the hierarchy to be removed.
#' If NULL, the entire `Hierarchical Subject` field is removed.
#'
#' @return message indicating image updated
#' @export
#'
mm_remove_hs <- function(path, hierarchy = NULL) {

  exiftool_path <- paste0(system.file(package = "tagim"), "/exiftool/exiftool.exe")
  cmd_remove_all <- sprintf('%s -HierarchicalSubject= %s',
                            exiftool_path, shQuote(normalizePath(path)))

  current_hs <- ti_get_hs(path = path)
  hierarchy <- paste0(names(hierarchy), "|", hierarchy)

  if (is.character(hierarchy) & !hierarchy %in% current_hs) {
    return(message(sprintf("Hierarchy %s does not exist. No change applied to %s" ,
                           hierarchy, basename(path = path))))
  }

  if (hierarchy %in% current_hs) {
    updated_hs <- current_hs[current_hs != hierarchy]
    system(cmd_remove_all, intern = TRUE)

    cmd_update <- sprintf('%s -HierarchicalSubject=%s %s',
                          exiftool_path, updated_hs, shQuote(normalizePath(path)))
    response <- system(cmd_update, intern = TRUE)
  }

  if (is.null(hierarchy)) {
    response <- system(cmd_remove_all, intern = TRUE)
  }

  return(message(trimws(response)))
}
