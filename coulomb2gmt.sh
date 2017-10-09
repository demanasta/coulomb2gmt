#!/bin/bash
#plot Coulomb Stress change to GMT maps
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
#    contact               : Demitris Anastasiou (dganastasiou@gmail.com)
#    ----------------------------------------------------------------------
# ==============================================================================
# //////////////////////////////////////////////////////////////////////////////
# HELP FUNCTION
function help {
  echo "/******************************************************************************/"
  echo " Program Name : coulomb2gmt.sh"
  echo " Version : v-1.0-beta*"
  echo " Purpose : Plot Coulomb Stress change results"
  echo " Usage   : coulomb2gmt.sh  <inputfile> <input data> | options | "
  echo " Switches: "
  echo "/*** PLOT COULOMB OUTPUTS *****************************************************/"
  echo "           -r [:=region] set different region minlon maxlon minlat maxlat prjscale"
  echo "           -cstress [:=Coulomb Stress] "
  echo "           -sstress [:=Shear Stress] "
  echo "           -nstress [:=Normal strain] "
  echo "           -dilstrain [:= Dilatation strain] "
  echo "           -fproj [:=Fault projection] "
  echo "           -fsurf [:=Fault surface] "
  echo "           -fdep [:=Fault calculation depth] "
  echo "           -fcross [:=plot cross section projections] "
  echo "           -cmt [:=Plot central moment tensors] insert file "
  echo ""
  echo "           -terobs <file> scale excl plot terrestrial proc"
  echo "           -pscleg : plot scale legent for shear strain  temp"
  echo ""
  echo "/*** PLOT OKADA85 *************************************************************/"
  echo "           -dgpso :observed gps displacements"
  echo "           -dgpsc :calculated deisplacements on gps site"
  echo "           -dvert :plot vertical displacements"
  echo "           -dsc :scale for displacements"
  echo ""
  echo "/*** PLOT STRAINS **********************************************/"
  echo "           -str (gmt_file)[:= strains] Plot strain rates "
  echo "           -strsc [:=strain scale]"
  echo ""
  echo "/*** OTHER OPTIONS ************************************************************/"
  echo "           -topo [:=topography] plot dem file if exist "
  echo "           -o [:= output] name of output files"
  echo "           -l [:=labels] plot labels"
  echo "           -leg [:=legend] insert legends"
  echo "           -jpg [:=convert] eps file to jpg"
  echo "           -h [:= help] help menu"
  echo ""
  echo " Exit Status:    1 -> help message or error"
  echo " Exit Status: >= 0 -> sucesseful exit"
  echo ""
  echo "/******************************************************************************/"
  exit 1
}

# //////////////////////////////////////////////////////////////////////////////
# GMT parameters
#gmtset MAP_FRAME_TYPE fancy
gmt gmtset PS_PAGE_ORIENTATION portrait
gmt gmtset FONT_ANNOT_PRIMARY 8 FONT_LABEL 8 MAP_FRAME_WIDTH 0.10c FONT_TITLE 15p
gmt gmtset PS_MEDIA 19cx22c

# //////////////////////////////////////////////////////////////////////////////
# range and other parameneters
dscale=100

# //////////////////////////////////////////////////////////////////////////////
# Pre-defined parameters for bash script switches
TOPOGRAPHY=0
LABELS=0
OUTFILES=0
OUTJPG=0
LEGEND=0
RANGE=0
CSTRESS=0
SSTRESS=0
NSTRESS=0
DILSTRAIN=0

TEROBS=0
TEROBS_EXCL=0
PSCLEG=0

FPROJ=0
FSURF=0
FDEP=0
FCROSS=0
CMT=0
DGPSO=0
DGPSC=0
DVERT=0

STRAIN=0
STRSC=50

##//////////////////check default param file ////////////////////////////////////
if [ ! -f "default-param" ]
then
  echo "default-param file does not exist"
  exit 1
else
  source default-param
fi

# //////////////////////////////////////////////////////////////////////////////
# GET COMMAND LINE ARGUMENTS
if [ "$#" == "0" ]
then
  help
elif [ "$#" == "1" ]
then
  if [ "$1" == "-h" ]
  then
    help
  else
    echo "***** not enough input arguments ******"
    echo " use -h to present help doc"
    exit 1
  fi
elif [ -f ${pth2inpdir}/${1}.inp ];
then
  inputfile=${1}
  inputdata=${2}
  echo "input file exist"
  echo $inputfile  $inputdata
