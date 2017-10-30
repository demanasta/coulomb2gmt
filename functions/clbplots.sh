#!/bin/bash/

# //////////////////////////////////////////////////////////////////////////////
# ==============================================================================
#   
#    |===========================================|
#    |**     DIONYSOS SATELLITE OBSERVATORY    **|
#    |**        HIGHER GEODESY LABORATORY      **|
#    |** National Tecnical University of Athens**|
#    |===========================================|
#   
#    filename              : clbplots.sh
#                            NAME=clbplots
#    version               : v-1.0
#                            VERSION=v1.0
#                            RELEASE=beta
#    licence               : MIT
#    created               : SEP-2017
#    usage                 : called from ./coulomb2gmt.sh
#    exit code(s)          : 0 -> success
#                          : 1 -> error
#    discription           : Functions for messages printed on the screen or stderr
#    uses                  : 
#    notes                 :
#    detailed update list  : LAST_UPDATE=OCT-2017
#                 OCT-2017 : First release
#    contact               : Demitris Anastasiou (dganastasiou@gmail.com)
#    ----------------------------------------------------------------------
# ==============================================================================

function plotstr_overtopo()
{
  gmt makecpt -Cgray.cpt -T-10000/0/100 -Z -V${VRBLEVM} > $bathcpt
  gmt grdimage $inputTopoB $range $proj -C$bathcpt -K -V${VRBLEVM} -Y8c > $outfile
  gmt pscoast $proj -P $range -Df -Gc -K -O -V${VRBLEVM} >> $outfile

  gmt makecpt -Cgray.cpt -T-6000/1800/50 -Z -V${VRBLEVM} > $landcpt
  gmt grdimage $inputTopoL $range $proj -C$landcpt  -K -O -V${VRBLEVM} >> $outfile
  gmt pscoast -R -J -O -K -Q -V${VRBLEVM} >> $outfile
  
  gmt xyz2grd ${1} -Gtmpgrd $range -I0.05 -V${VRBLEVM}
  gmt makecpt -C$coulombcpt -T-$barrange/$barrange/0.002 -Z -V${VRBLEVM} > tmpcpt.cpt
  gmt grdsample tmpgrd -I4s -Gtmpgrd_sample.grd -V${VRBLEVM}
  gmt grdimage tmpgrd_sample.grd -Ctmpcpt.cpt -t${RTRANS} $range $proj -Ei \
    -Q -O -K -V${VRBLEVM} >> $outfile
  gmt pscoast $range $proj -Df -W0.3,140 -O -K -V${VRBLEVM} >> $outfile 
  gmt psbasemap -R -J -B$frame:."$mtitle": $scale $logogmt_pos \
    -O -K -V${VRBLEVM} >> $outfile
  
}


function plotstr()
{
#   gmt makecpt -Cgray.cpt -T-10000/0/100 -Z -V${VRBLEVM} > $bathcpt
#   gmt grdimage $inputTopoB $range $proj -C$bathcpt -K -V${VRBLEVM} -Y8c > $outfile
#   gmt pscoast $proj -P $range -Df -Gc -K -O -V${VRBLEVM} >> $outfile
# 
#   gmt makecpt -Cgray.cpt -T-6000/1800/50 -Z -V${VRBLEVM} > $landcpt
#   gmt grdimage $inputTopoL $range $proj -C$landcpt  -K -O -V${VRBLEVM} >> $outfile
#   gmt pscoast -R -J -O -K -Q -V${VRBLEVM} >> $outfile
  
  gmt xyz2grd ${1} -Gtmpgrd $range -I0.05 -V${VRBLEVM}
  gmt makecpt -C$coulombcpt -T-$barrange/$barrange/0.002 -Z -V${VRBLEVM} > tmpcpt.cpt
  gmt grdsample tmpgrd -I4s -Gtmpgrd_sample.grd -V${VRBLEVM}
  gmt grdimage tmpgrd_sample.grd -Ctmpcpt.cpt $range $proj -Ei -Y8c \
    -Q -K -V${VRBLEVM} > $outfile
  gmt pscoast $range $proj -Df -W0.3,120 -O -K -V${VRBLEVM} >> $outfile 
  gmt psbasemap -R -J -B$frame:."$mtitle": $scale $logogmt_pos \
    -O -K -V${VRBLEVM} >> $outfile
  
}

function plot_barscale()
{
  bartick=$(echo $barrange | awk '{print $1/5}')
  gmt psscale -D2.75i/-0.4i/4i/0.15ih -Ctmpcpt.cpt  -B$bartick/:bar: \
    -O -K -V${VRBLEVM} >> $outfile
}

































