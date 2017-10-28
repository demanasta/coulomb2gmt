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
#    filename              : coulomb2gmt.sh
#                            NAME=coulomb2gmt
#    version               : v-1.0
#                            VERSION=v1.0
#                            RELEASE=beta
#    licence               : MIT
#    created               : SEP-2015
#    usage                 :
#    exit code(s)          : 0 -> success
#                          : 1 -> error
#    discription           : 
#    uses                  : 
#    notes                 :
#    detailed update list  : LAST_UPDATE=OCT-2017
#                 OCT-2016 : Add logos, default parameters etc, 'didimoteixo v.' 
#                 NOV-2015 : Strain plots, gps velocities, add topography
#                 SEP-2015 : First release, stress plots, help, conversions
#    contact               : Demitris Anastasiou (dganastasiou@gmail.com)
#    ----------------------------------------------------------------------
# ==============================================================================

# //////////////////////////////////////////////////////////////////////////////
# pre define parameters

# program version
VERSION="v.1.0-beta5.6"

# verbosity level for GMT, see http://gmt.soest.hawaii.edu/doc/latest/gmt.html#v-full
# 
VRBLEVM=c

# //////////////////////////////////////////////////////////////////////////////
# HELP FUNCTION
function help {
  echo "/******************************************************************************/"
  echo " Program Name : coulomb2gmt.sh"
  echo " Version : $VERSION"
  echo " Purpose : Plot Coulomb Stress change results"
  echo " Usage   : coulomb2gmt.sh  <inputfile> <inputdata> | options | "
  echo " Switches: "
  echo "/*** GENERAL OPTIONS **********************************************************/"
  echo "           -r [:=region] set different region minlon maxlon minlat maxlat prjscale"
  echo "           -topo [:=topography] plot topography using dem file if exist "
  echo "           -o <name> [:= output] name of output files"
#   echo "           -l [:=labels] plot labels"
#   echo "           -leg [:=legend] insert legends"
  echo "           -cmt <file> [:=Plot central moment tensors] insert file "
  echo "           -faults [:= faults] plot fault database catalogue"
  echo "           -mt <title> [:= map title] title map default none use quotes"
  echo "           -ctext <file>[:=cusotm text] Plot custom text in map"
  echo "           -eqdist <file> [] Plot earthquake distribution"
  echo "           -h [:= help] help menu"
  echo "           -logogmt [:=gmt logo] Plot gmt logo and time stamp"
  echo "           -logocus [:=custom logo] Plot custom logo of your organization"
  echo "           -v [:version] Plots script release"
  echo "           -debug [:=DEBUG] enable debug option"
  echo ""
  echo "/*** PLOT FAULT PARAMETERS ****************************************************/"
  echo "           -fproj [:=Fault projection] "
  echo "           -fsurf [:=Fault surface] "
  echo "           -fdep [:=Fault calculation depth] "
  echo ""
  echo "/*** PLOT STRESS CHANGE OUTPUTS ***********************************************/"
  echo "           -cstress [:=Coulomb Stress] "
  echo "           -sstress [:=Shear Stress] "
  echo "           -nstress [:=Normal strain] "
  echo "           -fcross [:=plot cross section projections] "
  echo ""
  echo "/*** PLOT COMPONENTS OF STRAIN FIELD ******************************************/"
  echo "           -strexx [:= Exx component] "
  echo "           -streyy [:= Eyy component] "
  echo "           -strezz [:= Ezz component] "
  echo "           -streyz [:= Eyz component] "
  echo "           -strexz [:= Exz component] "
  echo "           -strexy [:= Exy component] "
  echo "           -strdil [:= Dilatation strain] "
  echo ""
  echo "/*** PLOT OKADA85 *************************************************************/"
  echo "           -dgpsho : observed GPS horizontal displacements"
  echo "           -dgpshm : modeled horizontal displacements on gps site"
  echo "           -dgpsvo : observed GPS vertical displacements"
  echo "           -dgpsvm : modeled vertical displacements on gps sites"
  echo ""
  echo "/*** OUTPUT FORMATS ***********************************************************/"
  echo "           -outjpg : Adjust and convert to JPEG"
  echo "           -outpng : Adjust and convert to PNG (transparent where nothing is plotted)"
  echo "           -outeps : Adjust and convert to EPS"
  echo "           -outpdf : Adjust and convert to PDF"
  echo ""
  echo " Exit Status:    1 -> help message or error"
  echo " Exit Status:  = 0 -> sucesseful exit"
  echo ""
  echo "/******************************************************************************/"
  exit 1
}
# //////////////////////////////////////////////////////////////////////////////
# Debug function
function DEBUG()
{
 [ "$_DEBUG" == "on" ] &&  $@
}

# //////////////////////////////////////////////////////////////////////////////
# Source function files
source .checknum.sh  # check number functions

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
FAULTS=0
LOGOGMT=0
LOGOCUS=0
MTITLE=0
CTEXT=0
EQDIST=0

RANGE=0
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
  echo "Default parameters file: default-param"
fi

# //////////////////////////////////////////////////////////////////////////////
# GET COMMAND LINE ARGUMENTS
echo "...get command line arguments..."
if [ "$#" -eq 0 ]; then
  help
elif [ "$#" -eq 1 ]; then
  if [ "$1" == "-h" ]; then
    help
  elif [ "$1" == "-v" ]; then
    echo "version: "$VERSION
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
  inputfile=${1}.inp
  pth2inpfile=${pth2inpdir}/${1}.inp
  inputdata=${2}
  echo "[STATUS] input file exist"
  echo "[STATUS] input coulomb file:" $inputfile " input data files code:" $inputdata
  while [ $# -gt 2 ]; do
    case "$3" in
    -debug)
	_DEBUG="on"
