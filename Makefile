all: index.md README.md

index.md README.md: README.Rmd
	Rscript --vanilla -e 'options(readme.target = "$@", pillar.bold = TRUE); rmarkdown::render("$<", intermediates_dir = "$@.temp", output_file = normalizePath("$@", mustWork = FALSE))'
