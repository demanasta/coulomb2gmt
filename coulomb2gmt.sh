#!/bin/bash

# //////////////////////////////////////////////////////////////////////////////
# ==============================================================================
#   
#    |===========================================|
#    |**     DIONYSOS SATELLITE OBSERVATORY    **|
#    |**        HIGHER GEODESY LABORATORY      **|
#    |** National Tecnical University of Athens**|
#    |===========================================|
#   
#    filename       : coulomb2gmt.sh
#                     NAME=coulomb2gmt
#    version        : v-1.0
#                     VERSION=v1.0
#                     RELEASE=beta
#    licence        : MIT
#    created        : SEP-2015
#    usage          :
#    GMT Modules    :
#    UNIX progs     :
#    exit code(s)   : 0 -> success
#                   : 1 -> error
#    discription    : 
#    uses           : 
#    notes          :
#    update list    : LAST_UPDATE=OCT-2017
#        OCT-2017   : Re-format script with functions. Cross plots
#        OCT-2016   : Add logos, default parameters etc, 'didimoteixo v.' 
#        NOV-2015   : Strain plots, gps velocities, add topography
#        SEP-2015   : First release, stress plots, help, conversions
#    contact        : Demitris Anastasiou (dganastasiou@gmail.com)
#    ----------------------------------------------------------------------
# ==============================================================================

# //////////////////////////////////////////////////////////////////////////////
# #BASH settings
# set -o errexit
# set -o pipefail
# set -o nounset
# set -o xtrace

# //////////////////////////////////////////////////////////////////////////////
# pre define parameters

# program version
VERSION="v.1.0-beta6.1"

# verbosity level for GMT, see http://gmt.soest.hawaii.edu/doc/latest/gmt.html#v-full
# 
export VRBLEVM=n

# //////////////////////////////////////////////////////////////////////////////
# Source function files
source functions/checknum.sh  # check number functions
source functions/messages.sh
source functions/gen_func.sh
source functions/clbplots.sh

# //////////////////////////////////////////////////////////////////////////////
# GMT parameters
#gmtset MAP_FRAME_TYPE fancy

gmt gmtset PS_PAGE_ORIENTATION portrait
gmt gmtset FONT_ANNOT_PRIMARY 8 FONT_LABEL 8 MAP_FRAME_WIDTH 0.10c FONT_TITLE 15p
gmt gmtset PS_MEDIA 19cx22c

# //////////////////////////////////////////////////////////////////////////////
# Pre-defined parameters for bash script switches

TOPOGRAPHY=0
# LABELS=0
OUTFILES=0
# LEGEND=0
export FAULTS=0
LOGOGMT=0
LOGOCUS=0
MTITLE=0
CTEXT=0
EQDIST=0

RANGE=0
OVERTOPO=0
CSTRESS=0
SSTRESS=0
NSTRESS=0

STREXX=0
STREYY=0
STREZZ=0
STREYZ=0
STREXZ=0
STREXY=0
STRDIL=0

TEROBS=0
TEROBS_EXCL=0
PSCLEG=0

FPROJ=0
FSURF=0
FDEP=0
FCROSS=0
CMT=0

DGPSHO=0
DGPSHM=0
DGPSVO=0
DGPSVM=0

STRAIN=0

OUTJPG=0
OUTPNG=0
OUTEPS=0
OUTPDF=0


# //////////////////////////////////////////////////////////////////////////////
#check default param file 
if [ ! -f "default-param" ]; then
  echo "default-param file does not exist"
  exit 1
else
  source default-param
#   echo "Default parameters file: default-param"
fi


# //////////////////////////////////////////////////////////////////////////////
# GET COMMAND LINE ARGUMENTS
if [ "$#" -eq 0 ]; then
  help
elif [ "$#" -eq 1 ]; then
  if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
    help
  elif [ "${1}" == "-v" ] || [ "${1}" == "--version" ]; then
    echo "version: "${VERSION}
    exit 1
  else
    echo "[ERROR] Not enough input arguments."
    echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
    exit 1
  fi
elif [ "$#" -eq 2 ]; then
  echo "[ERROR] Not enough input arguments."
  echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
  exit 1
elif [ -f ${pth2inpdir}/${1}.inp ]; then
  echo "...get command line arguments..."
  inputfile=${1}.inp
  pth2inpfile=${pth2inpdir}/${1}.inp
  inputdata=${2}
  echo "[STATUS] input file exist"
  echo "[STATUS] input coulomb file:" ${inputfile} " input data files code:" ${inputdata}
  while [ $# -gt 2 ]; do
    case "${3}" in
    -d | --debug)
	_DEBUG="on"
