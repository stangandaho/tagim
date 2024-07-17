
test_that("Get hierarchical subject in metadata", {

  # Define the URL of the image to be downloaded
  image_url <- "https://cdn.britannica.com/02/162502-050-FEEA94DE/Vulture.jpg"
  # Define the path to save the downloaded image
  image_dir <- "D:/maimertest"
  image_path <- file.path(image_dir, "image.jpg")


  if (file.exists(image_path)) {
    # Download the image from the internet
    unlink(image_path)
  }
  download.file(url = image_url, destfile = image_path, mode = "wb")

  null_output <- mm_get_hs(path = image_path)
  testthat::expect_equal(null_output, NULL)

  mm_create_hs(path = image_path, value = c("Species" = "Vulture"))
  sh_out <- mm_get_hs(path = image_path)
  testthat::expect_equal(sh_out, "Species|Vulture")

  testthat::expect_error(mm_get_hs())
  unlink(image_path)
  unlink(paste0(image_path, "_original"))
})
