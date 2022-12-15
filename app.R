source("setup.R")
source("global.R")
render_report <- function(input, output, params) {
  quarto::quarto_render(input,output_format = "docx",output_file = output,execute_params = params)
}
shinyApp(
  ui = fluidPage(
    titlePanel("Control Mensual Piezómetros - Minera Zaldívar SpA"),
    # selectizeInput(inputId="DATE",choices = CHOICES,label=""),
    dateInput(inputId="DATE",value=LAST_DATE,min=min(VALID_DATES),max=max(VALID_DATES),format="yyyy-mm-dd",label="",width = "150px"),
    # actionButton( "render", "Render report"),
    downloadButton("report", "Render report")
  ),
  server = function(input, output) {
   
    
    
    output$report <- downloadHandler(
      # For PDF output, change this to "report.pdf"
      
      filename = "report.docx",
      content = function(file) {
        params <- list(DATE = format(input$DATE,format="%Y-%m"))
        id <- showNotification(
          "Rendering report...", 
          duration = NULL, 
          closeButton = FALSE
        )
        on.exit(removeNotification(id), add = TRUE)
        # report_path  <- tempfile(fileext = ".qmd")
        # file.copy("report.qmd", report_path, overwrite = TRUE)
        quarto::quarto_render("report.qmd",execute_params = params)
        

      }
    )
}
)