# 	set -x
	PS4='L ${LINENO}: '
	shift
	;;
    -r | --region)
	DEBUG echo "[DEBUG:${LINENO}] -r next arguments:" ${4} ${5} ${6} ${7} ${8}
	if [ $# -ge 8 ];
	then
 	  isNumber ${4};  if [ $? -eq 0 ];  then
	    isNumber ${5}; if [ $? -eq 0 ] && [ $(echo "${5} >${4}" | bc) -eq 1 ]; then
	      isNumber ${6}; if [ $? -eq 0 ]; then
		isNumber ${7}; if [ $? -eq 0 ] && [ $(echo "${7} > ${6}" | bc) -eq 1 ]; then
		  isNumber ${8}; if [ $? -eq 0 ] && [ $(echo "${8} > 0" | bc) -eq 1 ]; then
		    DEBUG echo "[DEBUG:${LINENO}] test if $?"
		    RANGE=1
		    minlon=${4}
		    maxlon=${5}
		    minlat=${6}
		    maxlat=${7}
		    prjscale=${8}
		    shift
		    shift
		    shift
		    shift
		    shift
		  else
		    echo "[ERROR] \"${3}\": projscale must be a number and greater than 0."
		    echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
		    exit 1
		  fi
		else
		  echo "[ERROR] \"${3}\": maxlat must be a number and greater than minlat."
		  echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
		  exit 1
		fi
	      else
		echo "[ERROR] \"${3}\": minlat must be a number."
		echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
		exit 1
	      fi
	    else
	      echo "[ERROR] \"${3}\": maxlon must be number and greater than minlon."
	      echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
	      exit 1
	    fi
	  else
	    echo "[ERROR] \"${3}\": minlon must be number."
	    echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
	    exit 1
	  fi
	else
	  echo "[ERROR] Not enough input arguments at \"${3}\" option."
	  echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
	  exit 1
	fi
	shift # for -r
	;;
    -t | --topography)
	TOPOGRAPHY=1
	shift
	;;
    -o | --output)
	DEBUG echo "[DEBUG:${LINENO}] ${3}: next argument:" ${4}
	if [ $# -gt 3 ] && [ ${4:0:1} != \- ]; then
	  OUTFILES=1
	  outfile=${4}.ps
	  shift
	  shift
	elif [ $# -gt 3 ] && [ ${4:0:1} == \- ]; then
	  echo "[WARNING] No output file name set. Default name used."
	  shift
	elif [ $# -eq 3 ]; then
	  echo "[WARNING] No output file name set. Default name used."
	  shift
	fi
	;;
    -lg | --logo_gmt)
	LOGOGMT=1
	shift
	;;
    -lc | --logo_custom)
	LOGOCUS=1
	shift
	;;
    -cmt | --moment_tensor)
	DEBUG echo "[DEBUG:${LINENO}] ${3}: next argument:" ${4}
	if  [ $# -ge 4 ] && [ ${4:0:1} != \- ];	then
	  CMT=1
	  inpcmt=${pth2eqdir}/${4}
	  DEBUG echo "cmt file is: ${inpcmt}"
	  shift
	elif [ $# -ge 4 ] && [ ${4:0:1} == \- ]; then
	  echo "[WARNING] CMT file does not set! CMT will not be plotted"
	elif [ $# -eq 3 ]; then
	  echo "[WARNING] CMT file does not exist! CMT will not be plotted"
	fi
	shift #shift for arg -cmt
	;;
    -fl | --faults_db)
	FAULTS=1
	shift
	;;	
    -mt| --map_title)
	DEBUG echo "[DEBUG:${LINENO}] ${3}: next argument:" ${4}
	if [ $# -ge 4 ] && [ ${4:0:1} != \- ]; then
	  MTITLE=1
	  mtitle=${4}
	  shift
	elif [ $# -ge 4 ] && [ ${4:0:1} == \- ]; then
	  echo "[WARNING] No map title defined. Default title will be printed"
	elif [ $# -eq 3 ]; then
	  echo "[WARNING] No map title defined. Default title will be printed"
	fi
	shift #shift for the argument -mt
	;;
    -ct | --custom_text)
	DEBUG echo "[DEBUG:${LINENO}] ${3}: next argument:" ${4}
	if  [ $# -ge 4 ] && [ -f ${4} ]; then
	  CTEXT=1
	  pth2ctextfile=${4}
	  DEBUG echo "custom text file is: ${pth2ctextfile}"
	  shift
	elif [ $# -ge 4 ] && [ ${4:0:1} == \- ]; then
	  echo "[WARNING] Custom text file does not set! Custom text will not be plotted"
	elif  [ $# -ge 4 ] && [ ! -f ${4} ]; then
	  echo "[WARNING] Custom text file does not exist! Custom text will not be plotted"
	  shift
	elif [ $# -eq 3 ]; then
	  echo "[WARNING] Custom text file does not set! Custom text will not be plotted"
	fi
	shift # shift for the arg -ctext
	;;
    -ed | --eq_distribution)
	DEBUG echo "[DEBUG:${LINENO}] ${3}: next argument: "${4}
	if [ $# -ge 4 ] && [ ${4:0:1} != \- ]; then
	  EQDIST=1
	  pth2eqdistfile=${pth2eqdir}/${4}
	  shift
	elif [ $# -ge 4 ] && [ ${4:0:1} == \- ]; then
	  echo "[WARNING] No earthquake data file defined."
	elif [ $# -eq 3 ]; then
	  echo "[WARNING] No earthquake data file defined."
	fi
	shift #shift for the argument -eqdist
	;;
    -cstress*)
	CSTRESS=1
	check_arg_ot ${3:8:10}
	shift
	;;
    -sstress*)
	SSTRESS=1
	check_arg_ot ${3:8:10}
	shift
	;;
    -nstress*)
	NSTRESS=1
	check_arg_ot ${3:8:10}
	shift
	;;
    -strexx*)
	STREXX=1
	check_arg_ot ${3:7:9}
	shift
	;;
    -streyy*)
	STREYY=1
	check_arg_ot ${3:7:9}
	shift
	;;
    -strezz*)
	STREZZ=1
	check_arg_ot ${3:7:9}
	shift
	;;
    -streyz*)
	STREYZ=1
	check_arg_ot ${3:7:9}
	shift
	;;
    -strexz*)
	STREXZ=1
	check_arg_ot ${3:7:9}
	shift
	;;
    -strexy*)
	STREXY=1
	check_arg_ot ${3:7:9}
	shift
	;;
    -strdil*)
	STRDIL=1
	check_arg_ot ${3:7:9}
	shift
	;;
    -fproj)
	FPROJ=1
	shift
	;;
    -fsurf)
	FSURF=1
	shift
	;;
    -fdep)
	FDEP=1
	shift
	;;
    -fcross)
	FCROSS=1
	shift
	;;
    -dgpsho)
	DGPSHO=1
	shift
	;;
    -dgpshm)
	DGPSHM=1
	shift
	;;
    -dgpsvo)
	DGPSVO=1
	shift
	;;
    -dgpsvm)
	DGPSVM=1
	shift
	;;
		-l)
			LABELS=1
			shift
			;;
		-leg)
			LEGEND=1
			shift
			;;
    -outjpg)
	OUTJPG=1
	shift
	;;
    -outpng)
	OUTPNG=1
	shift
	;;
    -outeps)
	OUTEPS=1
	shift
	;;
    -outpdf)
	OUTPDF=1
	shift
	;;
    -h | --help )
	help
	;;
    -v | --version)
	echo "version: "$VERSION
	exit 1
	shift
	;;
    -*)
      echo "[ERROR] Bad argument structure. argument \"${3}\" is not right"
      echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
      exit 1
    esac
  done