while [ $# -gt 2 ]
do
  case "$3" in
    -r)
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
	shift
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
    -dilstrain)
	DILSTRAIN=1
	shift
	;;
		-terobs)
			TEROBS=1
			terobs_file=$4
			TEROBS_STRSC=$5
			TEROBS_EXCL=$6
			shift
			shift
			shift
			shift
			;;
		-pscleg)
			PSCLEG=$4
			shift
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
		-cmt)
			echo "///////BUG--if you don't use input file at -cmt switch--you lose next option!!!xaxa\\\\\\\\\\\\"
			if [ -f ${4} ];
			then
				CMT=1
				inpcmt=${4}
			else
				echo "CMT file does not exist!CMT wil not plot"
			fi
			shift
			shift
                        ;;
		-dgpso)
			DGPSO=1
			shift
			;;
		-dgpsc)
			DGPSC=1
			shift
			;;
		-dvert)
			DVERT=1
			shift
			;;
		-str)
			pth2inptf=../../GeoToolbox/output
			pth2work=${pth2inptf}/${4}
			pth2comp=${pth2inptf}/${4}.comp
			pth2ext=${pth2inptf}/${4}.ext
			pth2strpar=${pth2inptf}/${4}par.str
			STRAIN=1
			shift
			shift
			;;
		-strsc)
			STRSC=$4
			shift
			shift
			;;
		-dsc)
			dscale=${4}
			shift
			shift
			;;
    -topo)
	TOPOGRAPHY=1
	shift
	;;
    -o)
	OUTFILES=1
	outfile=${4}.eps
	out_jpg=${4}.jpg
	shift
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
    -jpg)
	OUTJPG=1
	shift
	;;
    -h)
	help
	;;
    esac
done
  else
    echo " ************* File does not exist! use corret input file *********"
    help
fi

# //////////////////////////////////////////////////////////////////////////////
# Pre-defined parameters for GMT
if [ "$OUTFILES" -eq 0 ]
then
  outfile=${inputdata}.eps
  out_jpg=${inputdata}.jpg
fi

pth2inpfile=${pth2inpdir}/${inputfile}.inp
pth2gpsfile=${inputdata}.disp


if [ "$RANGE" -eq 0 ]
then
  minlon=$(grep "min. lon" ${pth2inpfile} | awk '{print $6}')
  maxlon=$(grep "max. lon" ${pth2inpfile} | awk '{print $6}')
  minlat=$(grep "min. lat" ${pth2inpfile} | awk '{print $6}')
  maxlat=$(grep "max. lat" ${pth2inpfile} | awk '{print $6}')
  prjscale=1500000 ##DEF 1000000
fi

sclat=$(echo print $minlat + 0.08 | python)
sclon=$(echo print $maxlon - 0.22 | python)
scale=-Lf${sclon}/${sclat}/36:24/20+l+jr
range=-R$minlon/$maxlon/$minlat/$maxlat
proj=-Jm$minlon/$minlat/1:$prjscale
	
if [ "$CSTRESS" -eq 0 ]
then
  ################## Plot coastlines only ######################
  gmt pscoast $range $proj  -Df -W0.5/10 -G240  -UBL/4c/-2c/"DSO-HGL/NTUA" -K  -Y4.5c> $outfile
  gmt psbasemap -R -J -O -K -B$frame:."Coulomb outputs plot": --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p >> $outfile
fi
if [ "$TOPOGRAPHY" -eq 1 ]
then
  # ####################### TOPOGRAPHY ###########################
  # bathymetry
  gmt makecpt -Cgebco.cpt -T-7000/0/50 -Z > $bathcpt
  gmt grdimage $inputTopoB $range $proj -C$bathcpt -K > $outfile
  gmt pscoast $proj -P $range -Df -Gc -K -O >> $outfile
  # land
  gmt makecpt -Cgray.cpt -T-6000/1800/50 -Z > $landcpt
  gmt grdimage $inputTopoL $range $proj -C$landcpt  -K -O >> $outfile
  gmt pscoast -R -J -O -K -Q >> $outfile
  #------- coastline -------------------------------------------
  gmt psbasemap -R -J -O -K -B$frame:."$maptitle":  $scale >> $outfile
  gmt pscoast -J -R -Df -W0.25p,black -K  -O -U$logo_pos >> $outfile
fi

