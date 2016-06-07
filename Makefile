MODULES = prep intro stochsim pfilter mif polio ebola measles hadley contacts
INSTALLDIR = $(CURDIR)/www

default: index.html modules
	install -m0600 index.html $(INSTALLDIR)

modules:
	for module in $(MODULES); do ($(MAKE) INSTALLDIR=$(INSTALLDIR)/$$module -C $$module); done

%.html: %.Rmd
	PATH=/usr/lib/rstudio/bin/pandoc:$$PATH \
	Rscript --vanilla -e "rmarkdown::render(\"$*.Rmd\",output_format=\"html_document\")"

%.html: %.md
	PATH=/usr/lib/rstudio/bin/pandoc:$$PATH \
	Rscript --vanilla -e "rmarkdown::render(\"$*.md\",output_format=\"html_document\")"

%.R: %.Rmd
	Rscript --vanilla -e "knitr::purl(\"$*.Rmd\",output=\"$*.R\",documentation=2)"

clean:
	$(RM) *.o *.so *.log *.aux *.out *.nav *.snm *.toc *.bak
	$(RM) Rplots.ps Rplots.pdf

fresh: clean
	$(RM) -r cache figure
	for module in $(MODULES); do (cd $$module && $(MAKE) fresh); done
