#!/bin/bash
#plot Coulomb Stress change to GMT maps
# //////////////////////////////////////////////////////////////////////////////
# %==========================================================================
# %  
# %   |===========================================|
# %   |**     DIONYSOS SATELLITE OBSERVATORY    **|
# %   |**        HIGHER GEODESY LABORATORY      **|
# %   |** National Tecnical University of Athens**|
# %   |===========================================|
# %  
# %   filename              : coulomb2gmt.sh
# %                           NAME=coulomb2gmt
# %   version               : v-1.0
# %                           VERSION=v1.0
# %                           RELEASE=beta
# %   created               : SEP-2015
# %   usage                 :
# %   exit code(s)          : 0 -> success
# %                         : 1 -> error
# %   discription           : 
# %   uses                  : 
# %   notes                 :
# %   detailed update list  : LAST_UPDATE=OCT-2017
# %   contact               : Demitris Anastasiou (dganastasiou@gmail.com)
# %   ----------------------------------------------------------------------
# %==========================================================================
# //////////////////////////////////////////////////////////////////////////////
# HELP FUNCTION
function help {
	echo "/******************************************************************************/"
	echo " Program Name : coulomb2gmt.sh"
	echo " Version : v-1.0-beta*"
	echo " Purpose : Plot Coulomb Stress chenge results"
	echo " Usage   : coulomb2gmt.sh  <inputfile> <ipnut data> | options | "
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
	echo "/*** OTHER OPRTIONS ************************************************************/"
	echo "           -topo [:=topography] plot dem file if exist "
	echo "           -o [:= output] name of output files"
	echo "           -l [:=labels] plot labels"
        echo "           -leg [:=legend] insert legends"
	echo "           -jpg : convert eps file to jpg"
	echo "           -h [:= help] help menu"
	echo ""
	echo " Exit Status:    1 -> help message or error"
	echo " Exit Status: >= 0 -> sucesseful exit"
	echo ""
	echo "/******************************************************************************/"
	exit -2
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
	
elif [ -f ../inp_historic/${1}.inp ];
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
#                       switch topo not used in server!
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

# inputTopoB=/home/mitsos/Map_project/maps_gmt/ETOPO1_Bed_g_gmt4.grd
landcpt=land_man.cpt
bathcpt=bath_man.cpt
coulombcpt=Coulomb_anatolia.cpt
pth2inpfile=../inp_historic/${inputfile}.inp
#pth2gpsfile=../output_files/GPS_output.csv
#pth2gpsfile=../gmt_files/${inputdata}.disp
pth2gpsfile=${inputdata}.disp
#pth2inpdata=../input_zakynthos/${inputfile}.inp

if [ "$RANGE" -eq 0 ]
then
	minlon=$(grep "min. lon" ${pth2inpfile} | awk '{print $6}')
	maxlon=$(grep "max. lon" ${pth2inpfile} | awk '{print $6}')
	minlat=$(grep "min. lat" ${pth2inpfile} | awk '{print $6}')
	maxlat=$(grep "max. lat" ${pth2inpfile} | awk '{print $6}')
	prjscale=1500000 ##DEF 1000000
fi
# source region.par
echo $minlon
	frame=0.5
	sclat=$(echo print $minlat + 0.08 | python)
	sclon=$(echo print $maxlon - 0.22 | python)
	scale=-Lf${sclon}/${sclat}/36:24/20+l+jr
# 	scale=-Lf22.3/37.94/36:24/10+l+jr
	range=-R$minlon/$maxlon/$minlat/$maxlat
# range=-R20.6/21.5/37.5/38.2
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
	# bathymetry
gmt	makecpt -Cgebco.cpt -T-7000/0/50 -Z > $bathcpt
gmt	grdimage $inputTopoB $range $proj -C$bathcpt -K > $outfile
gmt	pscoast $proj -P $range -Df -Gc -K -O >> $outfile
	# land
gmt	makecpt -Cgray.cpt -T-6000/1800/50 -Z > $landcpt
gmt	grdimage $inputTopoL $range $proj -C$landcpt  -K -O >> $outfile
gmt	pscoast -R -J -O -K -Q >> $outfile
	#------- coastline -------------------------------------------
gmt	psbasemap -R -J -O -K -B$frame:."$maptitle":  $scale >> $outfile
gmt	pscoast -J -R -Df -W0.25p,black -K  -O -U$logo_pos >> $outfile
fi

#///////// PLOT COULOMB STRESS CHANGE
if [ "$CSTRESS" -eq 1 ]
then
	################# Plot Coulomb source AnD coastlines only ######################
	xyz2grd ${inputdata}-coulomb_out.dat -Gtest $range -I0.05
  
	makecpt -C$coulombcpt -T-1/1/0.002 -Z > testcpt
	grdsample test -I4s -Gtest_sample.grd
# 	grdgradient test_sample.grd -Nt -A90  -Gtest_i
	grdimage test_sample.grd -Ctestcpt $proj  -K -Ei -Q -Y4.5c> $outfile
rm test test_i test_sample.grd
	pscoast $range $proj -Df -W0.5,120 -O -K >> $outfile 
	psbasemap -R -J -O -K -B$frame:."Plot Coulomb stress change": --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p>> $outfile

	#////////// Plot scale Bar \\\\\\\\\\\\\\\\\\\\
	psscale -D2.75i/-0.4i/4i/0.15ih -Ctestcpt  -B0.2/:bar: -O -K >> $outfile
fi

#///////// PLOT SHEAR STRESS CHANGE
if [ "$SSTRESS" -eq 1 ]
then
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${inputdata}-coulomb_out.dat > tmp1
  awk 'NR>3{print $5}' ../output_files/${inputdata}-dcff.cou > tmp2
  paste -d" " tmp1 tmp2 >tmpall
	################# Plot Coulomb source AnD coastlines only ######################
	xyz2grd tmpall -Gtest $range -I0.05
  
	makecpt -C$coulombcpt -T-1/1/0.002 -Z > testcpt
	grdsample test -I4s -Gtest_sample.grd
# 	grdgradient test_sample.grd -Nt -A90  -Gtest_i
	grdimage test_sample.grd -Ctestcpt $proj  -K -Ei -Q -Y4.5c> $outfile
rm test test_i test_sample.grd
	pscoast $range $proj -Df -W0.5,120 -O -K >> $outfile 
	psbasemap -R -J -O -K -B$frame:."Plot Coulomb stress change": --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p>> $outfile

	#////////// Plot scale Bar \\\\\\\\\\\\\\\\\\\\
	psscale -D2.75i/-0.4i/4i/0.15ih -Ctestcpt  -B0.2/:bar: -O -K >> $outfile
	rm tmp1 tmp2 tmpall
fi

#///////// PLOT NORMAL STRESS CHANGE
if [ "$NSTRESS" -eq 1 ]
then
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${inputdata}-coulomb_out.dat > tmp1
  awk 'NR>3 {print $6}' ../output_files/${inputdata}-dcff.cou > tmp2
  paste -d" " tmp1 tmp2 >tmpall
	################# Plot Coulomb source AnD coastlines only ######################
	xyz2grd tmpall -Gtest $range -I0.05
  
	makecpt -C$coulombcpt -T-1/1/0.002 -Z > testcpt
	grdsample test -I4s -Gtest_sample.grd
# 	grdgradient test_sample.grd -Nt -A90  -Gtest_i
	grdimage test_sample.grd -Ctestcpt $proj  -K -Ei -Q -Y4.5c> $outfile
rm test test_i test_sample.grd
	pscoast $range $proj -Df -W0.5,120 -O -K >> $outfile 
	psbasemap -R -J -O -K -B$frame:."Plot Coulomb stress change": --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p>> $outfile

	#////////// Plot scale Bar \\\\\\\\\\\\\\\\\\\\
	psscale -D2.75i/-0.4i/4i/0.15ih -Ctestcpt  -B0.2/:bar: -O -K >> $outfile
	rm tmp1 tmp2 tmpall
fi

#///////// PLOT DILATATION STRAIN
if [ "$DILSTRAIN" -eq 1 ]
then
  # MAKE INPUT FILE........
  awk '{print $1, $2}' ${inputdata}-coulomb_out.dat > tmp1
  awk 'NR>3 {print $10*1000000}' ../output_files/${inputdata}_Strain.cou > tmp2
  paste -d" " tmp1 tmp2 >tmpall
	################# Plot Coulomb source AnD coastlines only ######################
	xyz2grd tmpall -Gtest $range -I0.05
  
	makecpt -C$coulombcpt -T-1/1/0.002 -Z > testcpt
	grdsample test -I4s -Gtest_sample.grd
# 	grdgradient test_sample.grd -Nt -A90  -Gtest_i
	grdimage test_sample.grd -Ctestcpt $proj  -K -Ei -Q -Y4.5c> $outfile
rm test test_i test_sample.grd
	pscoast $range $proj -Df -W0.5,120 -O -K >> $outfile 
	psbasemap -R -J -O -K -B$frame:."Plot Coulomb stress change": --FONT_ANNOT_PRIMARY=10p $scale --FONT_LABEL=10p>> $outfile

	#////////// Plot scale Bar \\\\\\\\\\\\\\\\\\\\
	psscale -D2.75i/-0.4i/4i/0.15ih -Ctestcpt  -B0.2/:bar: -O -K >> $outfile
	rm tmp1 tmp2 tmpall
fi

#///////// PLOT gmt_fault_map_proj.dat \\\\\\\\\\\\\\\
if [ "$FPROJ" -eq 1 ]
then
	psxy ${inputdata}-gmt_fault_map_proj.dat -Jm -O -R  -W1,red  -K >> $outfile
fi
if [ "$FSURF" -eq 1 ]
then
	psxy ${inputdata}-gmt_fault_surface.dat -Jm -O -R  -W0.4,0  -K >> $outfile
fi
if [ "$FDEP" -eq 1 ]
then
	psxy ${inputdata}-gmt_fault_calc_dep.dat -Jm -O -R -W0.4,black -K >> $outfile
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


# #/////// PLOT SHEAR STRAIN HISTORIC TRIANGULATION \\\\\\\\
# pth2shear=~/PhD_project/triangle/matlab_src/Frank_alg2/output/epoch${terobs_file}.strains
# STRSC=${TEROBS_STRSC}
# if  [ "$TEROBS_EXCL" -eq 0 ]
# then
# 	grep -v "#" $pth2shear | awk '{print $8,$7,$12,0,$15+90}' | gmt psvelo -Jm $range -Sx${STRSC} -L -A.1quitp+e -Gblue -W2p,0 -V  -K -O>> $outfile
# 	grep -v "#" $pth2shear | awk '{print $8,$7,$12,0,$13+90}' | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,red -V  -K -O>> $outfile
# elif [ "$TEROBS_EXCL" -eq 1 ]
# then
# 	grep \# $pth2shear | awk '{print $9,$8,$13,0,$16+90}' | gmt psvelo -Jm $range -Sx${STRSC} -L -A.1quitp+e -Gblue -W2p,0 -V  -K -O>> $outfile
# 	grep \# $pth2shear | awk '{print $9,$8,$13,0,$14+90}' | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,red -V  -K -O>> $outfile
# elif [ "$TEROBS_EXCL" -eq 2 ]
# then
# 	grep -v "#" $pth2shear | awk '{print $8,$7,$12,0,$15+90}' | gmt psvelo -Jm $range -Sx${STRSC} -L -A.1quitp+e -Gblue -W2p,0 -V  -K -O>> $outfile
# 	grep -v "#" $pth2shear | awk '{print $8,$7,$12,0,$13+90}' | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,red -V  -K -O>> $outfile
# 	grep \# $pth2shear | awk '{print $9,$8,$13,0,$16+90}' | gmt psvelo -Jm $range -Sx${STRSC} -L -A.1quitp+e -Gblue -W2p,0 -V  -K -O>> $outfile
# 	grep \# $pth2shear | awk '{print $9,$8,$13,0,$14+90}' | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,red -V  -K -O>> $outfile
# else
# echo "plot nothing!!"
# fi
# 
# # PLOT SCALE temporary code...
# #Strain scales tests
# if [ "$PSCLEG" -eq 1 ]
# then
# # 1 : naf
# 	extsc="22.545 37.83 0.08 0 -22.5"
# 	gmaxsc="22.545 37.83 0.08 0 22.5"
# 	sctext="22.545 37.89 8 0 1 CM 100 nstrain/y"
# 	sctexte="22.545 37.77 8 0 1 CM Extension"
# 	sctextg="22.545 37.74 8 0 1 CM Maximum Shear"
# 	scbox="22.545 37.814 2.4c 2.2c"
# 	echo $scbox  | gmt psxy  -R -J -O -K -Sr -G245 -Wthinnest>> $outfile
# 	echo $extsc  | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,black -V  -K -O >> $outfile
# 	echo $gmaxsc | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,red -V  -K -O >> $outfile
# 	echo $sctext | gmt pstext -R -J -O -K >> $outfile
# 	echo $sctexte | gmt pstext -R -J -O -K -F+fred>> $outfile
# 	echo $sctextg | gmt pstext -R -J -O -K -F+fblack>> $outfile
# elif [ "$PSCLEG" -eq 2 ]
# then
# # 2 : kat21
# 	extsc="20.638 39.12 0.1 0 -22.5"
# 	gmaxsc="20.638 39.12 0.1 0 22.5"
# 	sctext="20.638 39.175 8 0 1 CM 100 nstrain/y"
# 	sctexte="20.638 39.06 8 0 1 CM Extension"
# 	sctextg="20.638 39.03 8 0 1 CM Maximum Shear"
# 	scbox="20.638 39.1 2.4c 2.2c"
# 	echo $scbox  | gmt psxy  -R -J -O -K -Sr -G245 -Wthinnest>> $outfile
# 	echo $extsc  | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,black -V  -K -O >> $outfile
# 	echo $gmaxsc | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,red -V  -K -O >> $outfile
# 	echo $sctext | gmt pstext -R -J -O -K >> $outfile
# 	echo $sctexte | gmt pstext -R -J -O -K -F+fred>> $outfile
# 	echo $sctextg | gmt pstext -R -J -O -K -F+fblack>> $outfile
# elif [ "$PSCLEG" -eq 3 ]
# then
# # 3 : kat53
# 	extsc="20.638 39.12 0.5 0 -22.5"
# 	gmaxsc="20.638 39.12 0.5 0 22.5"
# 	sctext="20.638 39.175 8 0 1 CM 500 nstrain/y"
# 	sctexte="20.638 39.06 8 0 1 CM Extension"
# 	sctextg="20.638 39.03 8 0 1 CM Maximum Shear"
# 	scbox="20.638 39.1 2.4c 2.2c"
# 	echo $scbox  | gmt psxy  -R -J -O -K -Sr -G245 -Wthinnest>> $outfile
# 	echo $extsc  | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,black -V  -K -O >> $outfile
# 	echo $gmaxsc | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,red -V  -K -O >> $outfile
# 	echo $sctext | gmt pstext -R -J -O -K >> $outfile
# 	echo $sctexte | gmt pstext -R -J -O -K -F+fred>> $outfile
# 	echo $sctextg | gmt pstext -R -J -O -K -F+fblack>> $outfile
# elif [ "$PSCLEG" -eq 4 ]
# then
# # 3 : kyl39 1st epoch
# 	extsc="20.37 37.45 0.15 0 -22.5"
# 	gmaxsc="20.37 37.45 0.15 0 22.5"
# 	sctext="20.37 37.514 8 0 1 CM 150 nstrain/y"
# 	sctexte="20.37 37.388 8 0 1 CM Extension"
# 	sctextg="20.37 37.35 8 0 1 CM Maximum Shear"
# 	scbox="20.37 37.425 2.4c 2.2c"
# 	echo $scbox  | gmt psxy  -R -J -O -K -Sr -G245 -Wthinnest>> $outfile
# 	echo $extsc  | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,black -V  -K -O >> $outfile
# 	echo $gmaxsc | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,red -V  -K -O >> $outfile
# 	echo $sctext | gmt pstext -R -J -O -K >> $outfile
# 	echo $sctexte | gmt pstext -R -J -O -K -F+fred>> $outfile
# 	echo $sctextg | gmt pstext -R -J -O -K -F+fblack>> $outfile
# elif [ "$PSCLEG" -eq 5 ]
# then
# # 3 : kyl39 2nd epoch
# 	extsc="20.37 37.45 0.5 0 -22.5"
# 	gmaxsc="20.37 37.45 0.5 0 22.5"
# 	sctext="20.37 37.514 8 0 1 CM 500 nstrain/y"
# 	sctexte="20.37 37.388 8 0 1 CM Extension"
# 	sctextg="20.37 37.35 8 0 1 CM Maximum Shear"
# 	scbox="20.37 37.425 2.4c 2.2c"
# 	echo $scbox  | gmt psxy  -R -J -O -K -Sr -G245 -Wthinnest>> $outfile
# 	echo $extsc  | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,black -V  -K -O >> $outfile
# 	echo $gmaxsc | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,red -V  -K -O >> $outfile
# 	echo $sctext | gmt pstext -R -J -O -K >> $outfile
# 	echo $sctexte | gmt pstext -R -J -O -K -F+fred>> $outfile
# 	echo $sctextg | gmt pstext -R -J -O -K -F+fblack>> $outfile
# elif [ "$PSCLEG" -eq 6 ]
# then
# # 1 : eli69 2nd epoch
# 	extsc="22.545 38.701 0.5 0 -22.5"
# 	gmaxsc="22.545 38.701 0.5 0 22.5"
# 	sctext="22.545 38.761 8 0 1 CM 500 nstrain/y"
# 	sctexte="22.545 38.641 8 0 1 CM Extension"
# 	sctextg="22.545 38.611 8 0 1 CM Maximum Shear"
# 	scbox="22.545 38.685 2.4c 2.2c"
# 	echo $scbox  | gmt psxy  -R -J -O -K -Sr -G245 -Wthinnest>> $outfile
# 	echo $extsc  | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,black -V  -K -O >> $outfile
# 	echo $gmaxsc | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,red -V  -K -O >> $outfile
# 	echo $sctext | gmt pstext -R -J -O -K >> $outfile
# 	echo $sctexte | gmt pstext -R -J -O -K -F+fred>> $outfile
# 	echo $sctextg | gmt pstext -R -J -O -K -F+fblack>> $outfile
# elif [ "$PSCLEG" -eq 7 ]
# then
# # 1 : eli69 3rd epoch
# 	extsc="22.545 38.701 1 0 -22.5"
# 	gmaxsc="22.545 38.701 1 0 22.5"
# 	sctext="22.545 38.761 8 0 1 CM 800 nstrain/y"
# 	sctexte="22.545 38.641 8 0 1 CM Extension"
# 	sctextg="22.545 38.611 8 0 1 CM Maximum Shear"
# 	scbox="22.545 38.685 2.4c 2.2c"
# 	echo $scbox  | gmt psxy  -R -J -O -K -Sr -G245 -Wthinnest>> $outfile
# 	echo $extsc  | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,black -V  -K -O >> $outfile
# 	echo $gmaxsc | gmt psvelo -Jm $range -Sx${STRSC} -L -A0.1p+e -Gred -W2p,red -V  -K -O >> $outfile
# 	echo $sctext | gmt pstext -R -J -O -K >> $outfile
# 	echo $sctexte | gmt pstext -R -J -O -K -F+fred>> $outfile
# 	echo $sctextg | gmt pstext -R -J -O -K -F+fblack>> $outfile
# else
# echo "no scale plot"
# fi


# awk '{print $8,$7,$12,0,$15+90}' $pth2shear | gmt psvelo -Jm $range -Sx${STRSC} -L -A.1quitp+e -Gblue -W2p,blue -V  -K -O>> $outfile
#////////// Plot scale Bar \\\\\\\\\\\\\\\\\\\\
#psscale -D2.75i/-0.4i/4i/0.15ih -C$coulombcpt  -B0.2/:bar: -O >> $outfile

#psmeca <<EOF $range -Jm -Sc0.9/10 -CP0.25 -O -P >> $outfile
#lon lat depth str dip slip st dip slip magnt exp plon plat
#20.32 37.38 13 18 67 164 114 75 24 6.3 0 20.31 37.42 760511, Mw=6.3
#20.39 38.22 6 18 67 164 114 75 24 6.0 0 20.31 38.11 Jan26, Mw=6.0
#20.39 38.22 6 18 67 164 114 75 24 6.0 0 20.31 38.28 Jan26, Mw=6.0
#20.4417 38.236 6 149 64 65 16 35 131 5.3 0 20.54 38.35 Jan 26, Mw=5.3
#20.3737 38.2535 10.5 294 78 35 196 56 166 5.9 0 20.32 38.37 Feb 3, Mw=5.9
#EOF

#psxy <<EOF -Jm -O -R -Sa0.5c -Gblue -K >> $outfile
#20.39 38.22
#20.3948 38.2527
#EOF

#psxy <<EOF -Jm -O -R -Sa0.5c -Gred -K >> $outfile
# 20.39 38.22
# 20.4417 38.236
# 20.3737 38.2535
#EOF
# pstext <<EOF -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V -K>> $outfile
# 20.5478 38.2230 8 0 1 RB EQ140126
# EOF

# awk '{print $5,$4}' camp-ionio.sites | psxy -H1 -Jm -O -R -Sc0.2c -Gblack -K >> $outfile
# awk '{print $5,$4,9, 0, 1,"LB",$3}' camp-ionio.sites | pstext  -H1 -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V -K >> $outfile


# awk '{print $5,$4}' camp-sing.sites | psxy -Jm -O -R -Sc0.2c -Gblack -K >> $outfile
# awk '{print $5,$4,9, 0, 1, "RB",$3}' camp-sing.sites | pstext  -H1 -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V -K >> $outfile


#psxy <<EOF -Jm -O -R -St0.4c -Gblack -K >> $outfile
#20.5886441 38.1768271
#20.5851789 38.6189990
#20.43816 38.19571
#20.6736383 38.7813002
#20.3483515 +38.2031859
#21.40783 38.62345
#21.46474 38.055834
#21.35537 37.79594
#EOF

#pstext <<EOF -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V -K >> $outfile
#20.5886441 38.1768271 9 0 1 LB VLSM
#20.5851789 38.6189990 9 0 1 LB PONT
#20.43816 38.19571 9 0 1 RB KEFA
#20.6736383 38.7813002 9 0 1 RB SPAN
#20.3483515 +38.2031859 9 0 1 RB KIPO
#21.40783 38.62345 9 0 1 RB AGRI
#21.46474 38.055834 9 0 1 RB RLSO
#21.35537 37.79594 9 0 1 RB AMAL
#EOF

# ######---------plot labels--------#############
# psxy <<END -Jm $range -Sr -W0.15p,black -Gwhite -K -V -O>>$outfile
# 20.34 37.945 4.1 1.8
# END
# 
# psxy <<EOF -Jm -O -R -St0.3c -Gblue -K >> $outfile
# 20.25 37.96
# EOF
# 
# psxy <<EOF -Jm -O -R -Sc0.2c -Gblack -K >> $outfile
# 20.25 37.93
# EOF
# 
# pstext <<EOF -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V >> $outfile
# 20.26 37.96 9 0 1 LM cGPS stations 
# 20.26 37.93 9 0 1 LM campaign sites
# EOF


# psvelo <<EOF -Jm $range -Se50/0.95/0 -W0.15p,black -G205/133/63  -A0.07/0.20/0.12 -V -O -K>> $outfile  # 205/133/63
# 20.5886441 38.1768271 -0.018 -0.008 0 0 0 vlsm
# 20.43816 38.19571 0.029 -0.056 0 0 0 kefa
# 20.28 37.96 0.02 0 0 0 0 
# EOF

# psvelo <<EOF -Jm $range -Se50/0.95/0 -W0.15p,black -Gred  -A0.07/0.20/0.12 -V -O -K -X1.45c -Y-2.8c>> $outfile  # 205/133/63
# #20.5886441 38.1768271 -0.010 -0.009 0 0 0 vlsm
# 20.43816 38.19571 0.031 -0.091 0 0 0 kefa
# #20.28 37.96 0.02 0 0 0 0 
# EOF
# # 

#### plot total displacement
#psvelo <<EOF -Jm $range -Se40/0.95/0 -W0.15p,black -Gred  -A0.07/0.20/0.12 -V -O -K>> $outfile  # 205/133/63
#20.5886441 38.1768271 -0.028 -0.017 0 0 0 vlsm
#20.43816 38.19571 0.060 -0.147 0 0 0 kefa
#20.34835 38.20318 -0.010 0.07 0 0 0 kipo
#20.28 37.96 0.02 0 0 0 0 
#EOF

#pstext <<EOF -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V -K >> $outfile   #-X-1.45c -Y2.8c
#20.28 37.96 9 0 1 RM 2 cm
#EOF
# # 
# psvelo <<EOF -Jm $range -Se50/0.95/0 -W0.15p,black -Gred  -A0.07/0.20/0.12 -V -O -K -X-0.9c -Y-0.4c>> $outfile  # 205/133/63
# 20.5886441 38.1768271 -0.010 -0.009 0 0 0 vlsm
# #20.43816 38.19571 0.031 -0.091 0 0 0 kefa
# #20.28 37.96 0.02 0 0 0 0 
# EOF



#PLOT STRAIN

# psvelo <<END -Jm $range -Sx1 -L -A0.07/0.20/0.12 -W0.8p,blue -V  -K -O>> $outfile
# 20.53726 38.33053 0 -4.595 115.479
# #20.85996 38.47371 0 -0.137 127.506
# #21.15337 38.28605 0 -0.004 260.304
# #21.13678 38.01021 0 -0.025 91.780
# 20.3 38.03 0 -1 0
# END
# 
# psvelo <<END -Jm $range -Sx1 -L -A0.07/0.20/0.12 -W0.8p,red -V  -K -O>> $outfile
# 20.53726 38.33053 1.034 0 115.479
# #20.85996 38.47371 0.259 0 127.506
# #21.15337 38.28605 0.254 0 260.304
# #21.13678 38.01021 0.227 0 91.780
# 20.3 38.03 1 0 0
# END
# 
# pstext <<EOF -Jm -R -Dj0.1c/0.1c -G0/0/0 -O -V -K >> $outfile
# 20.3 38.085 9 0 1 CB 1000 nstrains 
# EOF

### PLOT ROTATION
# psvelo <<END -Jm $range -Sw2/1.e3 -Gred -E0/0/0/10 -L -A0.05/0/0  -V -O>> $outfile
# 20.53726 38.73053 -0.001697 0.000
# END
#################--- Plot DSO logo ----##########################################
# psimage $HOME/Map_project/logos/DSOlogo2.eps -O -C12.35c/0.05c -W1c -F0.1 >>$outfile
echo "909 909" | gmt psxy -Sc.1 -Jm -O -R  -W1,red >> $outfile
#################--- Convert to jpg format ----##########################################
if [ "$OUTJPG" -eq 1 ]
then
	gs -sDEVICE=jpeg -dJPEGQ=100 -dNOPAUSE -dBATCH -dSAFER -r300 -sOutputFile=$out_jpg $outfile
fi
################--- Convert to gif format ----##########################################
# ps2raster -E$dpi -Tt $map.ps
# convert -delay 180 -loop 0 *.tif IonMap$date.gif
