#' Multiple replicate peak calling with ChIP-R
#'
#' \code{multiple_replicates_chipr()} is a wrapper of the Python package ChIP-R.
#' The function calls peaks with MACSr and then filters these peaks to generate
#' a consensus set using the Python package ChIP-R.
#'
#' @inheritParams idr_analysis
#' @param subdir_name The name of the subdirectory that the output files will be
#' placed.
#' @param call_peaks Set to TRUE if you want to call peaks (in which case you
#' will have supplied BAM files). Set to TRUE if treat_files is a vector of
#' paths to narrowPeak or broadPeak files.
#' @inheritParams run_chipr
#' @inheritDotParams MACSr::callpeak -tfile -cfile -outdir -name -format -log
#' -tempdir
#'
#' @returns A list containing a summary of the ChIP-r along with the path to the
#' output files.
#'
#' @examples
#' \dontrun{
#' input1 <- testthat::test_path("testdata", "r1_test_creb.bam")
#' input2 <- testthat::test_path("testdata", "r2_test_creb.bam")
#' input3 <- testthat::test_path("testdata", "r3_test_creb.bam")
#'
#' multiple_replicates_chipr(treat_files = c(input1, input2, input3),
#'                           out_dir = tempdir()
#'                           )
#'                           }
#'
#' @export
multiple_replicates_chipr <- function(treat_files,
                                      control_files = NULL,
                                      is_paired = FALSE,
                                      out_dir,
                                      subdir_name = "chipr_analysis",
                                      call_peaks = TRUE,
                                      minentries = 2,
                                      rankmethod = "pvalue",
                                      duphandling = "average",
                                      fragment = FALSE,
                                      seed = 0.5,
                                      alpha = 0.05,
                                      size = 20,
                                      ...) {
  final_out_dir <- create_or_use_dir(out_dir, subdir_name)
  if(call_peaks){
    peak_list <-
      prepare_and_call(
        treat_files = treat_files,
        control_files = control_files,
        is_paired = is_paired,
        out_dir = final_out_dir,
        ...
      ) # outputs a named list of peak files
  } else {
    peak_list <- as.list(treat_files)
  }

  peak_file_paths <- unlist(peak_list)
  result_chipr <- run_chipr(peak_files = peak_file_paths,
                            out_name = file.path(final_out_dir, "out"),
                            minentries = minentries,
                            rankmethod = rankmethod,
                            duphandling = duphandling,
                            fragment = fragment,
                            seed = seed,
                            alpha = alpha,
                            size = size)

  messager("All output files are stored at ", final_out_dir)
  return(
    list(
      "Results" = result_chipr,
      "Output path" = final_out_dir
    )
  )
}
