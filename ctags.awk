#!/usr/bin/awk -f
#

########
# Where:
# c  classes --------------------------------------------> class
# d  macro definitions ----------------------------------> macro
# e  enumerators (values inside an enumeration) ---------> enumerator
# f  function definitions -------------------------------> function
# g  enumeration names ----------------------------------> enum
# l  local variables [off] ------------------------------> local
# m  class, struct, and union members -------------------> member
# n  namespaces -----------------------------------------> namespace
# p  function prototypes [off] --------------------------> prototype
# s  structure names ------------------------------------> struct
# t  typedefs -------------------------------------------> typedef
# u  union names ----------------------------------------> union
# v  variable definitions -------------------------------> variable
# x external and forward variable declarations [off] ----> externvar

@include "/home/da185157/.fk/routines.awk"

BEGIN {
    #p=ENVIRON["_"]
    #p2len = split(p,p2,"/")
    #home=ENVIRON["fkhomedir"]
    #printf "**** begin(%s) ****\n",home
    #printf "<< ==== %s ==== >>\n",H
    #printf "<< ==== %s ==== >>\n",Q
    idx = 0
}

$2 == "macro" {

}

$2 == "enumerator" {

}

$2 == "enum" {

}

$2 == "local" {

}

$2 == "namespace" {

}

$2 == "prototype" {

}

$2 == "struct" {

}

$2 == "typedef" {

}

$2 == "union" {

}

$2 == "variable" {

}

$2 == "externvar" {

}

$2 == "function" {
    if (!functionDistinct[$3]) {
        functionDistinct[$3] = $0
    } else {
        if ($1 ~ /::/) {
            functionDistinct[$3] = $0
        }
    }
}

$2 == "member" {
    if (!memberDistinct[$3]) {
        memberDistinct[$3] = $0
    } else {
        if ($1 ~ /::/) {
            memberDistinct[$3] = $0
        }
    }
}

$2 == "class" {
    if (!classDistinct[$3]) {
        classDistinct[$3] = $1
    } else {
        if ($1 ~ /::/) {
            classDistinct[$3] = $1
        }
    }
}

$1 ~ /::/ {
    n = split($1,obj,"::")
    className = obj[1]
    #classes[className] = classes[className]"|"obj[2]
    mem = obj[2]

    #printf "\n%s:\n",className
    for (xx = 3;xx <=n;xx++) {
        mem=mem"::"obj[xx]
        #printf "\t%s ",obj[xx]
    }
    
    classes[className] = classes[className]"|"mem
    #className[idx++] = obj[2]
    mem="" 
}

END {
    #for (line in functionDistinct) {
    #    gsub(/\s+/," ",functionDistinct[line])
    #    len = split(functionDistinct[line],L," ")
    #    print_ctagsline(L,len)
    #}

    #for (x in classes) {
    #    n = split(classes[x],members,"|")    
    #    printf "%s:",x
    #    for (member in members) {
    #        printf "    %s\n",members[member]
    #    }
    #    printf "--------------------------------------------------------------------------------\n"
    #}

    for (c in classDistinct) {
        print classDistinct[c]
    }
}