else
    echo "[ERROR] Input file does not exist! use corret input file"
    help
fi

# //////////////////////////////////////////////////////////////////////////////
# Check confilcts for input arguments
# Only one of stress or strain components will plot.
inpconflict=$(echo print ${CSTRESS} + ${SSTRESS} + ${NSTRESS} + ${STREXX} \
  + ${STREYY} + ${STREZZ} + ${STREYZ} + ${STREXZ} + ${STREXY} | python)
DEBUG echo "[DEBUG:${LINENO}] input conflict=" ${inpconflict}

if [ "${inpconflict}" -ne 1 ] && [ "${inpconflict}" -ne 0 ]; then
  echo "[ERROR] Chose only one stress or strain component to plot"
  exit 1  
fi

### check fcross plot only with stress change
if [ "${STREXX}" -eq 1 ] || [ "${STREYY}" -eq 1 ] || [ "${STREZZ}" -eq 1 ] \
|| [ "${STREYZ}" -eq 1 ] || [ "${STREXZ}" -eq 1 ] || [ "${STREXY}" -eq 1 ] \
&& [ "${FCROSS}" -eq 1 ]; then
  echo "[WARNING] Cross section is in conflict with strain options"
  echo "          Only strain component will plotted in map"
  DEBUG echo "[DEBUG:${LINENO}] fcross set it "
  FCROSS=0
fi

# //////////////////////////////////////////////////////////////////////////////
# Output file name definition
if [ "${OUTFILES}" -eq 0 ]; then
  export outfile=${inputdata}.ps
fi

# //////////////////////////////////////////////////////////////////////////////
# Paths to all input files
pth2fprojfile=${pth2datdir}/${inputdata}-gmt_fault_map_proj.dat
pth2fsurffile=${pth2datdir}/${inputdata}-gmt_fault_surface.dat
pth2fdepfile=${pth2datdir}/${inputdata}-gmt_fault_calc_dep.dat

pth2coutfile=${pth2datdir}/${inputdata}-coulomb_out.dat
pth2dcfffile=${pth2coudir}/${inputdata}-dcff.cou
pth2strnfile=${pth2coudir}/${inputdata}-Strain.cou

pth2gpsdfile=${pth2gpsdir}/${inputdata}-gps.disp

pth2crossdat=${pth2coudir}/${inputdata}-Cross_section.dat
pth2crossdcf=${pth2coudir}/${inputdata}-dcff_section.cou
pth2crossdil=${pth2coudir}/${inputdata}-dilatation_section.cou
# //////////////////////////////////////////////////////////////////////////////
# Check if all input file exist
echo "...check all input files and paths"
### check fault map projection file
if [ "${FPROJ}" -eq 1 ] && [ ! -f "${pth2fprojfile}" ]; then
  echo "[WARNING] fault map projection file: "${pth2fprojfile}" does not exist"
  FPROJ=0
fi

### check fault surface file
if [ "${FSURF}" -eq 1 ] && [ ! -f "${pth2fsurffile}" ]; then
  echo "[WARNING] fault surface file: "${pth2fsurffile}" does not exist"
  FSURF=0
fi

### check fault surface file
if [ "${FDEP}" -eq 1 ] && [ ! -f "${pth2fdepfile}" ]; then
  echo "[WARNING] fault Depth file: "${pth2fdepfile}" does not exist"
  FDEP=0
fi

### check dems
if [ "${TOPOGRAPHY}" -eq 1 ] || [ "${OVERTOPO}" -eq 1 ]; then
  if [ ! -f "${inputTopoB}" ] || [ ! -f "${inputTopoL}" ]; then
    echo "[WARNING] grd file for topography toes not exist, var turn to coastline"
    TOPOGRAPHY=0; OVERTOPO=0;
  fi
fi

### check NOA FAULT catalogue
if [ "${FAULTS}" -eq 1 ] && [ ! -f "${pth2faults}" ]; then
  echo "[WARNING] NOA Faults database does not exist"
  echo "[WARNING] please download it and then use this switch"
  FAULTS=0
fi

### check cmt file
if [ "${CMT}" -eq 1 ] && [ ! -f "${inpcmt}" ]; then
  echo "[WARNING] CMT file does not exist, moment tensors will not plot"
  CMT=0
fi

### check eqarthquake data file
if [ "${EQDIST}" -eq 1 ] && [ ! -f "${pth2eqdistfile}" ]; then
  echo "[WARNING] earthquake data file  does not exist, earthquakes will not plot"
  EQDIST=0
fi

### set logogmt position
if [ "${LOGOGMT}" -eq 0 ]; then
  logogmt_pos=""
