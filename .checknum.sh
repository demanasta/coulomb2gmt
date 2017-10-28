#!/bin/bash
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

