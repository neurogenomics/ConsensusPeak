#' Generate a featureCounts matrix for a peak set
#'
#' \code{feature_counts_matrix()} computes the number of reads from a BAM file
#' that fall within each peak of your peak set.
#'
#' @param peak_file Path to the peak file.
#' @param bam_files Path to the BAM file(s) that the peak file was derived from.
#'
#' @export

feature_counts_matrix <- function(peak_file,
                                  bam_files) {
  # create indexes for each bam file
  for(bam_file in bam_files){
    if (!file.exists(paste0(bam_file, ".bai"))) {
      bam_index <- indexBam(bam_file)
    } else {
      bam_index <- paste0(bam_file, ".bai")
    }
  }

  # Read the peak file and subset desired columns
  peak <-
    utils::read.table(peak_file, header = FALSE)
  peak_df <- peak[, c(4, 1, 2, 3, 6)] # name, chr, start, end, strand

  # Set column names for SAF format
  colnames(peak_df) <- c("GeneID", "Chr", "Start", "End", "Strand")

  # Create a temporary SAF file
  temp_saf_file <- withr::local_tempfile(fileext = ".saf")
  withr::defer(unlink(temp_saf_file)) # delete tempfile when function exits
  utils::write.table(peak_df,
                     temp_saf_file,
                     quote = FALSE,
                     sep = "\t",
                     row.names = FALSE,
                     col.names = TRUE)

  # Paired-end bam files that were filtered for read 1 will still contain
  # paired-end flags. We can use testPairedEndBam() to set isPairedEnd.
  count_matrix <-
    Rsubread::featureCounts(
      files = bam_files,
      annot.ext = temp_saf_file,
      isPairedEnd = Rsamtools::testPairedEndBam(bam_files[1]))

  # Return the counts
  return(count_matrix)
}