else
  DEBUG echo "[DEBUG:${LINENO}] logo gmt position set: ${logogmt_pos}"
fi

### check LOGO file
if [ ! -f "${pth2logo}" ]; then
	echo "[WARNING] Logo file does not exist"
	LOGO=0
fi

### check pth2coutfile
if [ "${CSTRESS}" -eq 1 ] || [ "${SSTRESS}" -eq 1 ] || [ "${NSTRESS}" -eq 1 ]; then
  if [ ! -f "${pth2coutfile}" ] || [ ! -f "${pth2dcfffile}" ]; then
    echo "[WARNING] "${pth2coutfile}" or  "${pth2dcfffile}" does not exist!"
    echo "[WARNING] Stress output will not plot"
    CSTRESS=0; SSTRESS=0; NSTRESS=0; FCROSS=0;
  elif [ "${FCROSS}" -eq 1 ]; then
    if [ ! -f "${pth2crossdat}" ] && [ ! -f "${pth2crossdcf}" ]; then
      echo "[WARNING] "${pth2crossdat}" or "${pth2crossdcf}" does not exist!"
      echo "[WARNING] Cross section will not plot"
      FCROSS=0;
    fi
  fi
fi

### check pth2strnfile
if [ "${STREXX}" -eq 1 ] || [ "${STREYY}" -eq 1 ] || [ "${STREZZ}" -eq 1 ] \
|| [ "${STREYZ}" -eq 1 ] || [ "${STREXZ}" -eq 1 ] || [ "${STREXY}" -eq 1 ] \
|| [ "${STRDIL}" -eq 1 ]; then
  if [ ! -f "${pth2coutfile}" ] || [ ! -f "${pth2strnfile}" ]; then
    echo "[WARNING] "${pth2coutfile}" or  "${pth2strnfile}" does not exist!"
    echo "[WARNING] Stress or Strain output will not plot"
    STREXX=0; STREYY=0;	STREZZ=0; STREYZ=0; STREXZ=0; STREXY=0; STRDIL=0;
  fi
fi

### check pth2crossdat pth2crossdil
if [ "${STRDIL}" -eq 1 ] && [ "${FCROSS}" -eq 1 ]; then
  if [ ! -f "${pth2crossdat}" ] && [ ! -f "${pth2crossdil}" ]; then
    echo "[WARNING] "${pth2crossdat}" or "${pth2crossdil}" does not exist!"
    echo "[WARNING] Cross section will not plot"
    FCROSS=0;
  fi
fi

### check for displacements file
if [ "${DGPSHO}" -eq 1 ] || [ "${DGPSHM}" -eq 1 ] || [ "${DGPSVO}" -eq 1 ] \
|| [ "${DGPSVM}" -eq 1 ]; then
  if [ ! -f "${pth2gpsdfile}" ]; then
    echo "[WARNING] "${pth2gpsdfile}" does no exist. Velocities will not plotted."
    DGPSHO=0; DGPSHM=0; DGPSVO=0; DGPSVM=0;
  fi
fi

# //////////////////////////////////////////////////////////////////////////////
# Configure Map Range

if [ "${RANGE}" -eq 0 ]; then
  minlon=$(grep "min. lon" ${pth2inpfile} | awk '{print $6}')
  maxlon=$(grep "max. lon" ${pth2inpfile} | awk '{print $6}')
  minlat=$(grep "min. lat" ${pth2inpfile} | awk '{print $6}')
  maxlat=$(grep "max. lat" ${pth2inpfile} | awk '{print $6}')
  prjscale=1500000 ##DEF 1000000
fi

prjscale=700000
sclat=$(echo print ${minlat} + 0.10 | python)
sclon=$(echo print ${maxlon} - 0.22 | python)
export scale=-Lf${sclon}/${sclat}/36:24/20+l+jr
export range=-R${minlon}/${maxlon}/${minlat}/${maxlat}
export proj=-Jm${minlon}/${minlat}/1:${prjscale}

DEBUG echo "[DEBUG:${LINENO}] scale set: ${scale}" 
DEBUG echo "[DEBUG:${LINENO}] range set: ${range}" 
DEBUG echo "[DEBUG:${LINENO}] projection set: ${proj}"

### Set calculation depth
if [ -z ${CALC_DEPTH+x} ]; then
  echo "[WARNING] CALC_DEPTH variable is not set. Input file will used."
  export CALC_DEPTH=$(grep "DEPTH=" ${pth2inpfile} | awk '{print $6}')
  echo "[STATUS] Calculation depth set to: "${CALC_DEPTH}" km"
else
  echo "[STATUS] Calculation depth set to: "${CALC_DEPTH}" km"
fi

# //////////////////////////////////////////////////////////////////////////////
# Configure Map title

if [ "${MTITLE}" -eq 1 ]; then
  echo "...set custom Map title..."
elif [ "${CSTRESS}" -eq 1 ]; then
  mtitle="Coulomb Stress Change"
elif [ "${SSTRESS}" -eq 1 ]; then
  mtitle="Shear Stress Change"
elif [ "${NSTRESS}" -eq 1 ]; then
  mtitle="Normal Stress Change"
elif [ "${STREXX}" -eq 1 ]; then 
  mtitle="Strain Component Exx"
elif [ "${STREYY}" -eq 1 ]; then
  mtitle="Strain Component Eyy"
elif [ "${STREZZ}" -eq 1 ]; then
  mtitle="Strain Component Ezz"
elif [ "${STREYZ}" -eq 1 ]; then
  mtitle="Strain Component Eyz"
elif [ "${STREXZ}" -eq 1 ]; then
  mtitle="Strain Component Exz"
