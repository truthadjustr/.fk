#!/bin/awk -f
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

BEGIN {

}

{
    if (!tokenDistinct[$3]) {
        tokenDistinct[$3] = $0
    } else {
        if ($1 ~ /::/) {
            tokenDistinct[$3] = $0
        }
    }
}

END {
    for (line in tokenDistinct) {
        if (a=="") { 
            print_ctagsline2(tokenDistinct[line])
        } else {
            split(tokenDistinct[line],spacegap," ")
            #printf " %s",spacegap[1]
            print spacegap[1]
        }
    }
}

########## helper functions ############

function print_ctagsline(spacegap,len) {
    printf "[%s_@_%d] %s ",spacegap[2],spacegap[3],spacegap[1]
    # skip printing filename at index 4
    for (i=5;i<=len;i++) {
        printf "%s ",spacegap[i]
    }
    printf "\n"
}

function print_ctagsline2(line) {
    gsub(/\s+/," ",line)
   	len = split(line,spacegap," ")
		print_ctagsline(spacegap,len)
}

function basename(file) {
    sub(".*/", "", file)
    return file
}

function dirname(file) {
    p2len = split(file,p2,"/")
    for (i=1;i <p2len;i++) {
        if (i == 1) dir = "/"
        else dir = dir p2[i] "/"
    }

    return dir
}

function concat_array(a,b,c) {
    for (i in a) {
        c[++nc]=a[i]
    }
    for (i in b) {
       c[++nc]=b[i]
    }
}

function push(A,B) { 
    A[length(A)+1] = B 
}
