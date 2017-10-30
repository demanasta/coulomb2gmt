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
#    filename              : messages.sh
#                            NAME=messages
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
#                 OCT-2017 : First release, Help error messages.
#    contact               : Demitris Anastasiou (dganastasiou@gmail.com)
#    ----------------------------------------------------------------------
# ==============================================================================

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
  echo "           -r | --region : set different region minlon maxlon minlat maxlat prjscale"
  echo "           -t | --topography : plot topography using dem file if exist "
  echo "           -o | --output <name> : name of output files"
#   echo "           -l [:=labels] plot labels"
#   echo "           -leg [:=legend] insert legends"
  echo "           -cmt |--moment_tensor <file> : Plot centoid moment tensors "
  echo "           -fl | --faults_db : plot fault database catalogue"
  echo "           -mt | --map_title <title> : title map default none use quotes"
  echo "           -ct | --custom_text <file> : Plot custom text in map"
  echo "           -ed | --eq_distribution <file> : Plot earthquake distribution"
  echo "           -h | --help : help menu"
  echo "           -lg | --logo_gmt : Plot gmt logo and time stamp"
  echo "           -lc | --logo_custom : Plot custom logo of your organization"
  echo "           -v | --version : Plots script release"
  echo "           -d | --debug : enable debug option"
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