elif [ "${STREXY}" -eq 1 ]; then
  mtitle="Strain Component Exy"
elif [ "${STRDIL}" -eq 1 ]; then
  mtitle="Dilatation (Exx + Eyy + Ezz)"
elif [ "${DGPSHO}" -eq 1 ] || [ "${DGPSHM}" -eq 1 ]; then
  mtitle="Horizontal Displacements"
elif [ "${DGPSVO}" -eq 1 ] || [ "${DGPSVM}" -eq 1 ]; then
  mtitle="Vertical Displacements"
else
  mtitle="Plots of Coulomb outputs"
fi


# //////////////////////////////////////////////////////////////////////////////
# Define to plot coastlines or topography

if [ "${CSTRESS}" -eq 0 ] && [ "${SSTRESS}" -eq 0 ] && [ "${NSTRESS}" -eq 0 ] \
&& [ "${STREXX}" -eq 0 ] && [ "${STREYY}" -eq 0 ] && [ "${STREZZ}" -eq 0 ] \
&& [ "${STREXZ}" -eq 0 ] && [ "${STREYZ}" -eq 0 ] && [ "${STREXY}" -eq 0 ] \
&& [ "${STRDIL}" -eq 0 ] && [ "${TOPOGRAPHY}" -eq 0 ]; then
  
  # Plot Coastlines
  gmt pscoast ${range} ${proj}  -Df -W0.25p,black -G240 -Y4.5c \
    -K -V${VRBLEVM} > ${outfile} 
  gmt psbasemap -R -J -B${frame}:."${mtitle}": ${scale} ${logogmt_pos} \
    -O -K -V${VRBLEVM} >> ${outfile}
  
  # Plot faults database
  plot_faults
  
fi

if [ "${CSTRESS}" -eq 0 ] && [ "${SSTRESS}" -eq 0 ] && [ "${NSTRESS}" -eq 0 ] \
&& [ "${STREXX}" -eq 0 ] && [ "${STREYY}" -eq 0 ] && [ "${STREZZ}" -eq 0 ] \
&& [ "${STREXZ}" -eq 0 ] && [ "${STREYZ}" -eq 0 ] && [ "${STREXY}" -eq 0 ] \
&& [ "${STRDIL}" -eq 0 ] && [ "${TOPOGRAPHY}" -eq 1 ]; then
  # ####################### TOPOGRAPHY ###########################
  # bathymetry
  gmt makecpt -Cgebco.cpt -T-7000/0/50 -Z -V${VRBLEVM} > ${bathcpt}
  gmt grdimage ${inputTopoB} ${range} ${proj} -C${bathcpt} -K -V${VRBLEVM} > ${outfile}
  gmt pscoast ${proj} -P ${range} -Df -Gc -K -O -V${VRBLEVM} >> ${outfile}
  # land
  gmt makecpt -Cgray.cpt -T-6000/1800/50 -Z -V${VRBLEVM} > ${landcpt}
  gmt grdimage ${inputTopoL} ${range} ${proj} -C${landcpt}  -K -O -V${VRBLEVM} >> ${outfile}
  gmt pscoast -R -J -O -K -Q -V${VRBLEVM} >> ${outfile}
  #------- coastline -------------------------------------------
  gmt psbasemap -R -J -O -K -B${frame}:."${mtitle}":  ${scale} -V${VRBLEVM} >> ${outfile}
  gmt pscoast -J -R -Df -W0.25p,black -K  -O ${logogmt_pos} -V${VRBLEVM} >> ${outfile}

  # Plot faults database
  plot_faults

fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT COULOMB STRESS CHANGE

if [ "${CSTRESS}" -eq 1 ]; then
  echo "...plot Coulomb Stress Change map... "
  # Plot stress/strain raster
  if [ "${OVERTOPO}" -eq 1 ]; then
    plotstr_overtopo ${pth2coutfile}
  else
    plotstr ${pth2coutfile}
  fi
  # Plot faults database
  plot_faults
  
  # Plot scale bar
  plot_barscale

  rm tmp* ## clear temporary files
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT SHEAR STRESS CHANGE

if [ "${SSTRESS}" -eq 1 ]; then
  echo "...plot Shear Stress Change map..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpcou1
  awk 'NR>3{print $5}' ${pth2dcfffile} > tmpcou2
  paste -d" " tmpcou1 tmpcou2 >tmpcouall
 
  if [ "${OVERTOPO}" -eq 1 ]; then
    plotstr_overtopo tmpcouall
  else
    plotstr tmpcouall
  fi
 
  # Plot faults database
  plot_faults

  # Plot scale bar
  plot_barscale

  # clear temporary files
  rm tmp* 
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT NORMAL STRESS CHANGE

if [ "${NSTRESS}" -eq 1 ]; then
  echo "...plot Normal Stress Change map..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpcou1
  awk 'NR>3 {print $6}' ${pth2dcfffile} > tmpcou2
  paste -d" " tmpcou1 tmpcou2 > tmpcouall
 
  if [ "${OVERTOPO}" -eq 1 ]; then
    plotstr_overtopo tmpcouall
  else
    plotstr tmpcouall
  fi
 
  # Plot faults database
  plot_faults

  # Plot scale bar
  plot_barscale

  # clear temporary files
  rm tmp*
  
fi


# //////////////////////////////////////////////////////////////////////////////
# PLOT STRAIN COMPONENT Exx