# 	set -x
	PS4='L ${LINENO}: '
	shift
	;;
    -r)
	DEBUG echo "[DEBUG:${LINENO}] -r next arguments:" ${4} ${5} ${6} ${7} ${8}
	if [ $# -ge 8 ];
	then
 	  isNumber ${4};  if [ $? -eq 0 ];  then
	    isNumber ${5}; if [ $? -eq 0 ] && [ $(echo "$5 >$4" | bc) -eq 1 ]; then
	      isNumber ${6}; if [ $? -eq 0 ]; then
		isNumber ${7}; if [ $? -eq 0 ] && [ $(echo "$7 > $6" | bc) -eq 1 ]; then
		  isNumber ${8}; if [ $? -eq 0 ] && [ $(echo "$8 > 0" | bc) -eq 1 ]; then
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
		    echo "[ERROR] \"-r\": projscale must be a number and greater than 0."
		    echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
		    exit 1
		  fi
		else
		  echo "[ERROR] \"-r\": maxlat must be a number and greater than minlat."
		  echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
		  exit 1
		fi
	      else
		echo "[ERROR] \"-r\": minlat must be a number."
		echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
		exit 1
	      fi
	    else
	      echo "[ERROR] \"-r\": maxlon must be number and greater than minlon."
	      echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
	      exit 1
	    fi
	  else
	    echo "[ERROR] \"-r\": minlon must be number."
	    echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
	    exit 1
	  fi
	else
	  echo "[ERROR] Not enough input arguments at \"-r\" option."
	  echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
	  exit 1
	fi
	shift # for -r
	;;
    -topo)
	TOPOGRAPHY=1
	shift
	;;
    -o)
	DEBUG echo "[DEBUG:${LINENO}] -o: next argument:" ${4}
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
    -logogmt)
	LOGOGMT=1
	shift
	;;
    -logocus)
	LOGOCUS=1
	shift
	;;
    -cmt)
	DEBUG echo "[DEBUG:${LINENO}] cmt: next argument:" ${4}
	if  [ $# -ge 4 ] && [ ${4:0:1} != \- ];	then
	  CMT=1
	  inpcmt=${pth2eqdir}/${4}
	  DEBUG echo "cmt file is: $inpcmt"
	  shift
	elif [ $# -ge 4 ] && [ ${4:0:1} == \- ]; then
	  echo "[WARNING] CMT file does not set! CMT will not be plotted"
	elif [ $# -eq 3 ]; then
	  echo "[WARNING] CMT file does not exist! CMT will not be plotted"
	fi
	shift #shift for arg -cmt
	;;
    -faults)
	FAULTS=1
	shift
	;;	
    -mt)
	DEBUG echo "[DEBUG:${LINENO}] maptitle: next argument:" ${4}
	if [ $# -ge 4 ] && [ ${4:0:1} != \- ]; then
	  MTITLE=1
	  mtitle=$4
	  shift
	elif [ $# -ge 4 ] && [ ${4:0:1} == \- ]; then
	  echo "[WARNING] No map title defined. Default title will be printed"
	elif [ $# -eq 3 ]; then
	  echo "[WARNING] No map title defined. Default title will be printed"
	fi
	shift #shift for the argument -mt
	;;
    -ctext)
	DEBUG echo "[DEBUG:${LINENO}] ctext: next argument:" ${4}
	if  [ $# -ge 4 ] && [ -f ${4} ]; then
	  CTEXT=1
	  pth2ctextfile=${4}
	  DEBUG echo "custom text file is: $pth2ctextfile"
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
    -eqdist)
	DEBUG echo "[DEBUG:${LINENO}] eqdist next argument: "${4}
	if [ $# -ge 4 ] && [ ${4:0:1} != \- ]; then
	  EQDIST=1
	  pth2eqdistfile=${pth2eqdir}/$4
	  shift
	elif [ $# -ge 4 ] && [ ${4:0:1} == \- ]; then
	  echo "[WARNING] No earthquake data file defined."
	elif [ $# -eq 3 ]; then
	  echo "[WARNING] No earthquake data file defined."
	fi
	shift #shift for the argument -eqdist
	;;
    -cstress)
	CSTRESS=1
	shift
	;;
    -sstress)
	SSTRESS=1
	shift
	;;
    -nstress)
	NSTRESS=1
	shift
	;;
    -strexx)
	STREXX=1
	shift
	;;
    -streyy)
	STREYY=1
	shift
	;;
    -strezz)
	STREZZ=1
	shift
	;;
    -streyz)
	STREYZ=1
	shift
	;;
    -strexz)
	STREXZ=1
	shift
	;;
    -strexy)
	STREXY=1
	shift
	;;
    -strdil)
	STRDIL=1
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
    -h)
	help
	;;
    -v)
	echo "version: "$VERSION
	exit 1
	shift
	;;
    -*)
      echo "[ERROR] Bad argument structure. argument \"$3\" is not right"
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
inpconflict=$(echo print $CSTRESS + $SSTRESS + $NSTRESS + $STREXX + $STREYY \
  + $STREZZ + $STREYZ + $STREXZ + $STREXY | python)
DEBUG echo "[DEBUG:${LINENO}] input conflict=" $inpconflict

if [ "$inpconflict" -ne 1 ] && [ "$inpconflict" -ne 0 ]; then
  echo "[ERROR] Chose only one stress or strain component to plot"
  exit 1  
fi

### check fcross plot only with stress change
if  [ "$STREXX" -eq 1 ] || [ "$STREYY" -eq 1 ] || [ "$STREZZ" -eq 1 ] \
|| [ "$STREYZ" -eq 1 ] || [ "$STREXZ" -eq 1 ] || [ "$STREXY" -eq 1 ] \
|| [ "$STRDIL" -eq 1 ] && [ "$FCROSS" -eq 1 ]; then
  echo "[WARNING] Cross section is in conflict with strain options"
  echo "          Only strain component will plotted in map"
  DEBUG echo "[DEBUG:${LINENO}] fcross set it )"
  FCROSS=0
fi

# //////////////////////////////////////////////////////////////////////////////
# Output file name definition
if [ "$OUTFILES" -eq 0 ]; then
  outfile=${inputdata}.ps
fi

# //////////////////////////////////////////////////////////////////////////////
# Paths to all input files
pth2fprojfile=${pth2datdir}/${inputdata}-gmt_fault_map_proj.dat
pth2fsurffile=${pth2datdir}/${inputdata}-gmt_fault_surface.dat
pth2fdepfile=${pth2datdir}/${inputdata}-gmt_fault_calc_dep.dat

pth2coutfile=${pth2datdir}/${inputdata}-coulomb_out.dat
pth2dcfffile=${pth2coudir}/${inputdata}-dcff.cou
pth2strnfile=${pth2coudir}/${inputdata}_Strain.cou

pth2gpsdfile=${pth2gpsdir}/${inputdata}-gps.disp

pth2crossdat=${pth2coudir}/${inputdata}-Cross_section.dat
pth2crossdcf=${pth2coudir}/${inputdata}-dcff_section.cou
# //////////////////////////////////////////////////////////////////////////////
# Check if all input file exist
echo "...check all input files and paths"
### check fault map projection file
if [ "$FPROJ" -eq 1 ] && [ ! -f "${pth2fprojfile}" ]; then
  echo "[WARNING] fault map projection file: "${pth2fprojfile}" does not exist"
  FPROJ=0
fi

### check fault surface file
if [ "$FSURF" -eq 1 ] && [ ! -f "${pth2fsurffile}" ]; then
  echo "[WARNING] fault surface file: "${pth2fsurffile}" does not exist"
  FSURF=0
fi

### check fault surface file
if [ "$FDEP" -eq 1 ] && [ ! -f "${pth2fdepfile}" ]; then
  echo "[WARNING] fault Depth file: "${pth2fdepfile}" does not exist"
  FDEP=0
fi

### check dems
if [ "$TOPOGRAPHY" -eq 1 ]; then
  if [ ! -f $inputTopoB ]; then
    echo "[WARNING] grd file for topography toes not exist, var turn to coastline"
    TOPOGRAPHY=0
  fi
fi

### check NOA FAULT catalogue
if [ "$FAULTS" -eq 1 ] && [ ! -f $pth2faults ]; then
  echo "[WARNING] NOA Faults database does not exist"
  echo "[WARNING] please download it and then use this switch"
  FAULTS=0
fi

### check cmt file
if [ "$CMT" -eq 1 ] && [ ! -f $inpcmt ]; then
  echo "[WARNING] CMT file does not exist, moment tensors will not plot"
  CMT=0
fi

### check eqarthquake data file
if [ "$EQDIST" -eq 1 ] && [ ! -f $pth2eqdistfile ]; then
  echo "[WARNING] earthquake data file  does not exist, earthquakes will not plot"
  EQDIST=0
fi

### set logogmt position
if [ "$LOGOGMT" -eq 0 ]; then
  logogmt_pos=""
else
  DEBUG echo "[DEBUG:${LINENO}] logo gmt position set: $logogmt_pos"
fi

### check LOGO file
if [ ! -f "$pth2logo" ]; then
	echo "[WARNING] Logo file does not exist"
	LOGO=0
fi

### check pth2coutfile
if [ "$CSTRESS" -eq 1 ] || [ "$SSTRESS" -eq 1 ] || [ "$NSTRESS" -eq 1 ]; then
  if [ ! -f "$pth2coutfile" ] || [ ! -f "$pth2dcfffile" ]; then
    echo "[WARNING] "$pth2coutfile" or  "$pth2dcfffile" does not exist!"
    echo "[WARNING] Stress output will not plot"
    CSTRESS=0; SSTRESS=0; NSTRESS=0; FCROSS=0;
  elif [ "$FCROSS" -eq 1 ]; then
    if [ ! -f "$pth2crossdat" ] && [ ! -f "$pth2crossdcf" ]; then
      echo "[WARNING] "$pth2crossdat" or "$pth2crossdcf" does not exist!"
      echo "[WARNING] Cross section will not plot"
      FCROSS=0;
    fi
  fi
