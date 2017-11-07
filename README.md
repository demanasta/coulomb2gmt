coulomb2gmt -- pre-released v1.0-beta7.0
==================

> Bash scripts to plot coulomb output on GMT


[![License MIT](http://img.shields.io/badge/license-MIT-brightgreen.svg)](https://github.com/demanasta/coulomb2gmt/blob/master/LICENSE)
[![](https://img.shields.io/github/release/demanasta/doulomb2gmt.svg)](https://github.com/coulomb2gmt/pres-templates/releases/latest)
[![](https://img.shields.io/github/tag/demanasta/coulomb2gmt.svg)](https://github.com/demanasta/coulomb2gmt/tags)
[![](https://img.shields.io/github/stars/demanasta/coulomb2gmt.svg)](https://github.com/demanasta/coulomb2gmt/stargazers)
[![](https://img.shields.io/github/forks/demanasta/coulomb2gmt.svg)](https://github.com/demanasta/coulomb2gmt/network)
[![](https://img.shields.io/github/issues/demanasta/coulomb2gmt.svg)](https://github.com/demanasta/coulomb2gmt/issues)

## Author
*   Demitris G. Anastasiou	

__Decleration__
The present project was developed during my doctoral dissertation, at the [Laboratory of Higher Geodesy and Dionysos Sastellite Observatory](http://dionysos.survey.ntua.gr/), at the [School of Rural & Surveying Engineering](http://www.survey.ntua.gr/en/) of [National Technical University of Athens](http://www.survey.ntua.gr/en/).

--------------------------------------------------------------------------------

## Features

* Αuto-configure map lat-long from input files (.inp)

* Plot Stress changes (Coulomb, Normal, Shear)

* Plot cross section for stress changes and dilatation.

* Plot all strain components (E**, Dilatation)

* Overlay stress/strain on the top of topographic DEM.

* Plot Fault geometry (Projection, Surface, Depth).

* Plot GPS displacements observed and modeled.

* Plot Fault and CMT databases and earhtquake distribution.

* Add GMT timestamp logo and custom logo of your organization.

* Adjust paper size to map and convert in different output formats (.jpg, .png, .eps, .pdf).


## Requirements

* __GMT__:  [The Generic Mappting Tools - GMT](http://gmt.soest.hawaii.edu/) version > 5.1.1 . It is recommented to install it from source code.
	*  for _Ubuntu/Debian_: if you use default package installation you have to install also `libgmt-dev` package

* __Coulomb 3__: [Coulomb 3, developed by USGS](https://earthquake.usgs.gov/research/software/coulomb/) 

* __python__: required for some math calculations included in the main script.

## Usage details
The main script is: `coulomb2gmt.sh`

run: 
```
 ./coulomb2gmt.sh  <inputfile> <inputdata> | options
```
* `<inputfile>`: name of input file used from Coulomb. Extention `.inp` not needed. Path to the directory of input files  configured at `default-param`.

* `<inputdata>`:  Code name of input files include results of coulmb calculations. Input data files are:

_Fault geometry files:_

*  `<inputdata>-gmt_fault_surface.dat`: Source and receiver faults’ trace at surface.

* `<inputdata>-gmt_fault_map_proj.dat`: Surface of source and receiver faults.

* `<inputdata>-gmt_fault_calc_dep.dat`: Intersection of target depth with fault plane.

_Stress change output files:_

* `<inputdata>-coulomb_out.dat`:  Coulomb matrix data output.

* `<inputdata>-dcff.cou`:  Output of all stress components.

* `<inputdata>-dcff_section.cou`: Output of all stress components in cross section.

* `<inputdata>-Cross_section.dat`: Cross section parameters.

* `<inputdata>-Focal_mech_stress_output.csv`: 

_Strain output files:_

* `<inputdata>-Strain.cou`: Data matrix of starin components.

_Earthquakes, GPS, custom text files:_

* Earthquakes distribution: Earthquakes catalogue files. Structure is
```
line1: Header line
line2: Header line
line*: YEAR MONTH DAY    HH MM SS    LAT.   LONG.  DEPTH    MAGNITUDE  (10 fields)
```
* Centroid Moment Tensors file: Structure of file is the old GMT format for CMT. Use \# to comment lines.
```
line* :  lon  lat   d  str dip slip str dip slip magnt exp plon  plat  name (14 fields)
```
* Custom text files: Use new gmt format for `pstext`. (GMT ver > 5.1 )
```
line* :lon lat font\_size,font\_type,font\_color angle potision text
```
* `<inputdata>-gps.dist`: GPS displacements.

> All paths can be configured in the `deafault-param` file. 
> Default the paths are where coulomb create by default each file.

### Default parameters

Many parameters configured at `default-param` file. Read carefully guideline in comments
1. Paths to general files (DEM, logo, faults)
2. Paths to input file directories (.inp, .dat, .cou, .disp)
3. ColorMaps Palette, frame variable.
4. General variables.

### General options

* `-r   | --region`: set custom region parameters. _Structure_ `-r minlon maxlon minlat maxlat prjscale`

* `-t   | --topography`:  plot topography using DEM file

* `-o  | --output <filename>`:  set custom name of output file. Default is `<inputdata>`.

* `-cmt | --moment_tensor <file>` :  Plot Centroid Moment Tensors list of earthquakes. 

* `-ed | --eq_distribution <file>` : Plot earthquakes distribution. No classification. 

*  `-fl | --faults_db`: Plot custom fault database catalogue.

* `-mt | --map_title  "map title"`: Custom map title.

* `-ct | --custom_text  <path to file>` :  Plot Custom text file.

* `-lg | --logo_gmt`: Plot GMT logo and time stamp.

* `-lc | --logo_custom`: Plot custom logo (image) of your organization.

* `-h | --help`: Help menu.

* `-v | --version`: Plot version.

* `-d | --debug`: Enable Debug option.

### Plot fault parameters

* `-fproj`: Plot source and receiver faults' trace at surface.

* `-fsurf`: Plot surface of source and receiver faults.

* `-fdep`: Plot intersection of target depth with fault plane.

### Plot stress 

* `-cstress`: Plot Coulomb Stress change.

* `-sstress`: Plot Shear Stress change.

* `-nstress`: Plot Normal Stress change.

* `-fcross`: Plot cross section of stress change or dilatation.

### Plot Strain components

* `-stre**`: Where `**` you can fill all strain components `xx`,`yy`,`zz`, `yz`, `xz`, `xy`.

* `-strdil`: Plot dilatation (Exx + Eyy + Ezz )

>**Overlay Stress/strain on the top of DEM**
>
>`-****+ot`: use `+ot`  after the main argument to overlay the raster output on the top of DEM.
>                  configure transparency in `default-param` file.
>  __Be careful__ transparency can printed only in JPEG, PNG and PDF outputs.

### Plot gps velocities, observed and modeled

* `-dgpsho`: Observed GPS horizontal displacements.

* `-dgpshm`: Modeled horizontal displacements on GPS sites (Okada 1985).

* `-dgpsvo`: Observed GPS vertical desplacements.

* `-dgpsvm`: Modeled vertical displacements on GPS sites (Okada 1985).

> Configure displacement scale in `default-param` file


### Output formats

Default format is `*.ps` file. You can use  the options bellow to convert  to other format and adjust paper size to map size.

* `-outjpg` : Adjust and convert to JPEG.

* `-outpng` : Adjust and convert to PNG (transparent where nothing is plotted).

* `-outeps` : Adjust and convert to EPS.

* `-outpdf` : Adjust and convert to PDF.

## Move and rename coulomb output files

An assistant script `mvclbfiles.sh` developed to move and rename all output files in specific directories on coulomb home directory.

You must first set `CLB34_HOME` variable the path to coulomb home directory,
etc. `$ export CLB34_HOME=${HOME}/coulomb34`

__Usage__: `$ ./mvclsbfiles.sh <inputdata>`
`<inputdata>` is the code as mentioned in the main script above.

__Files, rename and move:__
```
1. `coulomb_out.dat`  -> `/gmt_files/<inputdata>-coulomb_out.dat`
```
_Fault geometry files_
```
2. `gmt_fault_calc_dep.dat` -> `/gmt_files/<inputdata>-gmt_fault_calc_dep.dat`

3. `gmt_fault_map_proj.dat` ->  `/gmt_files/<inputdata>-gmt_fault_map_proj.dat`

4. `gmt_fault_surface.dat`  -> `/gmt_files/<inputdata>-gmt_fault_surface.dat`
```
_GPS displacements_
```
5. `/output_files/GPS_output.csv` -> ` /gps_data/<inputdata>-gps.disp`
```
_Stress change files_
```
6. `/output_files/Cross_section.dat` ->  `/output_files/<inputdata>-Cross_section.dat`

7. `/output_files/dcff.cou` ->  `/output_files/<inputdata>-dcff.cou`

8. `/output_files/dcff_section.cou` -> `/output_files/<inputdata>-dcff_section.cou`

9. `/output_files/dilatation_section.cou` -> `/output_files/<inputdata>-dilatation_section.cou`

10. `/output_files/Focal_mech_stress_output.csv` -> `/output_files/<inputdata>-Focal_mech_stress_output.csv`
```
_Strain output files_
```
11. `/output_files/Strain.cou` -> `/output_files/<inputdata>-Strain.cou`
```
## Contributing

1. Create an issue and describe your idea
2. [Fork it](https://github.com/demanasta/coulomb2gmt/network#fork-destination-box)
3. Create your feature branch (`git checkout -b my-new-idea`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Publish the branch (`git push origin my-new-idea`)
6. Create a new Pull Request
7. Profit! :white_check_mark:

## For contributors

### git structure

* __branch__ master/develop: stucture of main branch
  	* bash scripts
  		* coulomb2gmt.sh: main script
  		* mvclbfiles.sh: assistant script, move and rename files
  		* default-param: configure parameters
  	* functions: bash functions called from main script
  		* messages.sh: help function and ptint messages.
  		* gen_func.sh: general functions.
  		* clbplots.sh: functions for gmt plots
  		* checknum.sh: check number function.
  	* docs: MarkDown templates for issues, pull requests, contributions etc.
  		
  	
* __branch__ documents :
	* tutorial: reference and user guide, tex files.
	* examples: presentation of examples, tex/beamer files.
	
* __branch__ testcase: Include configured files for testing the script.

### Simple guidances for coding

* __general__
	* Use 80 characters long line.
	* Surround variables with `{}` and use `"${}"` in `if` case.
	* Use comments in coding.
* __gmt functions__
	* Use `-K` `-O` `-V${VRBLEVM}` at the end of each function. 
	* Create a function if a part of the script will be used more than two times.
	* Add printed comments and debug messages in the code.

## ChangeLog

The history of releases can be viewed at [ChangeLog](docs/ChangeLog.md)

## Acknowlegments

## References
* [Coulomb 3, developed by USGS](https://earthquake.usgs.gov/research/software/coulomb/)

* Toda, Shinji, Stein, R.S., Sevilgen, Volkan, and Lin, Jian, 2011, Coulomb 3.3 Graphic-rich deformation and stress-change software for earthquake, tectonic, and volcano research and teaching—user guide: U.S. Geological Survey Open-File Report 2011-1060, 63 p., available at http://pubs.usgs.gov/of/2011/1060/.

* [The Generic Mappting Tools - GMT](http://gmt.soest.hawaii.edu/)

* Python Software Foundation. Python Language Reference, version 2.7. Available at http://www.python.org

