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
#    filename              : gen_func.sh
#                            NAME=gen_func
#    version               : v-1.0
#                            VERSION=v1.0
#                            RELEASE=beta
#    licence               : MIT
#    created               : SEP-2017
#    usage                 : called from ./coulomb2gmt.sh
#    exit code(s)          : 0 -> success
#                          : 1 -> error
#    discription           : General functions, plot earthquakes, faults etc
#    uses                  : 
#    notes                 :
#    detailed update list  : LAST_UPDATE=OCT-2017
#                 OCT-2017 : First release.
#    contact               : Demitris Anastasiou (dganastasiou@gmail.com)
#    ----------------------------------------------------------------------
# ==============================================================================

# //////////////////////////////////////////////////////////////////////////////
# Debug function
function DEBUG()
{
 [ "$_DEBUG" == "on" ] &&  $@
}

# //////////////////////////////////////////////////////////////////////////////
# plot fault database
function plot_faults ()
{
  if [ "${FAULTS}" -eq 1 ]; then
    echo "...plot fault database catalogue..."
    gmt	psxy ${pth2faults} -R -J -O -K  -W.5,204/102/0 -V${VRBLEVM} >> $outfile
  fi
}

function check_arg_ot() 
{
  if [ "${1}" == "+ot" ]; then
    OVERTOPO=1
  else
    OVERTOPO=0
    echo "[WARNING] Bad argument structure. argument \"${1}\" is not right"
  fi
}