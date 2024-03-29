#' Filter BAM file to exclude the second mate in the read pair
#'
#' \code{filter_bam()} filters a paired-end BAM file to exclude the second
#' mate in the read pair. The result is a single-ended BAM file.
#'
#' @param bam_file Path to a paired-end BAM file.
#' @param out_dir Path to where the filtered BAM file will be written.

filter_bam <- function(bam_file,
                       out_dir) {
  norm_out_dir <- normalizePath(out_dir, mustWork = TRUE)
  bam_file <- normalizePath(bam_file)

  index_destination <-
    file.path(norm_out_dir, paste0("read1_", basename(bam_file), ".bai"))

  if (!file.exists(paste0(bam_file, ".bai"))) {
    bam_index <- indexBam(bam_file, destination = index_destination)
  } else {
    bam_index <- paste0(bam_file, ".bai")
  }

  bam_index <- normalizePath(bam_index)

  # define parameters for filtering first mate reads
  param <- ScanBamParam(what = scanBamWhat(),
                        flag = scanBamFlag(isFirstMateRead = TRUE))

  destination <-
    file.path(norm_out_dir, paste0("read1_", basename(bam_file)))
  filterBam(file = bam_file,
            destination = destination,
            index = bam_index,
            param = param)

  return(destination)
}
