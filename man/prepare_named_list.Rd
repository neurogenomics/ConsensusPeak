% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepare_named_list.R
\name{prepare_named_list}
\alias{prepare_named_list}
\title{Prepare a Named List of File Paths for Replicates and Controls}
\usage{
prepare_named_list(treat_files, control_files = NULL)
}
\arguments{
\item{treat_files}{Character vector of paths to the treatment BAM files.}

\item{control_files}{Character vector of paths to the control BAM files.}
}
\value{
A named list of normalised file paths for the provided replicates
and controls. The list will contain elements named "treatment_file_1",
"treatment_file_2", "control_file_1", and "control_file_2", corresponding
to the provided file paths. The list is filtered to exclude any that are
NULL.
}
\description{
This function checks the validity of user-specified file paths for replicates
and controls and constructs a named list. The function ensures that the file
paths are valid and normalises them.
}
\keyword{internal}