fi

if [ "$STREXX" -eq 1 ] || [ "$STREYY" -eq 1 ] || [ "$STREZZ" -eq 1 ] \
|| [ "$STREYZ" -eq 1 ] || [ "$STREXZ" -eq 1 ] || [ "$STREXY" -eq 1 ] \
|| [ "$STRDIL" -eq 1 ]; then
  if [ ! -f "$pth2coutfile" ] || [ ! -f "$pth2strnfile" ]; then
    echo "[WARNING] "$pth2coutfile" or  "$pth2strnfile" does not exist!"
    echo "[WARNING] Stress or Strain output will not plot"
    STREXX=0; STREYY=0;	STREZZ=0; STREYZ=0; STREXZ=0; STREXY=0; STRDIL=0;
  fi
fi

## check for displacements file
if [ "$DGPSHO" -eq 1 ] || [ "$DGPSHM" -eq 1 ] || [ "$DGPSVO" -eq 1 ] \
|| [ "$DGPSVM" -eq 1 ]; then
  if [ ! -f "$pth2gpsdfile" ]; then
    echo "[WARNING] "$pth2gpsdfile" does no exist. Velocities will not plotted."
    DGPSHO=0; DGPSHM=0; DGPSVO=0; DGPSVM=0;
  fi
fi


# //////////////////////////////////////////////////////////////////////////////
# Configure Map Range

if [ "$RANGE" -eq 0 ]; then
  minlon=$(grep "min. lon" ${pth2inpfile} | awk '{print $6}')
  maxlon=$(grep "max. lon" ${pth2inpfile} | awk '{print $6}')
  minlat=$(grep "min. lat" ${pth2inpfile} | awk '{print $6}')
  maxlat=$(grep "max. lat" ${pth2inpfile} | awk '{print $6}')
  prjscale=1500000 ##DEF 1000000
fi

sclat=$(echo print $minlat + 0.10 | python)
sclon=$(echo print $maxlon - 0.22 | python)
scale=-Lf${sclon}/${sclat}/36:24/20+l+jr
range=-R$minlon/$maxlon/$minlat/$maxlat
proj=-Jm$minlon/$minlat/1:$prjscale

DEBUG echo "[DEBUG:${LINENO}] scale set: $scale" 
DEBUG echo "[DEBUG:${LINENO}] range set: $range" 
DEBUG echo "[DEBUG:${LINENO}] projection set: $proj"

# Set calculation depth
if [ -z ${CALC_DEPTH+x} ]; then
  echo "[WARNING] CALC_DEPTH variable is not set. Input file will used."
  CALC_DEPTH=$(grep "DEPTH=" ${pth2inpfile} | awk '{print $6}')
  echo "[STATUS] Calculation depth set to: "$CALC_DEPTH" km"
else
  echo "[STATUS] Calculation depth set to: "$CALC_DEPTH" km"
fi

# //////////////////////////////////////////////////////////////////////////////
# Configure Map title

if [ "$MTITLE" -eq 1 ]; then
  echo "...set custom Map title..."
elif [ "$CSTRESS" -eq 1 ]; then
  mtitle="Coulomb Stress Change"
elif [ "$SSTRESS" -eq 1 ]; then
  mtitle="Shear Stress Change"
elif [ "$NSTRESS" -eq 1 ]; then
  mtitle="Normal Stress Change"
elif [ "$STREXX" -eq 1 ]; then 
  mtitle="Strain Component Exx"
elif [ "$STREYY" -eq 1 ]; then
  mtitle="Strain Component Eyy"
elif [ "$STREZZ" -eq 1 ]; then
  mtitle="Strain Component Ezz"
elif [ "$STREYZ" -eq 1 ]; then
  mtitle="Strain Component Eyz"
elif [ "$STREXZ" -eq 1 ]; then
  mtitle="Strain Component Exz"
elif [ "$STREXY" -eq 1 ]; then
  mtitle="Strain Component Exy"
elif [ "$STRDIL" -eq 1 ]; then
  mtitle="Dilatation (Exx + Eyy + Ezz)"
elif [ "$DGPSHO" -eq 1 ] || [ "$DGPSHM" -eq 1 ]; then
  mtitle="Horizontal Displacements"
elif [ "$DGPSVO" -eq 1 ] || [ "$DGPSVM" -eq 1 ]; then
  mtitle="Vertical Displacements"
else
  mtitle="Plots of Coulomb outputs"
fi


# //////////////////////////////////////////////////////////////////////////////
# Define to plot coastlines or topography

if [ "$CSTRESS" -eq 0 ] && [ "$SSTRESS" -eq 0 ] && [ "$NSTRESS" -eq 0 ] \
&& [ "$STREXX" -eq 0 ] && [ "$STREYY" -eq 0 ] && [ "$STREZZ" -eq 0 ] \
&& [ "$STREXZ" -eq 0 ] && [ "$STREYZ" -eq 0 ] && [ "$STREXY" -eq 0 ] \
&& [ "$STRDIL" -eq 0 ] && [ "$TOPOGRAPHY" -eq 0 ]; then
  ################## Plot coastlines only ######################
  gmt pscoast $range $proj  -Df -W0.25p,black -G240 -Y4.5c \
    -K -V${VRBLEVM} > $outfile 
  gmt psbasemap -R -J -B$frame:."$mtitle": $scale $logogmt_pos \
    -O -K -V${VRBLEVM} >> $outfile
  
  #  PLOT NOA CATALOGUE FAULTS Ganas et.al, 2013
  if [ "$FAULTS" -eq 1 ]; then
    echo "...plot fault database catalogue..."
    gmt	psxy $pth2faults -R -J -O -K  -W.5,204/102/0 -V${VRBLEVM} >> $outfile
  fi
fi

if [ "$CSTRESS" -eq 0 ] && [ "$SSTRESS" -eq 0 ] && [ "$NSTRESS" -eq 0 ] \
&& [ "$STREXX" -eq 0 ] && [ "$STREYY" -eq 0 ] && [ "$STREZZ" -eq 0 ] \
&& [ "$STREXZ" -eq 0 ] && [ "$STREYZ" -eq 0 ] && [ "$STREXY" -eq 0 ] \
&& [ "$STRDIL" -eq 0 ] && [ "$TOPOGRAPHY" -eq 1 ]; then
  # ####################### TOPOGRAPHY ###########################
  # bathymetry
  gmt makecpt -Cgebco.cpt -T-7000/0/50 -Z -V${VRBLEVM} > $bathcpt
  gmt grdimage $inputTopoB $range $proj -C$bathcpt -K -V${VRBLEVM} > $outfile
  gmt pscoast $proj -P $range -Df -Gc -K -O -V${VRBLEVM} >> $outfile
  # land
  gmt makecpt -Cgray.cpt -T-6000/1800/50 -Z -V${VRBLEVM} > $landcpt
  gmt grdimage $inputTopoL $range $proj -C$landcpt  -K -O -V${VRBLEVM} >> $outfile
  gmt pscoast -R -J -O -K -Q -V${VRBLEVM} >> $outfile
  #------- coastline -------------------------------------------
  gmt psbasemap -R -J -O -K -B$frame:."$maptitle":  $scale -V${VRBLEVM} >> $outfile
  gmt pscoast -J -R -Df -W0.25p,black -K  -O -$logogmt_pos -V${VRBLEVM} >> $outfile
  
    
  #  PLOT NOA CATALOGUE FAULTS Ganas et.al, 2013
  if [ "$FAULTS" -eq 1 ]; then
    echo "...plot fault database catalogue..."
    gmt	psxy $pth2faults -R -J -O -K  -W.5,204/102/0 -V${VRBLEVM} >> $outfile
  fi
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT COULOMB STRESS CHANGE