if [ "${STREXX}" -eq 1 ]; then
  echo "...plot Strain Component Exx..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpstr1
  awk 'NR>3 {print $4*1000000}' ${pth2strnfile} > tmpstr2
  paste -d" " tmpstr1 tmpstr2 > tmpstrall
  
  if [ "${OVERTOPO}" -eq 1 ]; then
    plotstr_overtopo tmpstrall
  else
    plotstr tmpstrall
  fi
  
  # Plot faults database
  plot_faults

  # Plot scale bar
  plot_barscale

  # clear temporary files
  rm tmp*
  
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT STRAIN COMPONENT Eyy

if [ "${STREYY}" -eq 1 ]; then
  echo "...plot Strain Component Eyy..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpstr1
  awk 'NR>3 {print $5*1000000}' ${pth2strnfile} > tmpstr2
  paste -d" " tmpstr1 tmpstr2 > tmpstrall
  
  if [ "${OVERTOPO}" -eq 1 ]; then
    plotstr_overtopo tmpstrall
  else
    plotstr tmpstrall
  fi
  
  # Plot faults database
  plot_faults

  # Plot scale bar
  plot_barscale

  # clear temporary files
  rm tmp*
  
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT STRAIN COMPONENT Ezz

if [ "${STREZZ}" -eq 1 ]; then
  echo "...plot Strain Component Ezz..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpstr1
  awk 'NR>3 {print $6*1000000}' ${pth2strnfile} > tmpstr2
  paste -d" " tmpstr1 tmpstr2 > tmpstrall
  
  if [ "${OVERTOPO}" -eq 1 ]; then
    plotstr_overtopo tmpstrall
  else
    plotstr tmpstrall
  fi
  
  # Plot faults database
  plot_faults

  # Plot scale bar
  plot_barscale
  
  # clear temporary files
  rm tmp*
  
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT STRAIN COMPONENT Eyz

if [ "${STREYZ}" -eq 1 ]; then
  echo "...plot Strain Component Eyz..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpstr1
  awk 'NR>3 {print $7*1000000}' ${pth2strnfile} > tmpstr2
  paste -d" " tmpstr1 tmpstr2 > tmpstrall
  
  if [ "${OVERTOPO}" -eq 1 ]; then
    plotstr_overtopo tmpstrall
  else
    plotstr tmpstrall
  fi
  
  # Plot faults database
  plot_faults

  # Plot scale bar
  plot_barscale
  
  # clear temporary files
  rm tmpstr1 tmpstr2 tmpstrall tmpgrd tmpgrd_sample.grd tmpcpt.cpt
  
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT STRAIN COMPONENT Exz

if [ "${STREXZ}" -eq 1 ]; then
  echo "...plot Strain Component Exz..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpstr1
  awk 'NR>3 {print $8*1000000}' ${pth2strnfile} > tmpstr2
  paste -d" " tmpstr1 tmpstr2 > tmpstrall
  
  if [ "${OVERTOPO}" -eq 1 ]; then
    plotstr_overtopo tmpstrall
  else
    plotstr tmpstrall
  fi
  
  # Plot faults database
  plot_faults

  # Plot scale bar
  plot_barscale

  # clear temporary files
  rm tmp* ## clear temporary files
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT STRAIN COMPONENT Exy

if [ "${STREXY}" -eq 1 ]; then
  echo "...plot Strain Component Exy..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpstr1
  awk 'NR>3 {print $9*1000000}' ${pth2strnfile} > tmpstr2
  paste -d" " tmpstr1 tmpstr2 > tmpstrall
  
  if [ "${OVERTOPO}" -eq 1 ]; then
    plotstr_overtopo tmpstrall
  else
    plotstr tmpstrall
  fi
  
  # Plot faults database
  plot_faults

  # Plot scale bar
  plot_barscale
  
  # clear temporary files
  rm tmp*
  
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT DILATATION STRAIN

if [ "${STRDIL}" -eq 1 ]; then
  echo "...plot Dilatation (Exx + Eyy + Ezz)..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpstr1
  awk 'NR>3 {print $10*1000000}' ${pth2strnfile} > tmpstr2
  paste -d" " tmpstr1 tmpstr2 > tmpstrall
  
  if [ "${OVERTOPO}" -eq 1 ]; then
    plotstr_overtopo tmpstrall
  else
    plotstr tmpstrall
  fi
  
  # Plot faults database
  plot_faults

  # Plot scale bar
  plot_barscale

  # clear temporary files
  rm tmp*
  
fi


# //////////////////////////////////////////////////////////////////////////////
# PLOT gmt fault geometry

if [ "${FPROJ}" -eq 1 ]; then
  echo "...plot fault projection..."
  gmt psxy ${pth2fprojfile} -Jm -R -W1,red -O -K -V${VRBLEVM} >> ${outfile}
fi
if [ "${FSURF}" -eq 1 ]; then
  echo "...plot fault surface..."
  gmt psxy ${pth2fsurffile} -Jm -R -W0.5,green -O -K -V${VRBLEVM} >> ${outfile}
fi
if [ "${FDEP}" -eq 1 ]; then
  echo "...plot depth calculation..."
  gmt psxy ${pth2fdepfile} -Jm -R -W0.5,black -O -K -V${VRBLEVM} >> ${outfile}
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT earthquakes distributions 

if [ "${EQDIST}" -eq 1 ]; then
  echo "...plot earthquakes distribution..."
  awk 'NR>2 {print $8, $7}' ${pth2eqdistfile} \
  | gmt psxy -Jm -R -Sc0.1c -Gblack -O -K -V${VRBLEVM} >> ${outfile}
fi 

# //////////////////////////////////////////////////////////////////////////////
# PLOT CMT of earthquakes  

