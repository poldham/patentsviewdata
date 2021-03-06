#' @title Download PatentsView Data Files
#' @description Download one or more PatentsView raw files using urls from a meta data table
#' created by \code{pv_meta()}
#' @param url url of the file to download
#' @param dest destination for the files
#' @param timeout time window for download
#' @importFrom usethis ui_info
#' @importFrom usethis ui_value
#' @importFrom glue glue
#' @importFrom purrr safely
#' @importFrom purrr walk2
#' @importFrom purrr walk
#' @return
#' @export
#' @examples \dontrun{pv_download(grant_meta$url[1], dest = "grants", timeout = 600)}
pv_download <- function(url = NULL, dest = NULL, timeout = 600) {


  if(!is.null(dest)) {
    if (!dir.exists(dest)){
      dir.create(dest)
      ui_info("{ui_value(dest)} dir created")
    } else {
      ui_info("{ui_value(dest)} dir exists")
    }
  }

  bname <- basename(url)
  dest <- glue('{dest}/{bname}')

  # safely code kindly provided by [Matt
  # Herman](https://community.rstudio.com/t/download-multiple-files-using-download-file-function-while-skipping-broken-links-with-walk2/51222)
  # in answer to a question on the RStudio community.

  # create a variable sleep option
  options(timeout = timeout)

  safe_download <- safely(~ download.file(.x , .y, mode = "auto"))

  if (!is.null(dest)) {

    walk2(url, dest, safe_download)

  } else {

    walk(url, safe_download)

  }


}
