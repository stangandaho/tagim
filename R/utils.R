deep_list <- function(list_item){
  setlist <- list()
  listname <- names(list_item)

  for (n in listname) {
    val <- list_item[[n]]
    listed <- as.list(setNames(rep("", length(val)), val))

    setlist[[n]] <- listed
  }

  return(setlist)
}

