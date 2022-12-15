library(data.table)
library(readxl)
library(officer)
library(rmarkdown)
library(officedown)
library(flextable)
library(ggplot2)
library(shiny)


Sys.setlocale("LC_TIME", "Spanish")

knitr::opts_chunk$set(echo = FALSE,message = FALSE, warning = FALSE)

# flextable  ----
use_df_printer()
set_flextable_defaults(
  border.color = "gray",
  fonts_ignore=TRUE,
  padding.bottom = 3,   padding.top = 3,
  padding.left = 4,  padding.right = 4,
  post_process_html = function(x){
    # theme_booktabs(x)  |>
    theme_vanilla(x) |>
      set_table_properties(layout = "autofit") |>
      autofit() |>
      align(align="center",part = "header") |>
      bold(part = "header")  |> 
      fontsize(size = 10, part = "header")|> 
      fontsize(size = 10, part = "body")
  },
  post_process_pdf = function(x){
    # theme_booktabs(x)  |>
    theme_vanilla(x) |>
      set_table_properties(layout = "autofit") |>
      autofit() |>
      align(align="center",part = "header") |>
      bold(part = "header")  |>
      fontsize(size = 9, part = "header")|> 
      fontsize(size = 9, part = "body")
  },
  post_process_docx = function(x){
    theme_vanilla(x) |>
      set_table_properties(layout = "autofit") |>
      autofit() |>
      align(align="center",part = "header") |>
      bold(part = "header")  |>
      fontsize(size = 10, part = "header")|> 
      fontsize(size = 9, part = "body")
  }
) 

