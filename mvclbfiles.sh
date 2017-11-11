#!/bin/bash
#///////////////////////////////////////////////////////////////////////////////
# THis script rename and move coulomb output files in different directories

# //////////////////////////////////////////////////////////////////////////////
# ==============================================================================
#   
#    |=============================================|
#    |** NATIONAL TECHNICAL UNIVERSITY OF ATHENS **|
#    |** SCHOOL OF RURAL & SURVEYING ENGINEERING **|
#    |**      DIONYSOS SATELLITE OBSERVATORY     **|
#    |**         HIGHER GEODESY LABORATORY       **|
#    |=============================================|
#   
#    filename       : mvclbfiles.sh
#                     NAME=mvclbfiles
#    version        : v-1.0
#                     VERSION=v1.0
#                     RELEASE=v1.0
#    licence        : MIT
#    created        : SEP-2015
#    usage          :
#    GMT Modules    :
#    UNIX progs     : mv, echo
#    exit code(s)   : 0 -> success
#                     1 -> error
#    discription    : 
#    uses           : $./mvclbfiles <inputdata>
#    notes          : Set first CLB34_HOME variable as coulomb home directory
#    update list    : LAST_UPDATE=11-NOV-2017
#       11-NOV-2017 : Add option to check which files exist
#       23-OCT-2017 : Add help, and CLB34_HOME variables
#       10-SEP-2015 : first release
#    contact        : Demitris Anastasiou (dganastasiou@gmail.com)
#    ----------------------------------------------------------------------
# ==============================================================================
# HELP Function
function help {
  echo "/******************************************************************************/"
  echo " Program Name : mvclbfiles.sh"
  echo " Version : v-1.0"
  echo " Purpose : raname and move input data files"
  echo " Usage   : mvgmtfile.sh <inputdata> "
  echo "         : set first CLB34_HOME variable as coulomb home directory"
  echo " options : -h | --help : help function"
  echo "           -ch| --check_file : check which coulomb files exist"
  echo "/******************************************************************************/"
  echo "[STATUS] Script Finished Unsuccesful! Exit Status 1"
  exit 1
}

CHECKFILE=0

# input arguments
if [ "$#" -ne 1 ]; then
  help
