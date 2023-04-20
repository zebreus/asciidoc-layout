PWD = $(shell pwd)
ASCIIDOCTOR = asciidoctor
DOCKER = docker
SASS = sass
# ASCIIDOCTOR_WEB_PDF = npx asciidoctor-pdf
ASCIIDOCTOR_WEB_PDF = $(DOCKER) run -i --rm --volume=$(PWD):"/usr/app" -u $(shell id -u):$(shell id -g) ggrossetie/asciidoctor-web-pdf:latest 

.EXTRA_PREREQS:=Makefile
all: Readme.pdf

SCSS_FILES = $(wildcard styles/*.scss) $(wildcard styles/*/*.scss) $(wildcard styles/*/*/*.scss)

Readme.css: $(SCSS_FILES)
	cd styles ; $(SASS) --update --sourcemap=none styles.scss:../Readme.css

index.html: Readme.adoc Readme.css
	$(ASCIIDOCTOR) -r asciidoctor-diagram Readme.adoc -o index.html

Readme.pdf: Readme.adoc Readme.css
	$(ASCIIDOCTOR_WEB_PDF) Readme.adoc

clean:
	rm -rf Readme.css

dist-clean: clean
	rm -rf Readme.pdf

.PHONY: clean all dist-clean