#///////// PLOT COULOMB STRESS CHANGE
if [ "$CSTRESS" -eq 1 ]
then
  ################# Plot Coulomb source AnD coastlines only ######################
  gmt xyz2grd ${inputdata}-coulomb_out.dat -Gtest $range -I0.05
  gmt makecpt -C$coulombcpt -T-1/1/0.002 -Z > testcpt.cpt
  gmt grdsample test -I4s -Gtest_sample.grd
  grdgradient test_sample.grd -Nt -A90  -Gtest_i
  gmt grdimage test_sample.grd -Ctestcpt.cpt $proj  -K -Ei -Q -Y4.5c> $outfile
  rm test test_i test_sample.grd test.cpt
  gmt pscoast $range $proj -Df -W0.5,120 -O -K >> $outfile 
  gmt psbasemap -R -J -O -K -B$frame:."Plot Coulomb Stress Change": --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p>> $outfile
  
  #////////// Plot scale Bar \\\\\\\\\\\\\\\\\\\\
  gmt psscale -D2.75i/-0.4i/4i/0.15ih -Ctestcpt  -B0.2/:bar: -O -K >> $outfile
fi

#///////// PLOT SHEAR STRESS CHANGE
if [ "$SSTRESS" -eq 1 ]
then
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${inputdata}-coulomb_out.dat > tmp1
  awk 'NR>3{print $5}' ../output_files/${inputdata}-dcff.cou > tmp2
  paste -d" " tmp1 tmp2 >tmpall
  ################# Plot Coulomb source AnD coastlines only ######################
  gmt xyz2grd tmpall -Gtest $range -I0.05

  gmt makecpt -C$coulombcpt -T-1/1/0.002 -Z > testcpt.cpt
  gmt grdsample test -I4s -Gtest_sample.grd
  #grdgradient test_sample.grd -Nt -A90  -Gtest_i
  gmt grdimage test_sample.grd -Ctestcpt.cpt $proj  -K -Ei -Q -Y4.5c> $outfile
  rm test test_i test_sample.grd 
  gmt pscoast $range $proj -Df -W0.5,120 -O -K >> $outfile 
  gmt psbasemap -R -J -O -K -B$frame:."Plot Shear Stress Change": --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p>> $outfile

  #////////// Plot scale Bar \\\\\\\\\\\\\\\\\\\\
  gmt psscale -D2.75i/-0.4i/4i/0.15ih -Ctestcpt.cpt  -B0.2/:bar: -O -K >> $outfile
  rm tmp1 tmp2 tmpall testcpt.cpt
fi

#///////// PLOT NORMAL STRESS CHANGE
if [ "$NSTRESS" -eq 1 ]
then
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${inputdata}-coulomb_out.dat > tmp1
  awk 'NR>3 {print $6}' ../output_files/${inputdata}-dcff.cou > tmp2
  paste -d" " tmp1 tmp2 >tmpall
  ################# Plot Coulomb source AnD coastlines only ######################
  gmt xyz2grd tmpall -Gtest $range -I0.05
  
  gmt makecpt -C$coulombcpt -T-1/1/0.002 -Z > testcpt.cpt
  gmt grdsample test -I4s -Gtest_sample.grd
  # grdgradient test_sample.grd -Nt -A90  -Gtest_i
  gmt grdimage test_sample.grd -Ctestcpt.cpt $proj  -K -Ei -Q -Y4.5c> $outfile
  rm test test_i test_sample.grd
  gmt pscoast $range $proj -Df -W0.5,120 -O -K >> $outfile 
  gmt psbasemap -R -J -O -K -B$frame:."Plot Normal Stress Change": --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p>> $outfile

  #////////// Plot scale Bar \\\\\\\\\\\\\\\\\\\\
  gmt psscale -D2.75i/-0.4i/4i/0.15ih -Ctestcpt  -B0.2/:bar: -O -K >> $outfile
  rm tmp1 tmp2 tmpall testcpt.cpt
fi

#///////// PLOT DILATATION STRAIN
if [ "$DILSTRAIN" -eq 1 ]
then
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${inputdata}-coulomb_out.dat > tmp1
  awk 'NR>3 {print $10*1000000}' ../output_files/${inputdata}_Strain.cou > tmp2
  paste -d" " tmp1 tmp2 >tmpall
  ################# Plot Coulomb source AnD coastlines only ######################
  gmt xyz2grd tmpall -Gtest $range -I0.05

  gmt makecpt -C$coulombcpt -T-1/1/0.002 -Z > testcpt.cpt
  gmt grdsample test -I4s -Gtest_sample.grd
  ##grdgradient test_sample.grd -Nt -A90  -Gtest_i
  gmt grdimage test_sample.grd -Ctestcpt.cpt $proj  -K -Ei -Q -Y4.5c> $outfile
  rm test test_i test_sample.grd
  gmt pscoast $range $proj -Df -W0.5,120 -O -K >> $outfile 
  gmt psbasemap -R -J -O -K -B$frame:."Plot Diletation Strain": --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p>> $outfile

  #////////// Plot scale Bar \\\\\\\\\\\\\\\\\\\\
  gmt psscale -D2.75i/-0.4i/4i/0.15ih -Ctestcpt.cpt  -B0.2/:bar: -O -K >> $outfile
  rm tmp1 tmp2 tmpall testcpt.cpt
