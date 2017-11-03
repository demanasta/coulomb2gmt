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
# //////////////////////////////////////////////////////////////////////////////
# Plot stress/strain raster overlay DEM Topography
# arg: plotstr_overtopo ${matrix data file}
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

# //////////////////////////////////////////////////////////////////////////////
# Plot stress/strain raster without transparensy or DEM
# arg: plotstr ${matrix data file}
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

# //////////////////////////////////////////////////////////////////////////////
# PLot bar scale for stress/strain plots
function plot_barscale()
{
  bartick=$(echo $barrange | awk '{print $1/5}')
  gmt psscale -D2.75i/-0.4i/4i/0.15ih -Ctmpcpt.cpt  -B$bartick/:bar: \
    -O -K -V${VRBLEVM} >> $outfile
}

# //////////////////////////////////////////////////////////////////////////////
# Plot Horizontal displacements scale
# arg:  plot_hdisp_scale ${scdhlonl} ${scdhlatl} <color> <legend>
function plot_hdisp_scale()
{
  scdhlat=$(echo print ${2} + .05 | python)
  scdhlon=${1}
  DEBUG echo "[DEBUG:${LINENO}] scdhlat = ${scdhlat}  , scdhlon = ${scdhlon}"
  scdhlatl=$(echo print ${scdhlat} + .1 | python)
  scdhlonl=${scdhlon}
  DEBUG echo "[DEBUG:${LINENO}] scdhlatl = ${scdhlatl}, scdhlonl = ${scdhlonl}"

  tmpmagn=$(echo print ${dhscmagn}/1000.  | python )
  DEBUG echo "[DEBUG:${LINENO}]" ${tmpmagn}
  echo "${scdhlon} ${scdhlat} ${tmpmagn} 0 0 0 0 ${dhscmagn} mm" \
  | gmt psvelo -R -Jm -Se${dhscale}/0.95/10 -W2p,${3} -A10p+e -G${3} \
    -L -O -K -V${VRBLEVM} >> ${outfile}
  echo "${scdhlonl} ${scdhlatl}  9 0 1 CT ${4}" \
  | gmt pstext -Jm -R -Dj0.2c/0.2c -Gwhite -O -K -V${VRBLEVM} >> ${outfile}
}

# //////////////////////////////////////////////////////////////////////////////
# Plot Vertical displacements scale
# arg:  plot_hdisp_scale ${scdvlonl} ${scdvlatl} <up-color> <down-color> <legend>
function plot_vdisp_scale()
{
  scdvlon=$(echo print ${1} - 0.09 | python)
  DEBUG echo "[DEBUG:${LINENO}] scdvlat = ${scdvlat}, scdvmlon = ${scdvlon}"
  scdvlatl=${2}
  scdvlonl=$(echo print ${scdvlon} - 0.06 | python)
  DEBUG echo "[DEBUG:${LINENO}] scdvmlatl = ${scdvlatl}, scdvmlonl = ${scdvlonl}"

  tmpmagn=$(echo print ${dvscmagn}/1000.  | python )
  DEBUG echo "[DEBUG:${LINENO}]"  ${tmpmagn}
  echo "${scdvlon} ${2} 0 -$tmpmagn 0 0 0 $dvscmagn mm" \
  | gmt psvelo -R -Jm -Se${dhscale}/0.95/0 -W2p,${4} -A10p+e -G${4} \
    -L -O -K -V${VRBLEVM} >> ${outfile}
  echo "$scdvlon ${2} 0 $tmpmagn 0 0 0 $dvscmagn mm" \
  | gmt psvelo -R -Jm -Se${dhscale}/0.95/0 -W2p,${3} -A10p+e -G${3} \
  -L -O -K -V${VRBLEVM} >> ${outfile}
  echo "$scdvlonl $scdvlatl 9,1,black 181 CM ${5}" \
  | gmt pstext -R -Jm -Dj0c/0c -F+f+a+j -A -O -K -V${VRBLEVM} >> ${outfile}
}
# //////////////////////////////////////////////////////////////////////////////
# Plot cross section line on the main map
# arg:  plot_cross_line ${path to cross data file}
function plot_cross_line()
{
  if [ $(awk 'NR==1 {print $7}' ${1}) -eq 2 ]; then
    DEBUG echo "[DEBUG:${LINENO}] cross test coords true"
    # read coordinates
    start_lon=$(awk 'NR==2 {print $5}' ${1})
    start_lat=$(awk 'NR==3 {print $5}' ${1})
    finish_lon=$(awk 'NR==4 {print $5}' ${1})
    finish_lat=$(awk 'NR==5 {print $5}' ${1})
    DEBUG echo "[DEBUG:${LINENO}] $start_lon $start_lat $finish_lon $finish_lat"
    # plot line
    echo "$start_lon $start_lat" > tmpcrossline
    echo "$finish_lon $finish_lat" >> tmpcrossline
    gmt psxy tmpcrossline -Jm -R -W1,black -S~D50k:+sc.2 \
      -O -K -V${VRBLEVM} >> ${outfile}
    echo "$start_lon $start_lat 9,1,black 90 RM A" \
    | gmt pstext -R -Jm -Dj.1c/0.1c -F+f+a+j -A -O -K -V${VRBLEVM} >> ${outfile}
    echo "$finish_lon $finish_lat 9,1,black 90 LM B" \
    | gmt pstext -R -Jm -Dj.1c/0.1c -F+f+a+j -A -O -K -V${VRBLEVM} >> ${outfile}
  else
    echo "[ERROR] Cross coordinates must be latlon at dat file."
    echo "        Cross line will not plotted"
    echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
    exit 1
  fi
}


