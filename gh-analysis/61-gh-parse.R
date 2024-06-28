library(tidyverse)
pkgload::load_all()

files <- fs::dir_ls("gh/contents")

fs::dir_create("gh/parsed")

for (file in files) {
  parsed_file <- fs::path("gh/parsed", fs::path_ext_set(fs::path_file(file), ".qs"))
  if (!fs::file_exists(parsed_file)) {
    message(file)
    try({
      lines <- readLines(file)
      lines[[1]] <- sub("^content = ", "", lines[[1]])
      parsed <- parse(text = lines, keep.source = FALSE)
      qs::qsave(parsed, parsed_file)
    })
  }
}
