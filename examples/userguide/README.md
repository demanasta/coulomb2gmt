Templates for academic presentations -- pre-released
======================

> Beamer - LaTeX \ XeLaTeX templates for professional presentations

[![Build Status](https://api.travis-ci.org/demanasta/pres-templates.svg)](https://travis-ci.org/demanasta/pres-templates)
[![License MIT](http://img.shields.io/badge/license-MIT-brightgreen.svg)](https://github.com/demanasta/pres-templates/blob/master/LICENSE)
[![](https://img.shields.io/github/release/demanasta/pres-templates.svg)](https://github.com/demanasta/pres-templates/releases/latest)
[![](https://img.shields.io/github/tag/demanasta/pres-templates.svg)](https://github.com/demanasta/pres-templates/tags)

[![](https://img.shields.io/github/stars/demanasta/pres-templates.svg)](https://github.com/demanasta/pres-templates/stargazers)
[![](https://img.shields.io/github/forks/demanasta/pres-templates.svg)](https://github.com/demanasta/pres-templates/network)
[![](https://img.shields.io/github/issues/demanasta/pres-templates.svg)](https://github.com/demanasta/pres-templates/issues)


## Author(s)
*   Demitris G. Anastasiou	

--------------------------------------------------------------------------------
## Features

* Supports XeLaTeX and LuaLaTeX

* Support Greek Language and Fonts (GFS, CMU, Libertine)

* Adaptive Title Page: Title page adapts to title length

* Pre-defined and custom fonts (CMU serif / Professional fonts) with math support

* Option to generate only specific chapters and references without the frontmatter and title page. Useful for review and corrections.

* Draft mode: Draft water mark, timestamp, version numbering
 
* Different styles and Classfiles:
    * `PhD`: A professional presentation for your thesis (PhD, Diploma etc)

    * `Pub`: Professional presentaions for your research work on conferences, meetings etc.
    
    * `Lct`: Academic presentation for university courses, lecture.
    
    
  * Special pre-defined frames for each style (thanku, Q&A)

--------------------------------------------------------------------------------

## Building your thesis - XeLaTeX
### Using latexmk (Unix/Linux/Windows)

This template supports `XeLaTeX` compilation chain. To generate  PDF run

    latexmk -xelatex phd_pres.tex
    biber phd_pres.tex
    latexmk -xelatex -g phd_pres.tex
    
### Shell script for XeLaTeX (Unix/Linux) (Recommended)

Usage: `sh ./compile-thesis.sh [OPTIONS] [filename]`

[option]  xelatex: Compile the PhD thesis using xelatex

[option]  xelatexf: Compile xelatex and biber, full copilation

[option]  clean: removes temporary files no filename required

### Using the make file (Unix/Linux)

The template supports PDF, DVI and PS formats. All three formats can be generated
with the provided `Makefile`.

To build the `PDF` version of your thesis, run:

    make


This build procedure uses `latexmk` and will produce `phd_pres.pdf`.

Use `Variables.ini` to change options:

Clean unwanted files

To clean unwanted clutter (all LaTeX auto-generated files), run:

    make clean

__Bug__: You cannot use `printbib` option on Class file!! 

__Note__: the `Makefile` itself is take from and maintained at
[here](http://code.google.com/p/latex-makefile/).
 
-------------------------------------------------------------------------------

## Usage details

Thesis information such as title, author, year, degree, etc., and other meta-data can be modified in `pres-info.tex`

###Information file
All available informations can be modified in `pres-info.tex`

This file includes all available informations and meta-data for your presentation
in four sections:
1. General & contact informations, for all styles.
2. PhD: Use this section with PhD style.
3. Pub: Use this section with publication style.
4. Lct: Usethis section with lecture style.

Uncomment only one section of 2,3 or 4 each time.

### Style file
All style files `.sty` placed at `sty` directory.
> Install Beamer custom style:
> 
> * Run: `$ tlmgr conf | grep "TEXMFHOME"
> 
> * Add style file at `${TEXMFHOME}/tex/latex/beamer/themes/`
> 
> * Run: `$ [sudo] texhash`

Otherwise you can place `.sty` file at the same directory with `.tex` file.

Then select you presentation style on `preamble.tex` file
 
### Class files

* `beamerPhD`: Class file for thesis presentations

* `beamerPub`: Class file for conference presentations!

* `beamerLct`: Class file for conference presentation!

### Class options

* `aspectratio=169`: reduce ratio to 16:9

* `customfont`: Pre-defined font is "Biolinum O". This option enable custom fonts . Config custom fonts at `preamble.tex`. Custom font include GFS package (GFS Neohellenic).

* `10pt` or `11pt`(default) : Recommended font size. Smaller (`8pt`,`9pt`) or huge (`14pt`,`17pt`,`20pt`) font size are NOT recommended except special cases.

* `draft`: Special draft mode with line numbers, images, and water mark with timestamp and custom text. Position of the text can also be modified. To disable figures see on `preample.tex` the Draftmode section.

* `chapter`: This option enables only the specified chapter and it's references. Useful for review and corrections. 

* `notes`: Prints frames and notes 

* `notes=only`: Prints only notes of each frame

* `printbib`: Include bibliography at the end of the presentation.

* `progrbar`: Enable progress bar in the frame. Chose this option after your  first compilation. Disable on *chapter* mode.

### Choosing Fonts

All three style support different fonts, configured in `preamble***.tex` file:

* `default (empty)` : When no font is specified, `Computer Modern Unicode - CMU` is used as the default font with Math Support. CMU font is alternative to `Latin Modern` but it support Greek language. To install cmu-fonts in debian destribution run: `$ sudo apt-get install fonts-cmu`

* `customfont` :  Any custom font can be set in preamble using this option. Some fonts had already set. Default custom font is `GFS Neohellenic` with math support.


## Contributing

1. Create an issue and describe your idea
2. [Fork it](https://github.com/demanasta/pres-templates/network#fork-destination-box)
3. Create your feature branch (`git checkout -b my-new-idea`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Publish the branch (`git push origin my-new-idea`)
6. Create a new Pull Request
7. Profit! :white_check_mark:

## ChangeLog

The history of releases can be viewed at [ChangeLog](ChangeLog.md)

## Acknowlegments

* Xanthos Papanikolaou [@xanthospap](https://github.com/xanthospap) - Original design idea of presentation style 