if [ "$CSTRESS" -eq 1 ]
then
  echo "...plot Coulomb Stress Change map... "
  ################# Plot Coulomb source AnD coastlines only ######################
  gmt xyz2grd ${pth2coutfile} -Gtmpgrd $range -I0.05 -V${VRBLEVM}
  gmt makecpt -C$coulombcpt -T-$barrange/$barrange/0.002 -Z -V${VRBLEVM} > tmpcpt.cpt
  gmt grdsample tmpgrd -I4s -Gtmpgrd_sample.grd -V${VRBLEVM}
  gmt grdimage tmpgrd_sample.grd -Ctmpcpt.cpt $proj -Ei -Y8c \
    -Q -K -V${VRBLEVM} > $outfile
  gmt pscoast $range $proj -Df -W0.5,120 -O -K -V${VRBLEVM} >> $outfile 
  gmt psbasemap -R -J -B$frame:."$mtitle": $scale $logogmt_pos \
    -O -K -V${VRBLEVM} >> $outfile
  #  PLOT NOA CATALOGUE FAULTS Ganas et.al, 2013
  if [ "$FAULTS" -eq 1 ]; then
    echo "...plot fault database catalogue..."
    gmt	psxy $pth2faults -R -J -W.5,204/102/0  -O -K -V${VRBLEVM} >> $outfile
  fi
  ########### Plot scale Bar ####################
  bartick=$(echo $barrange | awk '{print $1/5}')
  gmt psscale -D2.75i/-0.4i/4i/0.15ih -Ctmpcpt.cpt -B$bartick/:bar: \
    -O -K -V${VRBLEVM} >> $outfile
  rm tmp* ## clear temporary files
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT SHEAR STRESS CHANGE

if [ "$SSTRESS" -eq 1 ]; then
  echo "...plot Shear Stress Change map..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpcou1
  awk 'NR>3{print $5}' ${pth2dcfffile} > tmpcou2
  paste -d" " tmpcou1 tmpcou2 >tmpcouall
 
 ################# Plot Coulomb source AnD coastlines only ######################
  gmt xyz2grd tmpcouall -Gtmpgrd $range -I0.05 -V${VRBLEVM}
  gmt makecpt -C$coulombcpt -T-$barrange/$barrange/0.002 -Z -V${VRBLEVM} > tmpcpt.cpt
  gmt grdsample tmpgrd -I4s -Gtmpgrd_sample.grd -V${VRBLEVM}
  gmt grdimage tmpgrd_sample.grd -Ctmpcpt.cpt $proj -Ei -Y8c \
    -Q -K -V${VRBLEVM} > $outfile
  gmt pscoast $range $proj -Df -W0.5,120 -O -K -V${VRBLEVM} >> $outfile 
  gmt psbasemap -R -J -B$frame:."$mtitle": $scale $logogmt_pos \
    -O -K -V${VRBLEVM} >> $outfile
  #  PLOT NOA CATALOGUE FAULTS Ganas et.al, 2013
  if [ "$FAULTS" -eq 1 ]; then
    echo "...plot fault database catalogue..."
    gmt	psxy $pth2faults -R -J -W.5,204/102/0 -O -K -V${VRBLEVM}  >> $outfile
  fi
  ########### Plot scale Bar ####################
  bartick=$(echo $barrange | awk '{print $1/5}')
  gmt psscale -D2.75i/-0.4i/4i/0.15ih -Ctmpcpt.cpt  -B$bartick/:bar: \
    -O -K -V${VRBLEVM} >> $outfile
  rm tmp* ## clear temporary files
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT NORMAL STRESS CHANGE

if [ "$NSTRESS" -eq 1 ]; then
  echo "...plot Normal Stress Change map..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpcou1
  awk 'NR>3 {print $6}' ${pth2dcfffile} > tmpcou2
  paste -d" " tmpcou1 tmpcou2 > tmpcouall
 
  ################# Plot Coulomb source AnD coastlines only ######################
  gmt xyz2grd tmpcouall -Gtmpgrd $range -I0.05 -V${VRBLEVM}
  gmt makecpt -C$coulombcpt -T-$barrange/$barrange/0.002 -Z -V${VRBLEVM} > tmpcpt.cpt
  gmt grdsample tmpgrd -I4s -Gtmpgrd_sample.grd -V${VRBLEVM}
  gmt grdimage tmpgrd_sample.grd -Ctmpcpt.cpt $proj -Ei -Y8c \
    -Q -K -V${VRBLEVM} > $outfile
  gmt pscoast $range $proj -Df -W0.5,120 -O -K -V${VRBLEVM} >> $outfile 
  gmt psbasemap -R -J -B$frame:."$mtitle": $scale $logogmt_pos \
    -O -K -V${VRBLEVM} >> $outfile
  #  PLOT NOA CATALOGUE FAULTS Ganas et.al, 2013
  if [ "$FAULTS" -eq 1 ]; then
    echo "...plot fault database catalogue..."
    gmt	psxy $pth2faults -R -J -W.5,204/102/0 -O -K -V${VRBLEVM} >> $outfile
  fi
  ########### Plot scale Bar ####################
  bartick=$(echo $barrange | awk '{print $1/5}')
  gmt psscale -D2.75i/-0.4i/4i/0.15ih -Ctmpcpt.cpt  -B$bartick/:bar: \
    -O -K -V${VRBLEVM} >> $outfile
  rm tmp* ## clear temporary files
fi


# //////////////////////////////////////////////////////////////////////////////
# PLOT STRAIN COMPONENT Exx

if [ "$STREXX" -eq 1 ]; then
  echo "...plot Strain Component Exx..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpstr1
  awk 'NR>3 {print $4*1000000}' ${pth2strnfile} > tmpstr2
  paste -d" " tmpstr1 tmpstr2 > tmpstrall
  
  ################# Plot Coulomb source AnD coastlines only ######################
  gmt xyz2grd tmpstrall -Gtmpgrd $range -I0.05 -V${VRBLEVM} 
  gmt makecpt -C$coulombcpt -T-$barrange/$barrange/0.002 -Z -V${VRBLEVM} > tmpcpt.cpt
  gmt grdsample tmpgrd -I4s -Gtmpgrd_sample.grd -V${VRBLEVM} 
  gmt grdimage tmpgrd_sample.grd -Ctmpcpt.cpt $proj -Ei -Y4.5c \
    -Q -K -V${VRBLEVM} > $outfile
  gmt pscoast $range $proj -Df -W0.5,120 -O -K -V${VRBLEVM} >> $outfile 
  gmt psbasemap -R -J -B$frame:."$mtitle": $scale $logogmt_pos \
    -O -K -V${VRBLEVM} >> $outfile
  #  PLOT NOA CATALOGUE FAULTS Ganas et.al, 2013
  if [ "$FAULTS" -eq 1 ]; then
    echo "...plot fault database catalogue..."
    gmt	psxy $pth2faults -R -J -O -K  -W.5,204/102/0 -V${VRBLEVM} >> $outfile
  fi
  #////////// Plot scale Bar \\\\\\\\\\\\\\\\\\\\
  bartick=$(echo $barrange | awk '{print $1/5}')
  gmt psscale -D2.75i/-0.4i/4i/0.15ih -Ctmpcpt.cpt  -B$bartick/:bar: \
    -O -K -V${VRBLEVM} >> $outfile
  rm tmp* ## clear temporary files
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT STRAIN COMPONENT Eyy