if [ "${CMT}" -eq 1 ]; then
  echo "...plot Centroid Moment Tensor file..."
  awk '{print $1,$2}' ${inpcmt} \
  | gmt psxy -Jm -R -Sa0.3c -Gred -O -K -V${VRBLEVM} >> ${outfile}
  awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9}' ${inpcmt} \
  | gmt psmeca -R -Jm -Sa0.4 -CP0.05 -K -O -V${VRBLEVM} >> ${outfile}
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT GPS OBSERVED AND MODELED OKADA SURF DESPLACEMENTS

scdhlatl=${sclat}
scdhlonl=${sclon}

# Plot horizontal modeled displacements
if [ "${DGPSHM}" -eq 1 ]; then
  echo "...plot Horizontal Modeled Displacements..."
  awk -F, 'NR>2 {print $1,$2,$6,$7,0,0,0}' ${pth2gpsdfile} \
  | gmt psvelo -R -Jm -Se${dhscale}/0.95/0 -W2p,blue -A10p+e -Gblue \
    -O -K -L -V${VRBLEVM} >> ${outfile} 

  # plot horizontal scale
  plot_hdisp_scale ${sclon} ${sclat} blue Modeled
fi

# Plot horizontal observed displacements
if [ "${DGPSHO}" -eq 1 ]; then
  echo "...plot Horizontal Observed Displacements..."
  awk -F, 'NR>2 {print $1,$2,$3,$4,0,0,0}' ${pth2gpsdfile} \
  | gmt psvelo -R -Jm -Se${dhscale}/0.95/0 -W2p,red -A10p+e -Gred \
    -L -O -K -V${VRBLEVM} >> ${outfile}

  # plot horizontal scale
  plot_hdisp_scale ${scdhlonl} ${scdhlatl} red Observed
fi

scdvlat=$(echo print ${sclat} + .25 | python)
scdvlonl=$(echo print ${sclon} + 0.16 | python)

# Plot vertical modeled displacements
if [ "${DGPSVM}" -eq 1 ]; then
  echo "...plot Vertical Modeled Displacements..."
  awk -F, 'NR>2 {if ($8<0) print $1,$2,0,$8,0,0,0}'  ${pth2gpsdfile} \
  | gmt psvelo -R -Jm -Se${dvscale}/0.95/0 -W2p,blue -A10p+e -Gblue \
    -L -O -K -V${VRBLEVM} >> ${outfile}
  awk -F, 'NR>2 {if ($8>=0) print $1,$2,0,$8,0,0,0}' ${pth2gpsdfile} \
  | gmt psvelo -R -Jm -Se${dvscale}/0.95/0 -W2p,red -A10p+e -Gred \
    -L -O -K -V${VRBLEVM} >> ${outfile}
  
  # Plot vertical scale
  plot_vdisp_scale ${scdvlonl} ${scdvlat} red blue Modeled
fi

# Plot vertical observed displacements
if [ "${DGPSVO}" -eq 1 ]; then
  echo "...plot Vertical Observed Displacements..."
  DEBUG echo "[DEBUG:${LINENO}] -X.08c add in mext line"
  awk -F, 'NR>2 {if ($5<0) print $1,$2,0,$5,0,0,0}'  ${pth2gpsdfile} \
  | gmt psvelo -R -Jm -Se${dvscale}/0.95/0 -W2p,0/255/0 -G0/255/0 -X.08c \
    -L -O -K -V${VRBLEVM} >> ${outfile}
  awk -F, 'NR>2 {if ($5>=0) print $1,$2,0,$5,0,0,0}' ${pth2gpsdfile} \
  | gmt psvelo -R -Jm -Se${dvscale}/0.95/0 -W2p,255/215/0 -A10p+e -G255/215/0 \
    -L -O -K -V${VRBLEVM} >> ${outfile}

  # Plot vertical scale
  plot_vdisp_scale ${scdvlonl} ${scdvlat} 255/215/0 0/255/0 Observed

fi

# Plot vertical scale legend
if [ "${DGPSVM}" -eq 1 ] || [ "${DGPSVO}" -eq 1 ]; then
  scdvmolat=$(echo print ${sclat} + .05 | python)
  DEBUG echo "[DEBUG:${LINENO}] -X-.08 added next line"
  echo "${sclon} ${scdvmolat} 9,1,black 0 CM \261 ${dvscmagn} mm" \
  | gmt pstext -R -Jm -Dj0c/0c -F+f+a+j -X-.08c -O -K -V${VRBLEVM} >> ${outfile}
fi


# //////////////////////////////////////////////////////////////////////////////
# Plot custom text configured at custom_text file
if [ "$CTEXT" -eq 1 ]; then
  echo "...plot custom text file..."
  grep -v "#" $pth2ctextfile \
  | gmt pstext -R -Jm -Dj0c/0c -F+f+a+j  -O -K -V${VRBLEVM} >> ${outfile}
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT CROSS SECTION PROJECTION

