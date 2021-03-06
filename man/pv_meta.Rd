% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pv_meta.R
\name{pv_meta}
\alias{pv_meta}
\title{Import Metadata for Patents View}
\usage{
pv_meta(type = NULL, dest = NULL)
}
\arguments{
\item{type}{grant or application (pregrant) table}

\item{dest}{destination folder}
}
\value{
data.frame
}
\description{
Download metadata tables for the available patent grants and pregrant (applications) tables.
Used to construct the urls to download individual files or for multiple files.
}
\examples{
\dontrun{applications_meta <- pv_meta(type = "application")
grant_meta <- pv_meta(type = "grant")}
}