if [ "$STREYY" -eq 1 ]; then
  echo "...plot Strain Component Eyy..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpstr1
  awk 'NR>3 {print $5*1000000}' ${pth2strnfile} > tmpstr2
  paste -d" " tmpstr1 tmpstr2 > tmpstrall
  
  ################# Plot Coulomb source AnD coastlines only ######################
  gmt xyz2grd tmpstrall -Gtmpgrd $range -I0.05 -V${VRBLEVM} 
  gmt makecpt -C$coulombcpt -T-$barrange/$barrange/0.002 -Z -V${VRBLEVM} > tmpcpt.cpt
  gmt grdsample tmpgrd -I4s -Gtmpgrd_sample.grd -V${VRBLEVM} 
  gmt grdimage tmpgrd_sample.grd -Ctmpcpt.cpt $proj -Ei -Y4.5c \
    -Q -K -V${VRBLEVM} > $outfile
  gmt pscoast $range $proj -Df -W0.5,120 -O -K -V${VRBLEVM} >> $outfile 
  gmt psbasemap -R -J -B$frame:."$mtitle": $scale $logogmt_pos \
    -O -K -V${VRBLEVM} >> $outfile
  #  PLOT NOA CATALOGUE FAULTS Ganas et.al, 2013
  if [ "$FAULTS" -eq 1 ]; then
    echo "...plot fault database catalogue..."
    gmt	psxy $pth2faults -R -J -W.5,204/102/0 -O -K -V${VRBLEVM} >> $outfile
  fi
  #////////// Plot scale Bar \\\\\\\\\\\\\\\\\\\\
  bartick=$(echo $barrange | awk '{print $1/5}')
  gmt psscale -D2.75i/-0.4i/4i/0.15ih -Ctmpcpt.cpt  -B$bartick/:bar: \
    -O -K -V${VRBLEVM} >> $outfile
  rm tmp* ## clear temporary files
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT STRAIN COMPONENT Ezz

if [ "$STREZZ" -eq 1 ]; then
  echo "...plot Strain Component Ezz..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpstr1
  awk 'NR>3 {print $6*1000000}' ${pth2strnfile} > tmpstr2
  paste -d" " tmpstr1 tmpstr2 > tmpstrall
  
  ################# Plot Coulomb source AnD coastlines only ######################
  gmt xyz2grd tmpstrall -Gtmpgrd $range -I0.05 -V${VRBLEVM} 
  gmt makecpt -C$coulombcpt -T-$barrange/$barrange/0.002 -Z -V${VRBLEVM} > tmpcpt.cpt
  gmt grdsample tmpgrd -I4s -Gtmpgrd_sample.grd -V${VRBLEVM} 
  gmt grdimage tmpgrd_sample.grd -Ctmpcpt.cpt $proj -Ei -Y4.5c \
    -Q -K -V${VRBLEVM} > $outfile
  gmt pscoast $range $proj -Df -W0.5,120 -O -K -V${VRBLEVM} >> $outfile 
  gmt psbasemap -R -J -B$frame:."$mtitle": $scale $logogmt_pos \
    -O -K-V${VRBLEVM} >> $outfile
  #  PLOT NOA CATALOGUE FAULTS Ganas et.al, 2013
  if [ "$FAULTS" -eq 1 ]; then
    echo "...plot fault database catalogue..."
    gmt	psxy $pth2faults -R -J -W.5,204/102/0 -O -K -V${VRBLEVM} >> $outfile
  fi
  #////////// Plot scale Bar \\\\\\\\\\\\\\\\\\\\
  bartick=$(echo $barrange | awk '{print $1/5}')
  gmt psscale -D2.75i/-0.4i/4i/0.15ih -Ctmpcpt.cpt  -B$bartick/:bar: \
    -O -K -V${VRBLEVM} >> $outfile
  rm tmp* ## clear temporary files
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT STRAIN COMPONENT Eyz

if [ "$STREYZ" -eq 1 ]; then
  echo "...plot Strain Component Eyz..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpstr1
  awk 'NR>3 {print $7*1000000}' ${pth2strnfile} > tmpstr2
  paste -d" " tmpstr1 tmpstr2 > tmpstrall
  
  ################# Plot Coulomb source AnD coastlines only ######################
  gmt xyz2grd tmpstrall -Gtmpgrd $range -I0.05 -V${VRBLEVM} 
  gmt makecpt -C$coulombcpt -T-$barrange/$barrange/0.002 -Z -V${VRBLEVM} > tmpcpt.cpt
  gmt grdsample tmpgrd -I4s -Gtmpgrd_sample.grd -V${VRBLEVM} 
  gmt grdimage tmpgrd_sample.grd -Ctmpcpt.cpt $proj  -K -Ei -Q -Y4.5c -V${VRBLEVM} > $outfile
  gmt pscoast $range $proj -Df -W0.5,120 -O -K -V${VRBLEVM} >> $outfile 
  gmt psbasemap -R -J -O -K -B$frame:."$mtitle": --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p $logogmt_pos -V${VRBLEVM} >> $outfile
  #  PLOT NOA CATALOGUE FAULTS Ganas et.al, 2013
  if [ "$FAULTS" -eq 1 ]
  then
    echo "...plot fault database catalogue..."
    gmt	psxy $pth2faults -R -J -O -K  -W.5,204/102/0 -V${VRBLEVM} >> $outfile
  fi
  #////////// Plot scale Bar \\\\\\\\\\\\\\\\\\\\
  bartick=$(echo $barrange | awk '{print $1/5}')
  gmt psscale -D2.75i/-0.4i/4i/0.15ih -Ctmpcpt.cpt  -B$bartick/:bar: -O -K -V${VRBLEVM} >> $outfile
  rm tmpstr1 tmpstr2 tmpstrall tmpgrd tmpgrd_sample.grd tmpcpt.cpt ## clear temporary files
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT STRAIN COMPONENT Exz

if [ "$STREXZ" -eq 1 ]; then
  echo "...plot Strain Component Exz..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpstr1
  awk 'NR>3 {print $8*1000000}' ${pth2strnfile} > tmpstr2
  paste -d" " tmpstr1 tmpstr2 > tmpstrall
  
  ################# Plot Coulomb source AnD coastlines only ######################
  gmt xyz2grd tmpstrall -Gtmpgrd $range -I0.05 -V${VRBLEVM} 
  gmt makecpt -C$coulombcpt -T-$barrange/$barrange/0.002 -Z -V${VRBLEVM} > tmpcpt.cpt
  gmt grdsample tmpgrd -I4s -Gtmpgrd_sample.grd -V${VRBLEVM} 
  gmt grdimage tmpgrd_sample.grd -Ctmpcpt.cpt $proj -Ei -Y4.5c \
    -Q -K -V${VRBLEVM} > $outfile
  gmt pscoast $range $proj -Df -W0.5,120 -O -K -V${VRBLEVM} >> $outfile 
  gmt psbasemap -R -J -B$frame:."$mtitle": $scale $logogmt_pos \
    -O -K -V${VRBLEVM} >> $outfile
  #  PLOT NOA CATALOGUE FAULTS Ganas et.al, 2013
  if [ "$FAULTS" -eq 1 ]; then
    echo "...plot fault database catalogue..."
    gmt	psxy $pth2faults -R -J -W.5,204/102/0 -O -K -V${VRBLEVM} >> $outfile
  fi
  #////////// Plot scale Bar \\\\\\\\\\\\\\\\\\\\
  bartick=$(echo $barrange | awk '{print $1/5}')
  gmt psscale -D2.75i/-0.4i/4i/0.15ih -Ctmpcpt.cpt  -B$bartick/:bar: \
    -O -K -V${VRBLEVM} >> $outfile
  rm tmp* ## clear temporary files
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT STRAIN COMPONENT Exy