if [ "$FCROSS" -eq 1 ]; then
  echo "...plot cross sections..."
 
  # plot in the main map the cross section line
  plot_cross_line ${pth2crossdat}
  
  # make file to plot cross sections
  if [ "${STRDIL}" -eq 1 ]; then
    awk 'NR>3' $pth2crossdil > tmpcrossdcf
    tmpstartx=$(awk 'NR==4 {print $1}' tmpcrossdcf)
    DEBUG echo "[DEBUG:${LINENO}] start x " $tmpstartx
    tmpstarty=$(awk 'NR==4 {print $2}' tmpcrossdcf)
    DEBUG echo "[DEBUG:${LINENO}] start y " $tmpstarty
    # make proj file
      awk 'NR>3 {print sqrt(($1 - '$tmpstartx')^2 + ($2 - '$tmpstarty')^2), $3, $4*1000000}' \
	$pth2crossdil > tmpcrossdcf2
  else
    awk 'NR>3' $pth2crossdcf > tmpcrossdcf
    tmpstartx=$(awk 'NR==4 {print $1}' tmpcrossdcf)
    DEBUG echo "[DEBUG:${LINENO}] start x " $tmpstartx
    tmpstarty=$(awk 'NR==4 {print $2}' tmpcrossdcf)
    DEBUG echo "[DEBUG:${LINENO}] start y " $tmpstarty
    # make proj file
    if [ "${CSTRESS}" -eq 1 ];  then
      awk 'NR>3 {print sqrt(($1 - '$tmpstartx')^2 + ($2 - '$tmpstarty')^2), $3, $4}' \
	$pth2crossdcf > tmpcrossdcf2
    elif [ "${SSTRESS}" -eq 1 ]; then
      awk 'NR>3 {print sqrt(($1 - '$tmpstartx')^2 + ($2 - '$tmpstarty')^2), $3, $5}' \
	$pth2crossdcf > tmpcrossdcf2
    elif [ "${NSTRESS}" -eq 1 ]; then
      awk 'NR>3 {print sqrt(($1 - '$tmpstartx')^2 + ($2 - '$tmpstarty')^2), $3, $6}' \
	$pth2crossdcf > tmpcrossdcf2
    fi
  fi
   
  # check fault on input file
  fault_num=$(grep "${FAULT_CODE}" ${pth2inpfile} -c)
  DEBUG echo "[DEBUG:${LINENO}] fault number: "${fault_num}
  
  # calculate fault coordinates on cross section
  calc_fault_cross ${fault_num}

  DEBUG echo "[DEBUG:${LINENO}] fault number: "${fault_num}
 
  # create range for projection
  west=$(awk 'NR==1 {print $1}' tmpcrossdcf2)
  east=$(awk 'END {print $1}' tmpcrossdcf2)
  zmin=0
  zmax=$(awk 'NR==7 {print $5}' $pth2crossdat)
  
  rangep="-R$west/$east/$zmin/$zmax"
  DEBUG echo "[DEBUG:${LINENO}]  proj range: "${rangep}
  projp=-JX14.8/-4
  tick=-B50:Distance\(km\):/5:Depth\(km\):WSen
  
  gmt psbasemap ${rangep} ${projp} -O -K $tick  -V${VRBLEVM} -Ya-6.5c >> ${outfile}

  gmt xyz2grd tmpcrossdcf2 -Gtmpgrd ${rangep} -I2 -V${VRBLEVM} 
  gmt makecpt -C$coulombcpt -T-$barrange/$barrange/0.002 -Z -V${VRBLEVM} > tmpcpt.cpt
  gmt grdsample tmpgrd -I.05 -Gtmpgrd_sample.grd -V${VRBLEVM} 
  gmt grdimage tmpgrd_sample.grd -Ctmpcpt.cpt -J -Ya-6.5c -Ei \
    -Q -O -K -V${VRBLEVM} >> ${outfile}
  
  # Plot A-B in projection
  echo "$west $zmin  9,1,black 0 LT A" \
  | gmt pstext -R -J -Dj0.1c/0.1c -F+f+a+j -Ya-6.5c -O -K -V${VRBLEVM} >> ${outfile}
  echo "$east $zmin  9,1,black 0 RT B" \
  | gmt pstext -R -J -Dj0.1c/0.1c -F+f+a+j -Ya-6.5c -O -K -V${VRBLEVM} >> ${outfile}

  # Plot fault on cross section
  for i in `seq 1 ${fault_num}`; do
    plot_fault_cross ${i}
  done
  
   
  # Plot calculation depth dashed line
  echo "$west $CALC_DEPTH" >tmpdep
  echo "$east $CALC_DEPTH" >>tmpdep
  gmt psxy tmpdep -R -J -W.15,black,- -Ya-6.5c -O -K -V${VRBLEVM} >>${outfile}

  # clear temporary files
  rm tmp*
  
fi

# //////////////////////////////////////////////////////////////////////////////
# Plot custom logo configured at default-param

if [ "$LOGOCUS" -eq 1 ]; then
  echo "...add custom logo..."
  gmt psimage $pth2logo $logocus_pos -F0.4 -O -K -V${VRBLEVM} >>${outfile}
fi

# //////////////////////////////////////////////////////////////////////////////
# FINAL SECTION
#################--- Close ps output file ----##################################
echo "909 909" | gmt psxy -Sc.1 -Jm -R  -W1,red -O -V${VRBLEVM} >> ${outfile}

#################--- Convert to other format ----###############################
if [ "$OUTJPG" -eq 1 ]
then
  echo "...adjust and convert to JPEG format..."
#   gs -sDEVICE=jpeg -dJPEGQ=100 -dNOPAUSE -dBATCH -dSAFER -r300 -sOutputFile=test.jpg ${outfile}
  gmt psconvert ${outfile} -A0.2c -Tj -V${VRBLEVM} 
fi
if [ "$OUTPNG" -eq 1 ]
then
  echo "...adjust and convert to PNG format..."
  gmt psconvert ${outfile} -A0.2c -TG -V${VRBLEVM} 	
fi
if [ "$OUTEPS" -eq 1 ]
then
  echo "...adjust and convert to EPS format..."
  gmt psconvert ${outfile} -A0.2c -Te -V${VRBLEVM} 
fi
if [ "$OUTPDF" -eq 1 ]
then
  echo "...adjust and convert to PDF format..."
  gmt psconvert ${outfile} -A0.2c -Tf -V${VRBLEVM} 
fi

# clear all teporary files
# rm tmp*
# Print exit status
echo "[STATUS] Finished. Exit status: $?"