#' Run App
#'
#' Launch maimer GUI for image/video management
#' @return
#'
#' @export
#'
#'
mm_app <- function() {

  app_dir <- system.file("app", package = "maimer")
  shiny::runApp(appDir = app_dir)
}




