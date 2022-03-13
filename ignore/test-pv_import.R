#test_that("multiplication works", {
#  expect_equal(2 * 2, 4)
#})

# NOTE THE RDA FILES WERE RDS ORIGININALLY
# HOWEVER THE RDS FILES ARE LONKED OUTSIDE THE PAKAGE

#readme_grant <- read_csv("~/Documents/patentsview2021/grant/readme_grant.csv")
"/Users/pauloldham/Documents/patentsview2021/grant/readme_grant.rds"
"/Users/pauloldham/Documents/patentsview2021/grant/application.tsv.zip"

pv_import(path = "/Users/pauloldham/Documents/patentsview2021/grant/application.tsv.zip", meta_path = "/Users/pauloldham/Documents/patentsview2021/grant/readme_grant.rda")

# test stop if nrow does not match and forces stop

pv_import(path = "/Users/pauloldham/Documents/patentsview2021/grant/application.tsv.zip", meta_path = "inst/readme_application.rda")

# handle save cases (dest cannot be null at the moment)

# qs case
pv_import(path = "/Users/pauloldham/Documents/patentsview2021/grant/application.tsv.zip",
          meta_path = "/Users/pauloldham/Documents/patentsview2021/grant/readme_grant.rda", dest = "inst/", save_as = "qs")

# rds case

pv_import(path = "/Users/pauloldham/Documents/patentsview2021/grant/application.tsv.zip",
          meta_path = "/Users/pauloldham/Documents/patentsview2021/grant/readme_grant.rda", dest = "inst/", save_as = "rds")

# rda case

pv_import(path = "/Users/pauloldham/Documents/patentsview2021/grant/application.tsv.zip",
          meta_path = "/Users/pauloldham/Documents/patentsview2021/grant/readme_grant.rda", dest = "inst/", save_as = "rda")

# csv case

pv_import(path = "/Users/pauloldham/Documents/patentsview2021/grant/application.tsv.zip",
          meta_path = "/Users/pauloldham/Documents/patentsview2021/grant/readme_grant.rda", dest = "inst/", save_as = "csv")
# throws a warning message on parsing issues but difficult to see them and whether they are in fact issues.

# write with dest as null works to write to the working directory
pv_import(path = "/Users/pauloldham/Documents/patentsview2021/grant/application.tsv.zip",
          meta_path = "/Users/pauloldham/Documents/patentsview2021/grant/readme_grant.rda", dest = NULL, save_as = "qs")


# Try parquet

pv_import(path = "/Users/pauloldham/Documents/patentsview2021/grant/application.tsv.zip",
          meta_path = "/Users/pauloldham/Documents/patentsview2021/grant/readme_grant.rda", dest = "inst/", save_as = "parquet")

# Ensure that cases with full stops are handles by removing the stop

pv_import(path = "/Users/pauloldham/Documents/patentsview2021/grant/application.tsv.zip",
          meta_path = "/Users/pauloldham/Documents/patentsview2021/grant/readme_grant.rda", dest = "inst/", save_as = ".qs")