if [ "$STREXY" -eq 1 ]; then
  echo "...plot Strain Component Exy..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpstr1
  awk 'NR>3 {print $9*1000000}' ${pth2strnfile} > tmpstr2
  paste -d" " tmpstr1 tmpstr2 > tmpstrall
  
  ################# Plot Coulomb source AnD coastlines only ######################
  gmt xyz2grd tmpstrall -Gtmpgrd $range -I0.05 -V${VRBLEVM} 
  gmt makecpt -C$coulombcpt -T-$barrange/$barrange/0.002 -Z -V${VRBLEVM} > tmpcpt.cpt
  gmt grdsample tmpgrd -I4s -Gtmpgrd_sample.grd -V${VRBLEVM} 
  gmt grdimage tmpgrd_sample.grd -Ctmpcpt.cpt $proj -Ei -Y4.5c \
    -Q -K -V${VRBLEVM} > $outfile
  gmt pscoast $range $proj -Df -W0.5,120 -O -K -V${VRBLEVM} >> $outfile 
  gmt psbasemap -R -J -B$frame:."$mtitle": $scale $logogmt_pos \
    -O -K -V${VRBLEVM} >> $outfile
  #  PLOT NOA CATALOGUE FAULTS Ganas et.al, 2013
  if [ "$FAULTS" -eq 1 ]; then
    echo "...plot fault database catalogue..."
    gmt	psxy $pth2faults -R -J -W.5,204/102/0 -O -K -V${VRBLEVM} >> $outfile
  fi
  #////////// Plot scale Bar \\\\\\\\\\\\\\\\\\\\
  bartick=$(echo $barrange | awk '{print $1/5}')
  gmt psscale -D2.75i/-0.4i/4i/0.15ih -Ctmpcpt.cpt  -B$bartick/:bar: \
    -O -K -V${VRBLEVM} >> $outfile
  rm tmp* ## clear temporary files
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT DILATATION STRAIN

if [ "$STRDIL" -eq 1 ]; then
  echo "...plot Dilatation (Exx + Eyy + Ezz)..."
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${pth2coutfile} > tmpstr1
  awk 'NR>3 {print $10*1000000}' ${pth2strnfile} > tmpstr2
  paste -d" " tmpstr1 tmpstr2 > tmpstrall
  
  ################# Plot Coulomb source AnD coastlines only ######################
  gmt xyz2grd tmpstrall -Gtmpgrd $range -I0.05 -V${VRBLEVM} 
  gmt makecpt -C$coulombcpt -T-$barrange/$barrange/0.002 -Z -V${VRBLEVM} > tmpcpt.cpt
  gmt grdsample tmpgrd -I4s -Gtmpgrd_sample.grd -V${VRBLEVM} 
  gmt grdimage tmpgrd_sample.grd -Ctmpcpt.cpt $proj -Ei -Y4.5c \
    -Q -K -V${VRBLEVM} > $outfile
  gmt pscoast $range $proj -Df -W0.5,120 -O -K -V${VRBLEVM} >> $outfile 
  gmt psbasemap -R -J -B$frame:."$mtitle": $scale $logogmt_pos \
    -O -K -V${VRBLEVM} >> $outfile
  #  PLOT NOA CATALOGUE FAULTS Ganas et.al, 2013
  if [ "$FAULTS" -eq 1 ]; then
    echo "...plot fault database catalogue..."
    gmt	psxy $pth2faults -R -J -W.5,204/102/0 -O -K -V${VRBLEVM} >> $outfile
  fi
  #////////// Plot scale Bar \\\\\\\\\\\\\\\\\\\\
  bartick=$(echo $barrange | awk '{print $1/5}')
  gmt psscale -D2.75i/-0.4i/4i/0.15ih -Ctmpcpt.cpt -B$bartick/:bar: \
    -O -K -V${VRBLEVM} >> $outfile
  rm tmp* ## clear temporary files
fi


# //////////////////////////////////////////////////////////////////////////////
# PLOT gmt_fault_map_proj.dat 

if [ "$FPROJ" -eq 1 ]; then
  echo "...plot fault projection..."
  gmt psxy ${pth2fprojfile} -Jm -R -W1,red -O -K -V${VRBLEVM} >> $outfile
fi
if [ "$FSURF" -eq 1 ]; then
  echo "...plot fault surface..."
  gmt psxy ${pth2fsurffile} -Jm -R -W0.5,green -O -K -V${VRBLEVM} >> $outfile
fi
if [ "$FDEP" -eq 1 ]; then
  echo "...plot depth calculation..."
  gmt psxy ${pth2fdepfile} -Jm -R -W0.5,black -O -K -V${VRBLEVM} >> $outfile
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT earthquakes distributions 

if [ "$EQDIST" -eq 1 ]; then
  echo "...plot earthquakes distribution..."
  awk 'NR>2 {print $8, $7}' $pth2eqdistfile \
  | gmt psxy -Jm -R -Sc0.1c -Gblack -O -K -V${VRBLEVM} >> $outfile
fi 



# //////////////////////////////////////////////////////////////////////////////
# PLOT CMT of earthquakes  

if [ "$CMT" -eq 1 ]; then
  echo "...plot Centroid Moment Tensor file..."
  awk '{print $1,$2}' $inpcmt \
  | gmt psxy -Jm -R -Sa0.3c -Gred -O -K -V${VRBLEVM} >> $outfile
# gmt psmeca $inpcmt $range -Jm -Sc0.7/0 -CP0.05  -O -P -K>> $outfile
  awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9}' $inpcmt \
  | gmt psmeca -R -Jm -Sa0.4 -CP0.05 -K -O -V${VRBLEVM} >> $outfile
fi


# //////////////////////////////////////////////////////////////////////////////
# PLOT GPS OBSERVED AND MODELED OKADA SURF DESPLACEMENTS

scdhmlatl=$sclat
scdhmlonl=$sclon

if [ "$DGPSHM" -eq 1 ]; then
  echo "...plot Horizontal Modeled Displacements..."
  awk -F, 'NR>2 {print $1,$2,$6,$7,0,0,0}' $pth2gpsdfile \
  | gmt psvelo -R -Jm -Se${dhscale}/0.95/0 -W2p,blue -A10p+e -Gblue \
    -O -K -L -V >> $outfile 

  scdhmlat=$(echo print $sclat + .05 | python)
  scdhmlon=$sclon
  DEBUG echo "[DEBUG:${LINENO}] scdhmlat = ${scdhmlat}  , scdhmlon = ${scdhmlon}"
  scdhmlatl=$(echo print $scdhmlat + .1 | python)
  scdhmlonl=$scdhmlon
  DEBUG echo "[DEBUG:${LINENO}] scdhmlatl = ${scdhmlatl}, scdhmlonl = ${scdhmlonl}"

  tmpmagn=$(echo print $dhscmagn/1000.  | python )
  DEBUG echo "[DEBUG:${LINENO}]" $tmpmagn

  echo "$scdhmlon $scdhmlat $tmpmagn 0 0 0 0 $dhscmagn mm" \
  | gmt psvelo -R -Jm -Se${dhscale}/0.95/10 -W2p,blue -A10p+e -Gblue \
    -L -O -K -V${VRBLEVM} >> $outfile
  echo "$scdhmlonl $scdhmlatl  9 0 1 CT Modeled" \
  | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V${VRBLEVM} >> $outfile
fi

if [ "$DGPSHO" -eq 1 ]; then
  echo "...plot Horizontal Observed Displacements..."
  awk -F, 'NR>2 {print $1,$2,$3,$4,0,0,0}' $pth2gpsdfile \
  | gmt psvelo -R -Jm -Se${dhscale}/0.95/0 -W2p,red -A10p+e -Gred \
    -L -O -K -V${VRBLEVM} >> $outfile

  scdholat=$(echo print $scdhmlatl + .05 | python)
  scdholon=$scdhmlonl
  DEBUG echo "[DEBUG:${LINENO}] scdholat = ${scdholat}, scdholon = ${scdholon}"
  scdholatl=$(echo print $scdholat + .1 | python)
  scdholonl=$scdholon
  DEBUG echo "[DEBUG:${LINENO}] scvholatl = ${scvholatl}, scvholonl = ${scvholonl}"

  tmpmagn=$(echo print $dhscmagn/1000.  | python )
  DEBUG echo "[DEBUG:${LINENO}]" $tmpmagn
  echo "$scdholon $scdholat $tmpmagn 0 0 0 0 $dhscmagn mm" \
  | gmt psvelo -R -Jm -Se${dhscale}/0.95/10 -W2p,red -A10p+e -Gred \
    -L -O -K -V${VRBLEVM} >> $outfile
  echo "$scdholonl $scdholatl  9 0 1 CT Observed" \
  | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V${VRBLEVM} >> $outfile
