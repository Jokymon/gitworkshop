.PHONY: gen clean all builddir slides handout

TMP := gen

SVGS := $(shell find diagrams/* -maxdepth 0 -name '*.svg')
PNGS = $(patsubst %.svg,$(TMP)/%.pdf,$(SVGS))

all: slides handout
	test -d ~/public_html && cp -f gitworkshop.pdf gitworkshop\ Handout.pdf ~/public_html/ || true

slides: gen $(PNGS)
	cd $(TMP) && pdflatex ../gitworkshop.tex
	cd $(TMP) && pdflatex ../gitworkshop.tex
	mv $(TMP)/gitworkshop.pdf GitWorkshop_Slides_$(shell date "+%Y-%m-%d").pdf

handout: gen $(PNGS)
	cd $(TMP) && HANDOUT=1 pdflatex ../gitworkshop.tex
	cd $(TMP) && HANDOUT=1 pdflatex ../gitworkshop.tex
	mv $(TMP)/gitworkshop.pdf GitWorkshop_Handout_$(shell date "+%Y-%m-%d").pdf

gen:
	mkdir -p $(TMP)/diagrams

$(TMP)/%.pdf: %.svg
	inkscape $< --without-gui --export-area-drawing --export-dpi=600 --export-pdf $@

clean:
	rm -rf $(TMP)

pull-image:
	docker pull blang/latex

travis-run-container:
	docker run --rm -ti -v $(shell pwd):/data blang/latex sh -c "apt update && apt install -y inkscape && make"