# //////////////////////////////////////////////////////////////////////////////
# Calculate faults on cross setion projection
# arg: calc_fault_cross $i
function calc_fault_cross()
{
  counter=1
  while read -r line; do
    if [ "${line:0:7}" == "> break" ]; then
      let counter=counter+1
      DEBUG echo "[DEBUG:${LINENO}] counter proj= "${counter}
    else
      echo ${line} >> tmp_proj${counter}
    fi
  done < $pth2fprojfile
  
  counter=1
  while read -r line; do
    if [ "${line:0:7}" == "> break" ]; then
      let counter=counter+1
      DEBUG echo "[DEBUG:${LINENO}] counter surf= "${counter}
    else
      echo ${line} >> tmp_surf${counter}
    fi
    done < $pth2fsurffile
    
  counter=1
  while read -r line; do
    if [ "${line:0:7}" == "> break" ]; then
      let counter=counter+1
      DEBUG echo "[DEBUG:${LINENO}] counter dep= "${counter}
    else
      echo ${line} >> tmp_depth${counter}
    fi
    done < $pth2fdepfile
    
  
  declare -A tmp_fault
#   export tmp_fault
  for i in `seq 1 ${1}`; do
    # fault across line
  fault_west=$(gmt spatial tmpcrossline tmp_proj${i} -Fl -Ie \
  | awk 'NR==1 {print $1, $2}' \
  | gmt mapproject -R -Jm -G${start_lon}/${start_lat}/k \
  | awk 'NR==1 {print $3}')
  DEBUG echo "[DEBUG:${LINENO}] fault west= "$fault_west
  fault_east=$(gmt spatial tmpcrossline tmp_proj${i} -Fl -Ie \
  | awk 'NR==2 {print $1, $2}' \
  | gmt mapproject -R -Jm -G${start_lon}/${start_lat}/k \
  | awk 'NR==1 {print $3}')
  DEBUG echo "[DEBUG:${LINENO}] fault_east= "$fault_east
  fault_surf=$(gmt spatial tmpcrossline tmp_surf${i} -Fl -Ie \
  | awk 'NR==1 {print $1, $2}' \
  | gmt mapproject -R -Jm -G${start_lon}/${start_lat}/k \
  | awk 'NR==1 {print $3}')
  DEBUG echo "[DEBUG:${LINENO}] fault_surf= "$fault_surf
  fault_depth=$(gmt spatial tmpcrossline tmp_depth${i} -Fl -Ie \
  | awk 'NR==1 {print $1, $2}' \
  | gmt mapproject -R -Jm -G${start_lon}/${start_lat}/k \
  | awk 'NR==1 {print $3}')
  DEBUG echo "[DEBUG:${LINENO}] fault_depth= "$fault_depth

  counter=0
  isNumber ${fault_west};  if [ $? -eq 0 ];  then
    isNumber ${fault_east};   if [ $? -eq 0 ];  then
      let counter=counter+1
      tmp_fault[${counter},1]=${fault_west}
      tmp_fault[${counter},2]=${fault_east}
      tmp_fault[${counter},3]=${fault_surf}
      tmp_fault[${counter},4]=${fault_depth}
      DEBUG echo "[DEBUG:${LINENO}] tmp_fault"${tmp_fault[@]}

      let inp_line=13+${i}
      DEBUG echo "[DEBUG:${LINENO}] inp_line="${inp_line}

      # Fault top-bottom parameters
      tmp_fault[${counter},5]=$(awk 'NR=='${inp_line}' {print $10}' $pth2inpfile) #top
      DEBUG echo "[DEBUG:${LINENO}] tmp_fault25 "${tmp_fault[1,2]}
      tmp_fault[${counter},6]=$(awk 'NR=='${inp_line}' {print $11}' $pth2inpfile) #bottom
      DEBUG echo "[DEBUG:${LINENO}] tmp_fault "${tmp_fault[@]}
      
      
    else
      DEBUG echo "[DEBUG:${LINENO}] ERROR"
    fi
    else
    DEBUG echo "[DEBUG:${LINENO}] ERROR"
  fi
  
  done
  fault_num=$counter
  
  
    DEBUG echo "[DEBUG:${LINENO}] tmp_fault output next function " ${tmp_fault[@]}
  DEBUG echo "[DEBUG:${LINENO}] tmp_fault "${tmp_fault[1,1]}
  DEBUG echo "[DEBUG:${LINENO}] tmp_fault "${tmp_fault[2,1]}

  
  
  
#   let inp_line=13+${1}
#   DEBUG echo "[DEBUG:${LINENO}] inp_line="${inp_line}
#  # Fault top-bottom parameters
#   fault_top=$(awk 'NR=='${inp_line}' {print $10}' $pth2inpfile)
#   DEBUG echo "[DEBUG:${LINENO}] fault top= "$fault_top
#   fault_bot=$(awk 'NR=='${inp_line}' {print $11}' $pth2inpfile)
#   DEBUG echo "[DEBUG:${LINENO}] fault bot= "$fault_bot
# 
#   # fault across line
#   fault_west=$(gmt spatial tmpcrossline $pth2fprojfile -Fl -Ie \
#   | awk 'NR==1 {print $1, $2}' \
#   | gmt mapproject -R -Jm -G${start_lon}/${start_lat}/k \
#   | awk 'NR==1 {print $3}')
#   DEBUG echo "[DEBUG:${LINENO}] fault west= "$fault_west
#   fault_east=$(gmt spatial tmpcrossline $pth2fprojfile -Fl -Ie \
#   | awk 'NR==2 {print $1, $2}' \
#   | gmt mapproject -R -Jm -G${start_lon}/${start_lat}/k \
#   | awk 'NR==1 {print $3}')
#   DEBUG echo "[DEBUG:${LINENO}] fault_east= "$fault_east
#   fault_surf=$(gmt spatial tmpcrossline $pth2fsurffile -Fl -Ie \
#   | awk 'NR==2 {print $1, $2}' \
#   | gmt mapproject -R -Jm -G${start_lon}/${start_lat}/k \
#   | awk 'NR==1 {print $3}')
#   DEBUG echo "[DEBUG:${LINENO}] fault_surf= "$fault_surf
}