fi

scdvmlat=$(echo print $sclat + .25 | python)
scdvmlonl=$sclon


if [ "$DGPSVM" -eq 1 ]; then
  echo "...plot Vertical Modeled Displacements..."
  awk -F, 'NR>2 {if ($8<0) print $1,$2,0,$8,0,0,0}'  $pth2gpsdfile \
  | gmt psvelo -R -Jm -Se${dvscale}/0.95/0 -W2p,blue -A10p+e -Gblue \
    -L -O -K -V${VRBLEVM} >> $outfile
  awk -F, 'NR>2 {if ($8>=0) print $1,$2,0,$8,0,0,0}' $pth2gpsdfile \
  | gmt psvelo -R -Jm -Se${dvscale}/0.95/0 -W2p,red -A10p+e -Gred \
    -L -O -K -V${VRBLEVM} >> $outfile
  
  scdvmlon=$(echo print $sclon - 0.04 | python)
  DEBUG echo "[DEBUG:${LINENO}] scdvmlat = ${scdvmlat}, scdvmlon = ${scdvmlon}"
  scdvmlatl=$scdvmlat
  scdvmlonl=$(echo print $scdvmlon - 0.06 | python)
  DEBUG echo "[DEBUG:${LINENO}] scdvmlatl = ${scdvmlatl}, scdvmlonl = ${scdvmlonl}"

  tmpmagn=$(echo print $dvscmagn/1000.  | python )
  DEBUG echo "[DEBUG:${LINENO}]"  $tmpmagn
  echo "$scdvmlon $scdvmlat 0 -$tmpmagn 0 0 0 $dvscmagn mm" \
  | gmt psvelo -R -Jm -Se${dhscale}/0.95/0 -W2p,blue -A10p+e -Gblue \
    -L -O -K -V${VRBLEVM} >> $outfile
  echo "$scdvmlon $scdvmlat 0 $tmpmagn 0 0 0 $dvscmagn mm" \
  | gmt psvelo -R -Jm -Se${dhscale}/0.95/0 -W2p,red -A10p+e -Gred \
  -L -O -K -V${VRBLEVM} >> $outfile
  echo "$scdvmlonl $scdvmlatl 9,1,black 181 CM Modeled" \
  | gmt pstext -R -Jm -Dj0c/0c -F+f+a+j -A -O -K -V${VRBLEVM} >> $outfile
fi


if [ "$DGPSVO" -eq 1 ]; then
  echo "...plot Vertical Observed Displacements..."
  DEBUG echo "[DEBUG:${LINENO}] -X.08c add in mext line"
  awk -F, 'NR>2 {if ($5<0) print $1,$2,0,$5,0,0,0}'  $pth2gpsdfile \
  | gmt psvelo -R -Jm -Se${dvscale}/0.95/0 -W2p,0/255/0 -G0/255/0 -X.08c \
    -L -O -K -V${VRBLEVM} >> $outfile
  awk -F, 'NR>2 {if ($5>=0) print $1,$2,0,$5,0,0,0}' $pth2gpsdfile \
  | gmt psvelo -R -Jm -Se${dvscale}/0.95/0 -W2p,255/215/0 -A10p+e -G255/215/0 \
    -L -O -K -V${VRBLEVM} >> $outfile

  scdvolat=$scdvmlat
  scdvolon=$(echo print $sclon + 0.1 | python)
  DEBUG echo "[DEBUG:${LINENO}] scdvolat = ${scdvolat}, scdvmlon = ${scdvolon}"
  scdvolatl=$scdvolat
  scdvolonl=$(echo print $scdvolon - 0.06 | python)
  DEBUG echo "[DEBUG:${LINENO}] scdvolatl = ${scdvolatl}, scdvolonl = ${scdvolonl}"

  tmpmagn=$(echo print $dvscmagn/1000.  | python )
  DEBUG echo "[DEBUG:${LINENO}]" $tmpmagn
  echo "$scdvolon $scdvolat 0 -$tmpmagn 0 0 0 $dvscmagn mm" \
  | gmt psvelo -R -Jm -Se${dhscale}/0.95/0 -W2p,0/255/0 -A10p+e -G0/255/0 \
    -L -O -K -V${VRBLEVM} >> $outfile
  echo "$scdvolon $scdvolat 0 $tmpmagn 0 0 $dvscmagn mm" \
  | gmt psvelo -R -Jm -Se${dhscale}/0.95/0 -W2p,255/215/0 -A10p+e -G255/215/0 \
    -L -O -K -V${VRBLEVM} >> $outfile
  echo "$scdvolonl $scdvolatl 9,1,black 181 CM Observed" \
  | gmt pstext -R -Jm -Dj0c/0c -F+f+a+j -A -O -K -V${VRBLEVM} >> $outfile

fi

if [ "$DGPSVM" -eq 1 ] || [ "$DGPSVO" -eq 1 ]; then
  scdvmolat=$(echo print $sclat + .07 | python)
  DEBUG echo "[DEBUG:${LINENO}] -X-.08 added next line"
  echo "$sclon $scdvmolat 9,1,black 0 CM \261 $dvscmagn mm" \
  | gmt pstext -R -Jm -Dj0c/0c -F+f+a+j -X-.08c -O -K -V${VRBLEVM} >> $outfile
fi


# //////////////////////////////////////////////////////////////////////////////
# Plot custom text configured at custom_text file
if [ "$CTEXT" -eq 1 ]; then
  echo "...plot custom text file..."
  grep -v "#" $pth2ctextfile \
  | gmt pstext -R -Jm -Dj0c/0c -F+f+a+j  -O -K -V${VRBLEVM} >> $outfile
fi

# //////////////////////////////////////////////////////////////////////////////
# PLOT CROSS SECTION PROJECTION

