#' Prepare a Named List of File Paths for Replicates and Controls
#'
#' This function checks the validity of user-specified file paths for replicates
#' and controls and constructs a named list. The function ensures that the file
#' paths are valid and normalises them.
#'
#' @param treat_files Character vector of paths to the treatment BAM files.
#' @param control_files Character vector of paths to the control BAM files.
#' @returns A named list of normalised file paths for the provided replicates
#' and controls. The list will contain elements named "treatment_file_1",
#' "treatment_file_2", "control_file_1", and "control_file_2", corresponding
#' to the provided file paths. The list is filtered to exclude any that are
#' NULL.
#'
#' @keywords internal

prepare_named_list <- function(treat_files,
                               control_files = NULL) {
  if(!is.null(control_files) && length(treat_files) != length(control_files)){
    stopper(
      "Either a control is not used or all treatment files must have an
      associated control"
      )
  }

  file_list <- list()

  # Process treatment files
  for (i in seq_along(treat_files)) {
    name <- paste("treatment_file", i, sep = "_")
    file_list[[name]] <- treat_files[i]
  }

  # Process control files
  if (!is.null(control_files)) {
    for (i in seq_along(control_files)) {
      name <- paste("control_file", i, sep = "_")
      file_list[[name]] <- control_files[i]
    }
  }

  # Remove NULL entries in list
  file_list <- Filter(Negate(is.null), file_list)

  # Check validity and normalise each file path
  file_list <- lapply(file_list, function(x) {
    if (!is.character(x) || length(x) != 1) {
      stopper("Each file path must be a single character string.")
    }
    # Ensure path to file and not path to directory
    if (!file.exists(x) || dir.exists(x)) {
      stopper("File does not exist: ", x)
    }

    normalizePath(x)
  })

  return(file_list)
}