fi

#///////// PLOT gmt_fault_map_proj.dat \\\\\\\\\\\\\\\
if [ "$FPROJ" -eq 1 ]
then
  gmt psxy ${inputdata}-gmt_fault_map_proj.dat -Jm -O -R  -W1,red  -K >> $outfile
fi
if [ "$FSURF" -eq 1 ]
then
  gmt psxy ${inputdata}-gmt_fault_surface.dat -Jm -O -R  -W0.4,0  -K >> $outfile
fi
if [ "$FDEP" -eq 1 ]
then
  gmt psxy ${inputdata}-gmt_fault_calc_dep.dat -Jm -O -R -W0.4,black -K >> $outfile
fi


#///////// PLOT CMT of earthquakes  \\\\\\\\\\\\\\\\\\
if [ "$CMT" -eq 1 ]
then
	awk '{print $1,$2}' $inpcmt | psxy -Jm -O -R -Sa0.3c -Gred -K>> $outfile
# 	gmt psmeca $inpcmt $range -Jm -Sc0.7/0 -CP0.05  -O -P -K>> $outfile
	awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9}' $inpcmt | gmt psmeca -R -Jm -Sa0.4 -CP0.05 -K -O -P >> $outfile
fi

#//////// PLOT CROSS SECTIO PROJECTIO \\\\\\\\\\\\\\\\\
if [ "$FCROSS" -eq 1 ]
then
	psxy  ${inputdata}-cross.ll -Jm -O -R -W0.4,blue -K >> $outfile
	awk '{print $1,$2,9,0,1,"RB",$3}' ${inputdata}-cross.ll | pstext -Jm -R -Dj0.1c/0.1c -O -V -K>> $outfile
fi

# # /////// PLOT TRIANGLES FROM HIST DATA \\\\\\\\\\\\\\\\\
# grep ">" ../../triangle/gmt_src/tr_full \
# 	| awk '{print $3, $4, 7, 0, 1, "RM",$2}' >tmp-tr
# # 	gmt psxy tmp-tr -R -J -O -K -Ss0.6c -Gwhite -Wthinnest >> $outfile
# 	gmt pstext tmp-tr -R -J -D-.2/-.2 -O -K -Ggreen>> $outfile
# 	rm tmp-tr
# 
# 	psxy ../../triangle/gmt_src/tr_full  -R -Jm -m -W.5p,102/204/0,7_7_10_7:0 -O -K >> $outfile
	
if [ "$TEROBS" -eq 1 ]
then
	grep ">" ../../triangle/gmt_src/tr_full \
	| awk '{print $3, $4, 5, 0, 1, "RM",$2}' >tmp-tr
# 	gmt psxy tmp-tr -R -J -O -K -Ss0.6c -Gwhite -Wthinnest >> $outfile
	gmt pstext tmp-tr -R -J -D-.2/-.2 -O -K -Ggreen>> $outfile
	rm tmp-tr

	psxy ../../triangle/gmt_src/tr_full  -R -Jm -m -W.5p,102/204/0,7_7_10_7:0 -O -K >> $outfile
fi

#/////// PLOT GPS OBSERVED AND MODELED OKADA SURF DESPLACEMENTS\\\\\\\\
scvlat=$(echo print $sclat + .07 | python)
scvlon=$sclon

if [ "$DGPSC" -eq 1 ]
then
        awk -F, 'NR>2 {print $1,$2,$6,$7,0,0,0}' $pth2gpsfile | psvelo -R -Jm -Se${dscale}/0.95/0 -W2p,blue -A10p+e -Gblue -O -K -L -V >> $outfile
	
# 	echo "$scvlon $scvlat 0.02 0 0 0 0 20 mm" | gmt psvelo -R -Jm -Se${dscale}/0.95/10 -W2p,blue -A10p+e -Gblue -O -L -V -K >> $outfile
	echo "$scvlon $scvlat 0.1 0 0 0 0 100 mm" | gmt psvelo -R -Jm -Se${dscale}/0.95/10 -W2p,blue -A10p+e -Gblue -O -L -V -K >> $outfile
	