if [ "$FCROSS" -eq 1 ]; then
  echo "...plot cross sections..."
  # plot in the main map the cross section line
  if [ $(awk 'NR==1 {print $7}' $pth2crossdat) -eq 2 ]; then
    DEBUG echo "[DEBUG:${LINENO}] cross test coords true"
    # read coordinates
    start_lon=$(awk 'NR==2 {print $5}' $pth2crossdat)
    start_lat=$(awk 'NR==3 {print $5}' $pth2crossdat)
    finish_lon=$(awk 'NR==4 {print $5}' $pth2crossdat)
    finish_lat=$(awk 'NR==5 {print $5}' $pth2crossdat)
    DEBUG echo "[DEBUG:${LINENO}] $start_lon $start_lat $finish_lon $finish_lat"
    # plot line
    echo "$start_lon $start_lat" > tmpcrossline
    echo "$finish_lon $finish_lat" >> tmpcrossline
    gmt psxy tmpcrossline -Jm -R -W1,black -S~D50k:+sc.2 \
      -O -K -V${VRBLEVM} >> $outfile
    echo "$start_lon $start_lat 9,1,black 90 RM A" \
    | gmt pstext -R -Jm -Dj.1c/0.1c -F+f+a+j -A -O -K -V${VRBLEVM} >> $outfile
    echo "$finish_lon $finish_lat 9,1,black 90 LM B" \
    | gmt pstext -R -Jm -Dj.1c/0.1c -F+f+a+j -A -O -K -V${VRBLEVM} >> $outfile
  else
    echo "[ERROR] Cross coordinates must be latlon at dat file."
    echo "        Cross line will not plotted"
    echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
    exit 1
  fi
  
  # make file to plot cross sections
  awk 'NR>3' $pth2crossdcf > tmpcrossdcf
  tmpstartx=$(awk 'NR==4 {print $1}' tmpcrossdcf)
  DEBUG echo "[DEBUG:${LINENO}] start x " $tmpstartx
  tmpstarty=$(awk 'NR==4 {print $2}' tmpcrossdcf)
  DEBUG echo "[DEBUG:${LINENO}] start y " $tmpstarty
  # make proj file
  if [ "$CSTRESS" -eq 1 ];  then
    awk 'NR>3 {print sqrt(($1 - '$tmpstartx')^2 + ($2 - '$tmpstarty')^2), $3, $4}' \
      $pth2crossdcf > tmpcrossdcf2
  elif [ "$SSTRESS" -eq 1 ]; then
    awk 'NR>3 {print sqrt(($1 - '$tmpstartx')^2 + ($2 - '$tmpstarty')^2), $3, $5}' \
      $pth2crossdcf > tmpcrossdcf2
  elif [ "$NSTRESS" -eq 1 ]; then
    awk 'NR>3 {print sqrt(($1 - '$tmpstartx')^2 + ($2 - '$tmpstarty')^2), $3, $6}' \
      $pth2crossdcf > tmpcrossdcf2
  fi
  
  # Fault top-bottom parameters
  fault_top=$(awk 'NR==14 {print $10}' $pth2inpfile)
  DEBUG echo "[DEBUG:${LINENO}] fault top= "$fault_top
  fault_bot=$(awk 'NR==14 {print $11}' $pth2inpfile)
  DEBUG echo "[DEBUG:${LINENO}] fault bot= "$fault_bot

  # fault across line
  fault_west=$(gmt spatial tmpcrossline $pth2fprojfile -Fl -Ie \
  | awk 'NR==1 {print $1, $2}' \
  | gmt mapproject -R -Jm -G${start_lon}/${start_lat}/k \
  | awk 'NR==1 {print $3}')
  DEBUG echo "[DEBUG:${LINENO}] fault west= "$fault_west
  fault_east=$(gmt spatial tmpcrossline $pth2fprojfile -Fl -Ie \
  | awk 'NR==2 {print $1, $2}' \
  | gmt mapproject -R -Jm -G${start_lon}/${start_lat}/k \
  | awk 'NR==1 {print $3}')
  DEBUG echo "[DEBUG:${LINENO}] fault_east= "$fault_east
  fault_surf=$(gmt spatial tmpcrossline $pth2fsurffile -Fl -Ie \
  | awk 'NR==2 {print $1, $2}' \
  | gmt mapproject -R -Jm -G${start_lon}/${start_lat}/k \
  | awk 'NR==1 {print $3}')
  DEBUG echo "[DEBUG:${LINENO}] fault_surf= "$fault_surf
  
  # create range for projection
  west=$(awk 'NR==1 {print $1}' tmpcrossdcf2)
  east=$(awk 'END {print $1}' tmpcrossdcf2)
  zmin=0
  zmax=$(awk 'NR==7 {print $5}' $pth2crossdat)
  
  rangep="-R$west/$east/$zmin/$zmax"
  DEBUG echo "[DEBUG:${LINENO}]  proj range: "$rangep
  projp=-JX14.8/-4
  tick=-B50:Distance\(km\):/5:Depth\(km\):WSen
  
  gmt psbasemap $rangep $projp -O -K $tick  -V${VRBLEVM} -Ya-6.5c >> $outfile

  gmt xyz2grd tmpcrossdcf2 -Gtmpgrd $rangep -I2 -V${VRBLEVM} 
  gmt makecpt -C$coulombcpt -T-$barrange/$barrange/0.002 -Z -V${VRBLEVM} > tmpcpt.cpt
  gmt grdsample tmpgrd -I.05 -Gtmpgrd_sample.grd -V${VRBLEVM} 
  gmt grdimage tmpgrd_sample.grd -Ctmpcpt.cpt -J -Ya-6.5c -Ei \
    -Q -O -K -V${VRBLEVM} >> $outfile
  
  # Plot A-B in projection
  echo "$west $zmin  9,1,black 0 LT A" \
  | gmt pstext -R -J -Dj0.1c/0.1c -F+f+a+j -Ya-6.5c -O -K -V${VRBLEVM} >> $outfile
  echo "$east $zmin  9,1,black 0 RT B" \
  | gmt pstext -R -J -Dj0.1c/0.1c -F+f+a+j -Ya-6.5c -O -K -V${VRBLEVM} >> $outfile

  # make pject cordinates for the source fault
  tmp_fault=($fault_surf $fault_west $fault_east)
  if [[ $(echo "if (${fault_surf} > ${fault_east}) 1 else 0" | bc) -eq 1 ]]; then
    IFS=$'\n' tmp_faultsort=($(sort <<<"${tmp_fault[*]}"))
    DEBUG echo "[DEBUG:${LINENO}] sort1 "${tmp_faultsort[*]}
  else
    IFS=$'\n' tmp_faultsort=($(sort -r <<<"${tmp_fault[*]}"))
    DEBUG echo "[DEBUG:${LINENO}] sort2 "${tmp_faultsort[*]}
  fi

  # Plot fault in cross section part
  echo "${tmp_faultsort[1]} $fault_top" > tmpasd
  echo "${tmp_faultsort[0]} $fault_bot" >> tmpasd
  gmt psxy tmpasd -J -R -W1,black -Ya-6.5c -O -K -V${VRBLEVM} >> $outfile
  echo "${tmp_faultsort[2]} 0" > tmpasd
  echo "${tmp_faultsort[1]} $fault_top" >> tmpasd
  gmt psxy tmpasd -J -R -W.2,black,- -Ya-6.5c -O -K -V${VRBLEVM} >> $outfile

  # Plot calculation depth dashed line
  echo "$west $CALC_DEPTH" >tmpdep
  echo "$east $CALC_DEPTH" >>tmpdep
  gmt psxy tmpdep -R -J -W.15,black,- -Ya-6.5c -O -K -V${VRBLEVM} >>$outfile

  # remove templorary files
  rm tmp*
fi




# //////////////////////////////////////////////////////////////////////////////
# Plot custom logo configured at default-param

if [ "$LOGOCUS" -eq 1 ]; then
  echo "...add custom logo..."
  gmt psimage $pth2logo $logocus_pos -F0.4 -O -K -V${VRBLEVM} >>$outfile
fi

# //////////////////////////////////////////////////////////////////////////////
# FINAL SECTION
#################--- Close ps output file ----##################################
echo "909 909" | gmt psxy -Sc.1 -Jm -R  -W1,red -O -V${VRBLEVM} >> $outfile

#################--- Convert to other format ----###############################
if [ "$OUTJPG" -eq 1 ]
then
  echo "...adjust and convert to JPEG format..."
#   gs -sDEVICE=jpeg -dJPEGQ=100 -dNOPAUSE -dBATCH -dSAFER -r300 -sOutputFile=test.jpg $outfile
  gmt psconvert $outfile -A0.2c -Tj -V${VRBLEVM} 
fi
if [ "$OUTPNG" -eq 1 ]
then
  echo "...adjust and convert to PNG format..."
  gmt psconvert $outfile -A0.2c -TG -V${VRBLEVM} 	
fi
if [ "$OUTEPS" -eq 1 ]
then
  echo "...adjust and convert to EPS format..."
  gmt psconvert $outfile -A0.2c -Te -V${VRBLEVM} 
fi
if [ "$OUTPDF" -eq 1 ]
then
  echo "...adjust and convert to PDF format..."
  gmt psconvert $outfile -A0.2c -Tf -V${VRBLEVM} 
fi

# Print exit status
echo "[STATUS] Finished. Exit status: $?"