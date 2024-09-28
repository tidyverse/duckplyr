all: index.md README.md

index.md: README.Rmd
	Rscript -e 'rmarkdown::render("$<", output_file = normalizePath("$@", mustWork = FALSE))'

README.md: README.Rmd
	R_CLI_NUM_COLORS=1 Rscript -e 'rmarkdown::render("$<")'
