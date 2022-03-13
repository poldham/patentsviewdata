#' @title Import PatentsView Data Tables
#' @description Import a PatentsView data table from \code{pv_download()}.
#' @param path path to file to import
#' @param meta_path path to metadata file to validate nrows after import
#' @param save_as file type to save as: "rds", "rda", "qs", "csv", "parquet"
#' @param dest destination for save_as, defaults to working directory
#' @details The function uses the vroom package to import tab separated files
#'   downloaded from the PatentsView data download site.
#' @return data.frame
#' @export
#' @importFrom tools file_path_sans_ext
#' @importFrom dplyr filter
#' @importFrom vroom vroom
#' @importFrom usethis ui_done
#' @importFrom usethis ui_value
#' @importFrom usethis ui_stop
#' @importFrom usethis ui_info
#' @importFrom qs qsave
#' @importFrom arrow write_parquet
#' @importFrom glue glue
#' @importFrom readr read_csv
#' @importFrom stringr str_replace_all
#' @importFrom tools file_path_sans_ext
#' @importFrom utils zip
#' @examples \dontrun{applications <- pv_import("grants/application.tsv.zip")}
pv_import <- function(path = NULL, meta_path = NULL, save_as = NULL, dest = NULL) {

  # get the basename of the file from the path
  # use twice to handle tsv. and zip

  fname <- file_path_sans_ext(path) %>%
    file_path_sans_ext() %>%
    basename()

  # identify the metadata table and import
  # import the file with vroom specmeta_path = "/Users/pauloldham/Documents/patentsview2021/grant/readme_grant.rds", dest = "inst/", save_as = ".qs")
#ifying the delim and noting that the
  # default quoting is the same as that for the patensview data as "\""
#
if(!is.null(meta_path)) {

  meta_nrow <- readRDS(meta_path) %>%
    filter(file_name == fname)

}

  out <- vroom(path, delim = "\t", show_col_types = FALSE)

  # validate that the imported file has the same length as the metadata
  # stop with informative message if not
  # Need to handle cases where the metapath is NULL

  if (is.null(dest)) {

    dest <- getwd()

    }

# for cases where there is meta data provide messages
# if not do nothing

if(!is.null(meta_path)) {

  if(nrow(out) == meta_nrow$number_of_rows) {

    ui_done("Number of Rows Matches the expected {ui_value({meta_nrow$number_of_rows})} for {ui_value({fname})} in the metadata file file")

  } else {

    ui_info("{ui_value({nrow(out)})} number of rows does not match expected with vroom. Try the PatentsView code examples at
    https://github.com/PatentsView/PatentsView-Code-Snippets or datatable::fread?")

  }


} else {

  out

}


# Save file options -------------------------------------------------------

  if(!is.null(save_as)) {

    # anticipate user using stop in save_as

     save_as <- str_replace_all(save_as, "[.]", "")

      switch(
        save_as,
        rds = saveRDS(out, file = glue('{dest}/{fname}.rds')),
        qs = qsave(out, file = glue('{dest}/{fname}.qs')),
        csv = write_csv(out, file = glue('{dest}/{fname}.csv')),
        rda = save(out, file = glue('{dest}/{fname}.rda')),
        parquet = write_parquet(out, sink = glue('{dest}/{fname}.parquet'))

      )

      ui_done("saved data to {ui_value(glue('{dest}/{fname}.{save_as}'))}")

  } else {

    out
  }
}
