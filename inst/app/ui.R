


ui <- dashboardPage(
  header = bs4Dash::dashboardHeader(
    sidebarIcon = icon("grip"), fixed = T, compact = T,
    shiny::tagList(
      shinyDirButton("dir", "Select Folder", "Upload", icon = icon("folder"),
                     style = "margin-left: 20%;"),
      shiny::actionButton("add_tags", "Add tag", icon = icon("add"),
                          style = "margin-left: 20%;"))
    ),

  bs4Dash::dashboardSidebar(
    elevation = 3, collapsed = FALSE, minified = F,
    div(
      uiOutput("image_list"),
      style = "overflow-y: scroll; max-height: 95vh" # Allow scrolling
    )
  ),

  bs4Dash::dashboardBody(

    includeCSS("www/style.css"),
    shiny::includeScript("www/getSh.js"),
    shiny::includeScript("www/keyboard_event.js"),

    fluidPage(
      fluidRow(
        column(width = 8,
               imageOutput("selectedImage", width = "100%", height = "100%")),
        column(width = 4,
               actionButton("add_sh", label = "Insert tag", icon = icon("file-pen")),
               uiOutput("sh_set"),
               tagList(actionButton("apply_insertion", "Apply"),
                       actionButton("delete_tag", "Delete", icon = icon("trash"))),
               tags$br(), tags$br(),
               # Tree
               shinyTree::shinyTree("tag_hierarchy", contextmenu = FALSE, dragAndDrop = FALSE,
                         search = FALSE, unique = TRUE, sort = FALSE))
      )
    )
    ),

  help = NULL
)
