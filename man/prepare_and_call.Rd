% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepare_and_call.R
\name{prepare_and_call}
\alias{prepare_and_call}
\title{Prepare files for peak calling and call peaks}
\usage{
prepare_and_call(treat_files, control_files = NULL, is_paired, out_dir, ...)
}
\arguments{
\item{treat_files}{Character vector containing paths to the treatment BAM
files.}

\item{control_files}{Character vector containing paths to the control BAM
files. The default is NULL}

\item{is_paired}{Logical, specifying whether or not the BAM files are
paired-end. The default is `FALSE`.}

\item{out_dir}{Character specifying the path at which the results directory
will be created. By default, the results directories are created in
tempdir().}
}
\description{
\code{prepare_and_call} prepares the BAM files into a list and then passes
this list to the macs_call_peak() function. The output is a list comprising
file paths to the resulting peak files.
}
\keyword{internal}
