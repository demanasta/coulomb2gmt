#!/bin/bash
# General functions, plot earthquakes, faults etc

# //////////////////////////////////////////////////////////////////////////////
# Debug function
function DEBUG()
{
 [ "$_DEBUG" == "on" ] &&  $@
}


function plot_faults ()
{
  if [ "${FAULTS}" -eq 1 ]; then
    echo "...plot fault database catalogue..."
    gmt	psxy ${pth2faults} -R -J -O -K  -W.5,204/102/0 -V${VRBLEVM} >> $outfile
  fi
}