# //////////////////////////////////////////////////////////////////////////////
# Plot faults on cross setion projection
# arg: plot_fault_cross $i
function plot_fault_cross()
{
  DEBUG echo "[DEBUG:${LINENO}] tmp_fault output next function " ${tmp_fault[*]}
  DEBUG echo "[DEBUG:${LINENO}] tmp_fault "${tmp_fault[0,1]}
  DEBUG echo "[DEBUG:${LINENO}] tmp_fault "${tmp_fault[1,1]}
  # make project cordinates for the source fault
#   tmp_fault=($fault_surf $fault_west $fault_east)
  isNumber ${tmp_fault[${1},3]};
  if [ $? -eq 0 ];  then
    tmp_fault_arr=(${tmp_fault[${1},3]} ${tmp_fault[${1},1]} ${tmp_fault[${1},2]})
    if [[ $(echo "if (${tmp_fault[${1},3]} > ${tmp_fault[${1},2]}) 1 else 0" | bc) -eq 1 ]]; then
      IFS=$'\n' tmp_faultsort=($(sort <<<"${tmp_fault_arr[*]}"))
      DEBUG echo "[DEBUG:${LINENO}] sort1 "${tmp_faultsort[*]}
    else
      IFS=$'\n' tmp_faultsort=($(sort -r <<<"${tmp_fault[*]}"))
      DEBUG echo "[DEBUG:${LINENO}] sort2 "${tmp_faultsort[*]}
    fi

    # Plot fault in cross section part
    echo "${tmp_faultsort[1]} ${tmp_fault[${1},5]}" > tmpasd
    echo "${tmp_faultsort[0]} ${tmp_fault[${1},6]}" >> tmpasd
    gmt psxy tmpasd -J -R -W1,black -Ya-6.5c -O -K -V${VRBLEVM} >> ${outfile}
    echo "${tmp_faultsort[2]} 0" > tmpasd
    echo "${tmp_faultsort[1]} ${tmp_fault[${1},5]}" >> tmpasd
    gmt psxy tmpasd -J -R -W.2,black,- -Ya-6.5c -O -K -V${VRBLEVM} >> ${outfile}
  else
    isNumber ${tmp_fault[${1},4]};
    if [ $? -eq 0 ]; then
      tmp_fault_arr=(${tmp_fault[${1},1]} ${tmp_fault[${1},2]})
      if [[ $(echo "if (${tmp_fault[${1},1]} >= ${tmp_fault[${1},4]}) 1 else 0" | bc) -eq 1 ]]; then
	IFS=$'\n' tmp_faultsort=($(sort <<<"${tmp_fault_arr[*]}"))
	DEBUG echo "[DEBUG:${LINENO}] sort1 "${tmp_faultsort[*]}
      else
	IFS=$'\n' tmp_faultsort=($(sort -r <<<"${tmp_fault[*]}"))
	DEBUG echo "[DEBUG:${LINENO}] sort2 "${tmp_faultsort[*]}
      fi

      # Plot fault in cross section part
      echo "${tmp_faultsort[1]} ${tmp_fault[${1},5]}" > tmpasd
      echo "${tmp_faultsort[0]} ${tmp_fault[${1},6]}" >> tmpasd
      gmt psxy tmpasd -J -R -W1,black -Ya-6.5c -O -K -V${VRBLEVM} >> ${outfile}
    else
      echo "[ERROR] Error to plot fcross"
      echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
      exit 1
    fi
  fi
}





















