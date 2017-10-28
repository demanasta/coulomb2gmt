coulomb2gmt -- pre-released v1.0-beta5.1
==================

> Bash scripts to plot coulomb results on gmt


[![License MIT](http://img.shields.io/badge/license-MIT-brightgreen.svg)](https://github.com/demanasta/coulomb2gmt/blob/master/LICENSE)
[![](https://img.shields.io/github/release/demanasta/doulomb2gmt.svg)](https://github.com/coulomb2gmt/pres-templates/releases/latest)
[![](https://img.shields.io/github/tag/demanasta/coulomb2gmt.svg)](https://github.com/demanasta/coulomb2gmt/tags)
[![](https://img.shields.io/github/stars/demanasta/coulomb2gmt.svg)](https://github.com/demanasta/coulomb2gmt/stargazers)
[![](https://img.shields.io/github/forks/demanasta/coulomb2gmt.svg)](https://github.com/demanasta/coulomb2gmt/network)
[![](https://img.shields.io/github/issues/demanasta/coulomb2gmt.svg)](https://github.com/demanasta/coulomb2gmt/issues)

## Author(s)
*   Demitris G. Anastasiou	

--------------------------------------------------------------------------------

## Features

* auto-configure map lat-long from input files (.inp)

* Plot Stress changes (Coulomb, Normal, Shear)

* Plot cross section for stress chages.

* Plot all strain components (E**, Dilatation)

* Plot Fault geometry (Projection, Surface, Depth)

* Plot GPS displacement observed and modeled

* Plot Fault and CMT databases and earhtquake distribution

* Add GMT timestamp logo and custom logo of your organization.

* Adjust paper size to map and convert in different output formats (.jpg, .png, .eps, .pdf)


## Requirements

* __GMT__:  [The Generic Mappting Tools - GMT](http://gmt.soest.hawaii.edu/) version > 5.1.1 . Recommented installation from source code.
	*  for _Ubuntu/Debian_ if you use default package installation you have to install also `libgmt-dev` package

* __Coulomb 3__: [Coulomb 3, developed by USGS](https://earthquake.usgs.gov/research/software/coulomb/) 

* __python__: required for some calculations included in the main script.

## Usage details
The main script is: `coulomb2gmt.sh`

run: `$ ./coulomb2gmt.sh <inputfile> <inputdata> | options`

* `<inputfile>`: name of input file used from Coulomb. Extention `.inp` not needed. Path to the directory of input files  configured at `default-param`.

* `<inputdata>`:  Name of input files include results of coulmb calculations. Input data files are:

_Fault geometry files:_

*  `<inputdata>-gmt_fault_surface.dat`:

* `<inputdata>-gmt_fault_map_proj.dat`:

* `<inputdata>-gmt_fault_calc_dep.dat`:

_Stress change output files:_

* `<inputdata>-coulomb_out.dat`:

* `<inputdata>-dcff.cou`:

* `<inputdata>-dcff_section.cou`:

* `<inputdata>-Cross_section.dat`:

* `<inputdata>-Focal_mech_stress_output.csv`:

_Strain output files:_

* `<inputdata>-Strain.cou`:

_Earthquakes, GPS, custom text files:_



### Default parameters
Many parameters configured at `default-param` file.
1. Paths to general files (DEM, logo, faults)
2. Paths to input file directories (.inp, .dat, .cou, .disp)
3. ColorMaps Palette, frame variable.
4. Scale parameters.

### General options

* `-r`: set custom region parameters. _Structure_ `-r minlon maxlon minlat maxlat prjscale`

* `-topo`:  plot topography using dem file

* `-o <filename>`:  set custom name of output file. Default is `<inputadata>`.

* `-cmt <file>` :  Plot Centroid Moment Tensors of earthquakes. 

* `-eqdist <file>` : Plot earthquakes distribution. No classification. 

*  `-faults`: Plot custom fault database catalogue.

* `-mt "map title"`: Custom map title.

* `-ctext  <path to file>` :  Plot Custom text. Config custom text file.

* `-logogmt`: Plot GMT logo and time stamp.

* `-logocus`: Plot custom logo of your organization.

* `-h`: Help menu

* `-v`: Plot version

* `-debug`:Enable Debug option 



### Plot fault parameters

* `-fproj`: Plot source and receiver faults' trace at surface.

* `-fsurf`: Plot surface of source and receiver faults.

* `-fdep`: Plot intersection of target depth with fault plane.

### Plot stress 
* `-cstress`: Plot Coulomb Stress change.

* `-sstress`: Plot Shear Stress change.

* `-nstress`: Plot Normal Stress change.

* `-fcross`: Plot cross section of stress change.

### Plot Strain components

* `-stre**`: Where `**` you can fill all strain components `xx`,`yy`,`zz`, `yz`, `xz`, `xy`.

* `-strdil`: Plot dilatation (Exx + Eyy + Ezz )

### Plot gps velocities, observed and modeled

* `-dgpsho`: Observed GPS horizontal displacements.

* `-dgpshm`: Modeled horizontal displacements on GPS sites (Okada 1985).

* `-dgpsvo`: Observed GPS vertical desplacements.

* `-dgpsvm`: Modeled vertical displacements on GPS sites (Okada 1985).

> Configure displacement scale in `default-param` file


### Output formats
Default format is `*.ps` file. You can use  the options bellow to convert  to other format and adjust paper size to map size.

* `-outjpg` : Adjust and convert to JPEG.

* `-outpng` : Adjust and convert to PNG (transparent where nothing is plotted)

* `-outeps` : Adjust and convert to EPS"

* `-outpdf` : Adjust and convert to PDF

## `mvclsbfiles.sh` script

An assistant script `mvclbfiles.sh` developed to move` and rename all output files in specific directories on coulomb home directory.

You must first set `CLB34_HOME` variable the path to coulomb home directory,
etc. `$ export CLB34_HOME=${HOME}/coulomb34`

__Usage__: `$ ./mvclsbfiles.sh <inputdata>`
`<inputdata>` is the code as me ntioned in the main script above.

__Files, Rename and move:__

* `coulomb_out.dat` -> `/gmt_files/<inputdata>-coulomb_out.dat`

_Fault geometry files_

* `gmt_fault_calc_dep.dat` -> `/gmt_files/<inputdata>-gmt_fault_calc_dep.dat`

* `gmt_fault_map_proj.dat` ->  `/gmt_files/<inputdata>-gmt_fault_map_proj.dat`

* `gmt_fault_surface.dat` -> `/gmt_files/<inputdata>-gmt_fault_surface.dat`

_GPS displacements_

* `/output_files/GPS_output.csv` -> ` /gps_data/<inputdata>-gps.disp`

_Stress change files_

* `/output_files/Cross_section.dat` ->  `/output_files/<inputdata>-Cross_section.dat`

* `/output_files/dcff.cou` ->  `/output_files/<inputdata>-dcff.cou`

* `/output_files/dcff_section.cou` -> `/output_files/<inputdata>-dcff_section.cou`

* `/output_files/Focal_mech_stress_output.csv` -> `/output_files/<inputdata>-Focal_mech_stress_output.csv`

_Strain output files_

* `/output_files/Strain.cou` -> `/output_files/<inputdata>-Strain.cou`

## Contributing

1. Create an issue and describe your idea
2. [Fork it](https://github.com/demanasta/coulomb2gmt/network#fork-destination-box)
3. Create your feature branch (`git checkout -b my-new-idea`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Publish the branch (`git push origin my-new-idea`)
6. Create a new Pull Request
7. Profit! :white_check_mark:

## ChangeLog

The history of releases can be viewed at [ChangeLog](docs/ChangeLog.md)

## Acknowlegments

## References
* [Coulomb 3, developed by USGS](https://earthquake.usgs.gov/research/software/coulomb/)

* Toda, Shinji, Stein, R.S., Sevilgen, Volkan, and Lin, Jian, 2011, Coulomb 3.3 Graphic-rich deformation and stress-change software for earthquake, tectonic, and volcano research and teaching—user guide: U.S. Geological Survey Open-File Report 2011-1060, 63 p., available at http://pubs.usgs.gov/of/2011/1060/.

* [The Generic Mappting Tools - GMT](http://gmt.soest.hawaii.edu/)

* Python Software Foundation. Python Language Reference, version 2.7. Available at http://www.python.org

