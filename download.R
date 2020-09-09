scratch <- "/pine/scr/m/i/milove"

# see https://gist.github.com/mikelove/f539631f9e187a8931d34779436a1c01 for accession2url() definition

source("https://gist.githubusercontent.com/mikelove/f539631f9e187a8931d34779436a1c01/raw/6e6633aa5123358b70390ab738be1eef03a3df31/accession2url.R")

for (i in 1:nrow(x)) {
  print(paste("---",i,"---"))
  run <- x$Run[i]
  for (read in 1:2) {
    file <- paste0(run,"_",read,".fastq.gz")
    url <- file.path(accession2url(run), file)
    dest <- file.path(scratch, file)
    if (!file.exists(dest))
      download.file(url, dest)
  }
}
