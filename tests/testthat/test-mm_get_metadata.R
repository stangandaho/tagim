#C:\Users\ganda\AppData\Local\R\win-library\4.3\maimer
test_that("Get image metadata", {
  # Define the URL of the image to be downloaded
  image_url <- "https://cdn.britannica.com/02/162502-050-FEEA94DE/Vulture.jpg"
  # Define the path to save the downloaded image
  image_dir <- "D:/maimertest"
  image_path <- file.path(image_dir, "image.jpg")

  if (!file.exists(image_path)) {
    # Download the image from the internet
    download.file(url = image_url, destfile = image_path, mode = "wb")
  }

  metadata_df <- mm_get_metadata(path = image_path)
  testthat::expect_true(is.data.frame(metadata_df))

  # Test for folder path
  ## Creat folder to copy image into.
  dir.create(path = file.path(image_dir, "unitest/justme"), recursive = T)
  ## Repeat image copy
  for (i in 1:3) {
    file.copy(from = image_path, to = paste0(image_dir, "/unitest/justme/", i, basename(image_path)))
  }

  metadata_df2 <- mm_get_metadata(path = paste0(image_dir, "/unitest"), recursive = T)
  testthat::expect_true(nrow(metadata_df2) == 3)

  # no recursive, default
  testthat::expect_error(mm_get_metadata(path = paste0(image_dir, "/unitest"), recursive = F))

  # wrong file name
  testthat::expect_error(mm_get_metadata(path = image_path, save_file = T,
                                         file_name = "filename"))

  # wrong file name
  testthat::expect_error(maimer::mm_get_metadata(path = "no/file/path/image.jpeg"))
  testthat::expect_error(maimer::mm_get_metadata(path = image_url))

  mm_get_metadata(path = image_path, save_file = T)
  testthat::expect_true(file.exists(paste0(image_dir, "/metadata.csv")))
  unlink(file.path(image_dir, "metadata.csv"))

  mm_get_metadata(path = image_path, save_file = T, file_name = "mymetadata.csv")
  testthat::expect_true(file.exists(paste0(image_dir, "/mymetadata.csv")))

  unlink(file.path(image_dir, "mymetadata.csv"))
  unlink(paste0(image_path, "/unitest"), recursive = T)
  unlink(image_path)

})
