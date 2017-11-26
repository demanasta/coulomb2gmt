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
#    filename              : checknum.sh
#                            NAME=checknum
#    version               : v-1.0
#                            VERSION=v1.0
#                            RELEASE=rc
#    licence               : MIT
#    created               : SEP-2017
#    usage                 : called from ./coulomb2gmt.sh
#    exit code(s)          : 0 -> success
#                          : 1 -> error
#    discription           : Check integer,float, natural number
#    uses                  : 
#    notes                 :
#    detailed update list  : LAST_UPDATE=OCT-2017
#                 OCT-2017 : First release.
#    contact               : Demitris Anastasiou (dganastasiou@gmail.com)
#    ----------------------------------------------------------------------
# ==============================================================================

# N={0,1,2,3,...} by syntaxerror
function isNaturalNumber()
{
 [[ ${1} =~ ^[0-9]+$ ]]
}
    # Z={...,-2,-1,0,1,2,...} by karttu
function isInteger() 
{
 [[ ${1} == ?(-)+([0-9]) ]]
}
    # Q={...,-½,-¼,0.0,¼,½,...} by karttu
function isFloat() 
{
 [[ ${1} == ?(-)@(+([0-9]).*([0-9])|*([0-9]).+([0-9]))?(E?(-|+)+([0-9])) ]]
}
    # R={...,-1,-½,-¼,0.E+n,¼,½,1,...}
function isNumber()
{
 isNaturalNumber $1 || isInteger $1 || isFloat $1
}

