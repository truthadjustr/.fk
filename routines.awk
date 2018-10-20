function print_ctagsline(spacegap,len) {
    printf "[%s@%d] %s ",spacegap[2],spacegap[3],spacegap[1]
    # skip printing filename at index 4
    for (i=5;i<len;i++) {
        printf "%s ",spacegap[i]
    }
    printf "\n"
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
