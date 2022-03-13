#' @title Import Metadata for Patents View
#' @description Download metadata tables for the available patent grants and pregrant (applications) tables.
#' Used to construct the urls to download individual files or for multiple files.
#' @param type grant or application (pregrant) table
#' @param dest destination folder
#' @return data.frame
#' @export
#' @importFrom usethis ui_info
#' @importFrom usethis ui_stop
#' @importFrom rvest html_element
#' @importFrom rvest html_table
#' @importFrom rvest read_html
#' @importFrom rvest html_nodes
#' @importFrom rvest html_attr
#' @importFrom dplyr mutate
#' @importFrom dplyr bind_cols
#' @importFrom dplyr filter
#' @importFrom dplyr select
#' @importFrom janitor clean_names
#' @importFrom stringr str_trim
#' @importFrom stringr str_remove_all
#' @importFrom stringr str_detect
#' @importFrom tidyr separate
#' @importFrom tidyr drop_na
#' @importFrom glue glue
#' @importFrom tibble tibble
#' @importFrom readr write_csv
#' @examples \dontrun{applications_meta <- pv_meta(type = "application")
#' grant_meta <- pv_meta(type = "grant")}
pv_meta <- function(type = NULL, dest = NULL) {

 # ui_todo("change last update to data in standard format")
 # ui_todo("split the file sizes into their own columns")
 # ui_todo("add check for new elements or changes in the table")

  if(!is.null(dest)) {
    if (!dir.exists(dest)){
      dir.create(dest)
      ui_info("{ui_value(dest)} dir created")
    } else {
      ui_info("{ui_value(dest)} dir exists")
    }
  }

if(is.null(type)) {
  ui_stop('Im stuck, please use type = "application" or type = "grant"')
}
if(isFALSE(type == "grant" || type == "application" || type == "pregrant")) {

  ui_stop('Im stuck, please use type = "application" or type = "grant"')
}
if(type == "grant" || type == "grants" || type == "granted") {

  raw <- read_html("https://patentsview.org/download/data-download-tables")
}
if(type == "application" || type == "pregrant" || type == "applications" || type == "pregrants") {

  raw <-  read_html("https://patentsview.org/download/pg-download-tables")

}

  tbl <- raw %>%
    html_element("#myTable") %>%
    html_table() %>%
    mutate(zip = str_detect(`Table Name`, "zip")) %>%
    filter(zip == TRUE) %>%
    select(-zip) %>%
    clean_names() %>%
    mutate(number_of_rows = str_remove_all(number_of_rows, ",")) %>%
    mutate(number_of_rows = str_trim(number_of_rows, side = "both")) %>%
    mutate(number_of_rows = str_remove_all(number_of_rows, " ")) %>%
    mutate(number_of_rows = as.numeric(number_of_rows))

  urls <- raw %>%
    html_nodes("#myTable tr :nth-child(1)") %>%
    html_attr("href") %>%
    tibble("url" = .) %>%
    drop_na() %>%
    mutate(zip = str_detect(url, "zip")) %>%
    filter(zip == TRUE) %>%
    select(-zip) %>%
    mutate(zip_name = basename(url)) %>%
    separate(zip_name, into = "file_name", sep = "[.]", extra = "drop", remove = FALSE) %>%
    mutate(download_date = Sys.Date())

  out <- bind_cols(tbl, urls) %>%
    mutate(data_type = glue('{type}')) %>%
    select(data_type, file_name, zip_name, download_date, everything())

  if(is.null(dest)) {

    write_csv(out, glue('readme_{type}.csv'))
    saveRDS(out, glue('readme_{type}.rds'))

  } else {

    write_csv(out, glue('{dest}/{type}_meta.csv'))
    saveRDS(out, glue('{dest}/{type}_meta.rds'))

  }

  out

}
