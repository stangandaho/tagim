
test_that("Create hierarchical subject in metadata", {
  # Define the URL of the image to be downloaded
  image_url <- "https://cdn.britannica.com/02/162502-050-FEEA94DE/Vulture.jpg"
  # Define the path to save the downloaded image
  image_dir <- "D:/maimertest"
  image_path <- file.path(image_dir, "image.jpg")


  if (!file.exists(image_path)) {
    # Download the image from the internet
    download.file(url = image_url, destfile = image_path, mode = "wb")
  }

  null_output <- mm_create_hs(path = image_path, value = c("Species" = "Vulture"))
  testthat::expect_equal(null_output, NULL)

  # Complet HS to existing
  null_output2 <- mm_create_hs(path = image_path, value = c("Species" = "Vulture", "Sex" = "Female"))
  testthat::expect_equal(null_output2, NULL)

  # Wrong hirarchical subject format
  testthat::expect_error(mm_create_hs(path = image_path))
  testthat::expect_error(mm_create_hs(path = image_path, value = c("Species")))
  testthat::expect_error(mm_create_hs(path = image_path, value = c("Species" = "BBB", "Sex")))

  unlink(image_path)
  unlink(paste0(image_path, "_original"))

})


