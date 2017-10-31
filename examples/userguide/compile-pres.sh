#!/bin/bash
# A script to compile the PhD Thesis - Krishna Kumar 
# 24-01-2016: Updated to use xelatex Demitris G. Anastasiou
# 04-06-2017: Convert to compile presentations templates
# Distributed under GPLv2.0 License

#compile="compile";
xelatex="xelatex"; 
xelatexf="xelatexf";
clean="clean";

if test -z "$2"
then
if [ $1 = $clean ]; then
	echo "Cleaning please wait ..."
	rm -f *~
	rm -rf *.aux
	rm -rf *.bbl
	rm -rf *.blg
	rm -rf *.d
	rm -rf *.fls
	rm -rf *.ilg
	rm -rf *.ind
	rm -rf *.toc*
	rm -rf *.lot*
	rm -rf *.lof*
	rm -rf *.log
	rm -rf *.idx
	rm -rf *.out*
	rm -rf *.nlo
	rm -rf *.nls
	rm -rf *.bcf
	rm -rf *.bib
	rm -rf *.fdb_latexmk
	rm -rf *.nav
	rm -rf *.run.xml
	rm -rf *.snm
        rm -rf *.xwm
	rm -rf $filename.pdf
	rm -rf $filename.ps
	rm -rf $filename.dvi
	rm -rf *#* 
	echo "Cleaning complete!"
	exit
else
	echo "Shell script for compiling the PhD Thesis"
	echo "Usage: sh ./compile-thesis.sh [OPTIONS] [filename]"
#	echo "[option]  compile: Compiles the PhD Thesis"
	echo "[option]  xelatex: Compile the PhD thesis using xelatex"
	echo "[option]  xelatexf: Compile xelatex and biber, full copilation"
	echo "[option]  clean: removes temporary files no filename required"
	exit
fi
fi

filename=$2;

if [ $1 = $clean ]; then
	echo "Cleaning please wait ..."
        rm -f *~
        rm -rf *.aux
        rm -rf *.bbl
        rm -rf *.blg
        rm -rf *.d
        rm -rf *.fls
        rm -rf *.ilg
        rm -rf *.ind
        rm -rf *.toc*
        rm -rf *.lot*
        rm -rf *.lof*
        rm -rf *.log
        rm -rf *.idx
        rm -rf *.out*
        rm -rf *.nlo
        rm -rf *.nls
        rm -rf *.bcf
        rm -rf *.bib
        rm -rf *.fdb_latexmk
        rm -rf *.nav
        rm -rf *.run.xml
        rm -rf *.snm
        rm -rf *.xwm
        rm -rf $filename.pdf
        rm -rf $filename.ps
        rm -rf $filename.dvi
        rm -rf *#* 
        echo "Cleaning complete!"
        exit
elif [ $1 = $xelatexf ]; then
	echo "Compiling your PhD Thesis...please wait...!"
	latexmk -xelatex $filename.tex				# <<-- NEW compilation after 26 May 17
	biber $filname.aux
	latexmk -xelatex -g $filename.tex
	echo "Success!"
	echo "LAST RUN" $(date)
	exit
elif [ $1 = $xelatex ]; then
        echo "Compiling your PhD Thesis...please wait...!"
#        latexmk -xelatex $filename.tex                          # <<-- NEW compilation after 26 May 17
#        biber $filname.aux
#        latexmk -xelatex -g $filename.tex
        xelatex $filename.tex
        echo "Success!"
	echo "LAST RUN:" $(date)
        exit
else
	echo "Shell script for compiling the PhD Thesis"
	echo "Usage: sh ./compile-thesis.sh [OPTIONS] [filename]"
#	echo "[option]  compile: Compiles the PhD Thesis"
	echo "[option]  xelatex: Compile the PhD thesis using xelatex"
        echo "[option]  xelatexf: Compile xelatex and biber, full copilation"
	echo "[option]  clean: removes temporary files no filename required"
	exit
fi

# reduce size of pdf file... sometimes work
# gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/default     -dNOPAUSE -dQUIET -dBATCH -dDetectDuplicateImages     -dCompressFonts=true -r80 -sOutputFile=phd_pres_low.pdf phd_pres.pdf

if test -z "$3"
then
	exit
fi