# psvelo -R -Jm -Se${dscale}/0.95/10 -W2p,black -A10p+e -Gblack -O -L -V -K <<EOF>> $outfile
# #20.78 37.93 0.02 0 0 0 0 20 mm
# 20.50 37.50 0.02 0 0 0 0 20mm
# EOF
        
        
fi

if [ "$DGPSO" -eq 1 ]
then
	awk -F, 'NR>2 {print $1,$2,$3,$4,0,0,0}' $pth2gpsfile | gmt psvelo -R -Jm -Se${dscale}/0.95/0 -W2p,red -A10p+e -Gred -O -K -L -V >> $outfile
fi

if [ "$DVERT" -eq 1 ]
then
# 	awk -F, 'NR>2 {print $1,$2,0,$8,0,0,0}' $pth2gpsfile | psvelo -R -Jm -Se${dscale}/0.95/0 -W2p,blue -A10p+e -Gblue -O -K -L -V >> $outfile
# 	awk -F, 'NR>2 {print $1,$2,0,$5,0,0,0}' $pth2gpsfile | psvelo -R -Jm -Se${dscale}/0.95/0 -W2p,red -A10p+e -Gred -O -K -L -V >> $outfile

	awk -F, 'NR>2 {if ($8<0) print $1,$2,0,$8,0,0,0}'  $pth2gpsfile | gmt psvelo -R -Jm -Se${dscale}/0.95/0 -W2p,red -A10p+e -Gred -O -K -L -V >> $outfile
	awk -F, 'NR>2 {if ($8>=0) print $1,$2,0,$8,0,0,0}' $pth2gpsfile | gmt psvelo -R -Jm -Se${dscale}/0.95/0 -W2p,blue -A10p+e -Gblue -O -K -L -V >> $outfile
fi


# psvelo -R -Jm -Se${dscale}/0.95/10 -W2p,black -A10p+e -Gblack -O -L -V -K <<EOF>> $outfile
# #20.78 37.93 0.02 0 0 0 0 20 mm
# 20.50 37.50 0.02 0 0 0 0 20mm
# EOF

#/////// PLOT STRAINS FROM OKADA \\\\\\\\
#////////////////////////////////////////////////////////////////
### PLOT STRAIN RATES parameters

if [ "$STRAIN" -eq 1 ]
then
for i in `ls $pth2work*.sta`;do
    gmt psxy $i -Jm -O -R -Sc.16c -Gyellow -W0.01c  -K >> $outfile ;   #fill patterns-Gp300/1:F0/0/0B-ls
#     gmt pstext $i -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V>> $outfile

done

for i in `ls $pth2work*.reg`;do
    gmt psxy $i -Jm -O -R  -W0.02c,90  -K  >> $outfile ;   #fill patterns-Gp300/1:F0/0/0B-ls
done

    gmt psvelo  $pth2comp -Jm $range -Sx${STRSC} -L -A10p+e -Gblue -W2p,blue -V -K -O>> $outfile
    gmt psvelo $pth2ext -Jm $range -Sx${STRSC} -L -A10p+e -Gred -W2p,red -V -K -O>> $outfile
    awk '{print $3,$2,8,0,1,"LM",$12}' $pth2strpar | gmt pstext -R -J -D.6/-.4 -O -K -Gyellow >> $outfile
    
    strsclon=$(echo print $maxlon - 0.22 | python)
    strsclat=$(echo print $minlat + 0.18 | python)
    echo "$strsclon $strsclat 0 -2 90" | gmt psvelo -Jm $range -Sx${STRSC} -L -A10p+e -Gblue -W2p,blue -V  -K -O>> $outfile
    echo "$strsclon $strsclat 2 0 90" | gmt psvelo -Jm $range -Sx${STRSC} -L -A10p+e -Gred -W2p,red -V  -K -O>> $outfile
    echo "$strsclon $strsclat 9 0 1 CB 2000 nstrain" | gmt pstext -Jm -R -Dj0c/.9c -Gwhite -O -K -V>> $outfile

fi



#################--- Close eps output file ----##########################################
echo "909 909" | gmt psxy -Sc.1 -Jm -O -R  -W1,red >> $outfile

#################--- Convert to jpg format ----##########################################
if [ "$OUTJPG" -eq 1 ]
then
	gs -sDEVICE=jpeg -dJPEGQ=100 -dNOPAUSE -dBATCH -dSAFER -r300 -sOutputFile=$out_jpg $outfile
fi
################--- Convert to gif format ----##########################################
# ps2raster -E$dpi -Tt $map.ps
# convert -delay 180 -loop 0 *.tif IonMap$date.gif
