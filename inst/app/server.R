
server <- function(input, output, session) {
  volumes <- getVolumes()()
  shinyDirChoose(input, "dir", roots = volumes, session = session)

  observeEvent(input$dir, {
    folderPath <- parseDirPath(volumes, input$dir)
    session$sendCustomMessage(type = "dir_selected", message = folderPath)
    if (!is.null(folderPath)) {
      if (length(folderPath) == 1) {addResourcePath("images", folderPath)}
      files <- list.files(folderPath, pattern = "\\.(jpg|jpeg|JPEG|JPG)$", full.names = TRUE)
      if (length(files) > 0) {
        output$image_list <- renderUI({
          lapply(files, function(file) {
            img_src <- file.path("images", basename(file))
            tags$div(
              tags$img(src = img_src, width = "95%", height = "95%",
                       onclick = sprintf("Shiny.setInputValue('image_clicked', '%s')", file)
                       ),
              id = basename(file), class = "imlist", onclick = 'changeBackground(this)',
              style = "margin-bottom: 10px; margin-right: 10%; cursor:pointer;" # Space between images
            )
          })
        })
      }#else{showNotification("Any image in the folder", type = "error")}
    }
  })

  observeEvent(input$image_clicked, {
    output$selectedImage <- renderImage({
      list(src = input$image_clicked, contentType = 'image/png', width = "85%", height = "85%")
    }, deleteFile = FALSE)
  })


  ### ADD TAGS MODAL ##
  tag_name <- reactiveValues();  tag_h <- reactiveValues(l = list())
  observeEvent(input$add_tags, {
    shiny::showModal(
      modalDialog(
        tags$span(textInput("tags_parents", label = "Tags name", placeholder = "e.g species"),
                  actionButton("add_tags_parent", label = "", icon = icon("add"), style = "margin-left:10px; margin-top:15px"),
                  style = "display: flex; align-items: center;"
            ),
        tags$span(selectInput("tag_set", "", choices = c()),
                  textInput("tags_values", label = "Tags value", placeholder = "e.g Kob"),
                  actionButton("add_tags_value", label = "", icon = icon("add"), style = "margin-left:10px; margin-top:15px"),
                  style = "display: flex; align-items: center;"
        ),

        tableOutput("imported_tag"),
        tags$br(),

        title = "Customize tags",
        footer = tagList(
          shinyFilesButton("import_tag", "Import", "Choose tag file", multiple = F, icon = icon("upload")),
          modalButton("Ok")
          #actionButton("save_tag", "Save", icon = icon("save"))
        ),
        fade = FALSE,
        size = "l")
    )
  })

  ## ADD PARENT
  observeEvent(input$add_tags_parent, {
    tags_parents <- input$tags_parents
    if (as.character(tags_parents) != "") {
      tag_name[[tags_parents]] <-  tags_parents
      updateTextInput(session = session, inputId = "tags_parents", value = "")
      updateSelectInput(session = session, inputId = "tag_set", choices = sort(names(tag_name)))

    }else{
      showNotification(sprintf("You cannot add empty name"), type = "error")
    }
  })

  ## ADD VALUE TO PARENT
  observeEvent(input$add_tags_value, {
    tag_val <- reactiveValues()
    tags_value <- input$tags_values

    if (as.character(tags_value) != "") {
      tag_val[[tags_value]] <-  tags_value
      updateTextInput(session = session, inputId = "tags_values", value = "")

      ## Set list
      req(input$tag_set)
      if (length(input$tag_set != 0) > 0 && input$tag_set != 0 && length(names(tag_name) > 1)) {
        tag_set <- input$tag_set

        if (is.null(tag_h$l[[tag_set]])) {
          tag_h$l[[tag_set]] <- names(tag_val)
        }else{
          tag_h$l[[tag_set]] <- unique(c(tag_h$l[[tag_set]], names(tag_val)))
        }
      }
      for (tag in names(tag_val)) {tag_val[[tag]] <- NULL}
    }else{
      showNotification(sprintf("You cannot add empty name"), type = "error")
    }
  })

  ## IMPORT PARENT AND VALUE
  shinyFileChoose(input = input, id = "import_tag", session = session,
                  root = volumes, filetypes = c("txt", "csv"))
  tag_file_path <- reactive(parseFilePaths(roots = volumes, selection = input$import_tag))

  observeEvent(input$import_tag, {
  tag_file_path <- tag_file_path()$datapath
  req(tag_file_path)
  tryCatch({
    tag_data <- read.csv(file = tag_file_path, sep = maimer:::check_sep(tag_file_path))

    if (is.data.frame(tag_data)) {
      output$imported_tag <- renderTable(tag_data)
    }
    tag_colname <- colnames(tag_data)

    if (length(tag_h$l) >= 1 ) {
      for (tag in names(tag_h$l)) {tag_h$l[[tag]] <- NULL}
    }

    for (tcl in tag_colname) {
      tag_h$l[[tcl]] <- tag_data[[tcl]][tag_data[[tcl]] != ""]
    }

  }, error = function(e){showNotification("Cannot read file", type = "error")})

  })


  each_species_sh <- reactiveValues(sh = list())
  observeEvent(input$apply_insertion, {

    if (length(tag_h$l) > 0) {
      js_getsh <- input$js_getsh
      names(js_getsh) <- NULL
      js_getsh <- maimer:::pair_to_list(js_getsh) # from JS

      if (length(each_species_sh$sh) == 0) {
        each_species_sh$sh <- js_getsh
      }else{
        each_species_sh$sh <- maimer:::update_list(each_species_sh$sh, js_getsh)
      }

      js_getsh <- maimer:::deep_list(each_species_sh$sh)
      output$tag_hierarchy <- shinyTree::renderTree({js_getsh})
    }
  })

  observeEvent(input$delete_tag, {
    each_species_sh$sh <- list()
    output$tag_hierarchy <- shinyTree::renderTree({each_species_sh$sh})
  })


  # CUSTOMIZE SUBJECT HIERARCHICAL (SH)
  all_sh <- reactiveValues(l = list());
  observeEvent(input$add_sh, {

    if (length(tag_h$l) > 0) {
      tag_len <- length(tag_h$l)
      for (tgs in 1:tag_len) {
        name <- names(tag_h$l[tgs])
        an_input <- selectInput(inputId = tolower(paste0(name, "_", tgs)),
                                label = name, choices = tag_h$l[[tgs]])
        all_sh$l[[tgs]] <- an_input

      }
      output$sh_set <- renderUI({lapply(all_sh$l, div)})

    } else {
      showNotification("Add tag to insert", type = "error")
    }
  })


}