elif [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
  help
elif [ "${1}" == "-ch" ] || [ "${1}" == "--check_files" ];then
  CHECKFILE=1
elif [ "${1:0:1}" != "-" ]; then
  echo "...echo inputdata code set to :"${1}" ..."
  input=$1
  echo "...start rename and move files..."
else
  echo "[ERROR] Bad argument structure. argument \"$1\" is not right"
  help
fi

# set coulomb34 home dir 
if [ ! -d "${CLB34_HOME}" ]; then
  echo "[ERROR] Coulomb home directory CLB34_HOME not set"
  help
else
  pth2clbdir=${CLB34_HOME}
  echo "CLB34_HOME set to: "$CLB34_HOME
fi


## move file: coulomb_out.dat
if [ -f ${pth2clbdir}/coulomb_out.dat ]; then
  if [ "${CHECKFILE}" -eq 0 ]; then
    mv ${pth2clbdir}/coulomb_out.dat ${pth2clbdir}/gmt_files/${1}-coulomb_out.dat
    echo "...rename and move: coulomb_out.dat..."
    echo "[NEWFILE]: "${pth2clbdir}/gmt_files/${1}-coulomb_out.dat
  else
    echo "[CHECK]: \${CLB34_HOME}/coulomb_out.dat                         EXIST"
  fi
else
  if [ "${CHECKFILE}" -eq 0 ]; then
    echo "[WARNING] "${pth2clbdir}/coulomb_out.dat" does not exist"
  else
    echo "[CHECK]: \${CLB34_HOME}/coulomb_out.dat                     NOT EXIST"
  fi
fi

## move file: gmt_fault_calc_dep.dat
if [ -f ${pth2clbdir}/gmt_fault_calc_dep.dat ]; then
  if [ "${CHECKFILE}" -eq 0 ]; then
    mv ${pth2clbdir}/gmt_fault_calc_dep.dat ${pth2clbdir}/gmt_files/${1}-gmt_fault_calc_dep.dat
    echo "...rename and move: gmt_fault_calc_dep.dat..."
    echo "[NEWFILE]: "${pth2clbdir}/gmt_files/${1}-gmt_fault_calc_dep.dat
  else
    echo "[CHECK]: \${CLB34_HOME}/gmt_fault_calc_dep.dat                  EXIST"
  fi
else
  if [ "${CHECKFILE}" -eq 0 ]; then
    echo "[WARNING] "${pth2clbdir}/gmt_fault_calc_dep.dat" does not exist"
  else
    echo "[CHECK]: \${CLB34_HOME}/gmt_fault_calc_dep.dat              NOT EXIST"
  fi
fi

## move file: gmt_fault_map_proj.dat
if [ -f ${pth2clbdir}/gmt_fault_map_proj.dat ]; then
  if [ "${CHECKFILE}" -eq 0 ]; then
    mv ${pth2clbdir}/gmt_fault_map_proj.dat ${pth2clbdir}/gmt_files/${1}-gmt_fault_map_proj.dat
    echo "...rename and move: gmt_fault_map_proj.dat..."
    echo "[NEWFILE]: "${pth2clbdir}/gmt_files/${1}-gmt_fault_map_proj.dat
  else
    echo "[CHECK]: \${CLB34_HOME}/gmt_fault_map_proj.dat                  EXIST"
  fi
else
  if [ "${CHECKFILE}" -eq 0 ]; then
    echo "[WARNING] "${pth2clbdir}/gmt_fault_map_proj.dat" does not exist"
  else
    echo "[CHECK]: \${CLB34_HOME}/gmt_fault_map_proj.dat              NOT EXIST"
  fi
fi

## move file: gmt_fault_surface.dat
if [ -f ${pth2clbdir}/gmt_fault_surface.dat ]; then
  if [ "${CHECKFILE}" -eq 0 ]; then
    mv ${pth2clbdir}/gmt_fault_surface.dat ${pth2clbdir}/gmt_files/${1}-gmt_fault_surface.dat
    echo "...rename and move: gmt_fault_map_surface.dat..."
    echo "[NEWFILE]: "${pth2clbdir}/gmt_files/${1}-gmt_fault_surface.dat
  else
    echo "[CHECK]: \${CLB34_HOME}/gmt_fault_surface.dat                   EXIST"
  fi
else
  if [ "${CHECKFILE}" -eq 0 ]; then
    echo "[WARNING] "${pth2clbdir}/gmt_fault_surface.dat" does not exist"
  else
    echo "[CHECK]: \${CLB34_HOME}/gmt_fault_surface.dat               NOT EXIST"
  fi
fi

## rename file: GPS_output.csv
if [ -f ${pth2clbdir}/output_files/GPS_output.csv ]; then
  if [ "${CHECKFILE}" -eq 0 ]; then
    mv ${pth2clbdir}/output_files/GPS_output.csv ${pth2clbdir}/gps_data/${1}-gps.disp
    echo "...rename and move: GPS_output.csv..."
    echo "[NEWFILE]: "${pth2clbdir}/gps_data/${1}-gps.disp
  else
    echo "[CHECK]: \${CLB34_HOME}/output_files/GPS_output.csv             EXIST"
  fi
else
  if [ "${CHECKFILE}" -eq 0 ]; then
    echo "[WARNING] "${pth2clbdir}/output_files/GPS_output.csv" does not exist"
  else
    echo "[CHECK]: \${CLB34_HOME}/output_files/GPS_output.csv         NOT EXIST"
  fi
fi

## rename file: Cross_section.dat
if [ -f ${pth2clbdir}/output_files/Cross_section.dat ]; then
  if [ "${CHECKFILE}" -eq 0 ]; then
    mv ${pth2clbdir}/output_files/Cross_section.dat ${pth2clbdir}/output_files/${1}-Cross_section.dat
    echo "...rename and move: Cross_section.dat..."
    echo "[NEWFILE]: "${pth2clbdir}/output_files/${1}-Cross_section.dat
  else
    echo "[CHECK]: \${CLB34_HOME}/output_files/Cross_section.dat          EXIST"
  fi
else
  if [ "${CHECKFILE}" -eq 0 ]; then
    echo "[WARNING] "${pth2clbdir}/output_files/Cross_section.dat" does not exist"
  else
    echo "[CHECK]: \${CLB34_HOME}/output_files/Cross_section.dat      NOT EXIST"
  fi
fi

## rename file: dcff.cou
if [ -f ${pth2clbdir}/output_files/dcff.cou ]; then
  if [ "${CHECKFILE}" -eq 0 ]; then
    mv ${pth2clbdir}/output_files/dcff.cou ${pth2clbdir}/output_files/${1}-dcff.cou
    echo "...rename and move: dcff.cou..."
    echo "[NEWFILE]: "${pth2clbdir}/output_files/${1}-dcff.cou
  else
    echo "[CHECK]: \${CLB34_HOME}/output_files/dcff.dat                    EXIST"
  fi
else
  if [ "${CHECKFILE}" -eq 0 ]; then
    echo "[WARNING] "${pth2clbdir}/output_files/dcff.cou" does not exist"
  else
    echo "[CHECK]: \${CLB34_HOME}/output_files/dcff.dat               NOT EXIST"
  fi
fi

## rename file: dcff_section.cou
if [ -f ${pth2clbdir}/output_files/dcff_section.cou ]; then
  if [ "${CHECKFILE}" -eq 0 ]; then
    mv ${pth2clbdir}/output_files/dcff_section.cou ${pth2clbdir}/output_files/${1}-dcff_section.cou
    echo "...rename and move: dcff_section.cou..."
    echo "[NEWFILE]: "${pth2clbdir}/output_files/${1}-dcff_section.cou
  else
    echo "[CHECK]: \${CLB34_HOME}/output_files/dcff_section.cou           EXIST"
  fi
else
  if [ "${CHECKFILE}" -eq 0 ]; then
    echo "[WARNING] "${pth2clbdir}/output_files/dcff_section.cou" does not exist"
  else
    echo "[CHECK]: \${CLB34_HOME}/output_files/dcff_section.cou       NOT EXIST"
  fi
fi

## rename file: Focal_mech_stress_output.csv
if [ -f ${pth2clbdir}/output_files/Focal_mech_stress_output.csv ]; then
  if [ "${CHECKFILE}" -eq 0 ]; then
    mv ${pth2clbdir}/output_files/Focal_mech_stress_output.csv ${pth2clbdir}/output_files/${1}-Focal_mech_stress_output.csv
    echo "...rename and move: Focal_mech_stress_output.csv..."
    echo "[NEWFILE]: "${pth2clbdir}/output_files/${1}-Focal_mech_stress_output.csv
  else
    echo "[CHECK]: \${CLB34_HOME}/output_files/Focal_mech_stress_output.csv EXIST"
  fi
else
  if [ "${CHECKFILE}" -eq 0 ]; then
    echo "[WARNING] "${pth2clbdir}/output_files/Focal_mech_stress_output.csv" does not exist"
  else
    echo "[CHECK]: \${CLB34_HOME}/output_files/Focal_mech_stress_output.csv NOT EXIST"
  fi
fi

## rename file: Strain.cou
if [ -f ${pth2clbdir}/output_files/Strain.cou ]; then
  if [ "${CHECKFILE}" -eq 0 ]; then
    mv ${pth2clbdir}/output_files/Strain.cou ${pth2clbdir}/output_files/${1}-Strain.cou
    echo "...rename and move: Strain.cou..."
    echo "[NEWFILE]: "${pth2clbdir}/output_files/${1}-Strain.cou
  else
    echo "[CHECK]: \${CLB34_HOME}/output_files/Strain.cou                  EXIST"
  fi
else
  if [ "${CHECKFILE}" -eq 0 ]; then
    echo "[WARNING] "${pth2clbdir}/output_files/Strain.cou" does not exist"
  else
    echo "[CHECK]: \${CLB34_HOME}/output_files/Strain.cou             NOT EXIST"
  fi
fi

## rename file: dilatation_section.cou
if [ -f ${pth2clbdir}/output_files/dilatation_section.cou ]; then
  if [ "${CHECKFILE}" -eq 0 ]; then
    mv ${pth2clbdir}/output_files/dilatation_section.cou ${pth2clbdir}/output_files/${1}-dilatation_section.cou
    echo "...rename and move: dilatation_section.cou..."
    echo "[NEWFILE]: "${pth2clbdir}/output_files/${1}-dilatation_section.cou
  else
    echo "[CHECK]: \${CLB34_HOME}/output_files/dilatation_section.cou     EXIST"
  fi
else
  if [ "${CHECKFILE}" -eq 0 ]; then
    echo "[WARNING] "${pth2clbdir}/output_files/dilatation_section.cou" does not exist"
  else
    echo "[CHECK]: \${CLB34_HOME}/output_files/dilatation_section.cou NOT EXIST"
  fi 
fi

if [ "${CHECKFILE}" -eq 0 ]; then
  echo "...last input: "$1" ..."
fi

# Print exit status
echo "[STATUS] Finished. Exit status: $?"