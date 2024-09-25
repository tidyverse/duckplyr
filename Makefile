all: README.md .github/README.md

README.md: README.Rmd
	Rscript -e 'rmarkdown::render("$<")'

.github/README.md: README.Rmd
	Rscript -e 'rmarkdown::render("$<", output_format = downlit::readme_document(), output_file = normalizePath("$@"))'
