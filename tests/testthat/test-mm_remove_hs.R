
test_that("Remove hierarchical subject in metadata", {
  # Define the URL of the image to be downloaded
  image_url <- "https://cdn.britannica.com/02/162502-050-FEEA94DE/Vulture.jpg"
  # Define the path to save the downloaded image
  image_dir <- "D:/maimertest"
  image_path <- file.path(image_dir, "image.jpg")


  if (!file.exists(image_path)) {
    # Download the image from the internet
    download.file(url = image_url, destfile = image_path, mode = "wb")
  }

  mm_create_hs(path = image_path, value = c("Species" = "Vulture"))
  maimer::mm_remove_hs(path = image_path, hierarchy = c("Species" = "Vulture"))
  null_output <- maimer::mm_get_hs(image_path)
  testthat::expect_equal(null_output, NULL)

  # To remove all HS
  mm_create_hs(path = image_path, value = c("Species" = "Vulture", "Sex" = "Female"))
  maimer::mm_remove_hs(path = image_path, hierarchy = NULL)
  null_output2 <- maimer::mm_get_hs(image_path)
  testthat::expect_equal(null_output2, NULL)

  # Error for unexisting HS
  testthat::expect_equal(maimer::mm_remove_hs(path = image_path, c("Not" = "Exist")), NULL)

  unlink(image_path)
  unlink(paste0(image_path, "_original"))

})


