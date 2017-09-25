# cell-position-clustering

Three steps required for clustering cell positions

    perl cal-distance.pl cell-position.txt
    mcl cell-position.distance.txt -I 1.3 --abc -o mcl-cell-position-$trt.out
    cat mcl-cell-position-$trt.out | perl -alne 'print scalar(@F)' > mcl-cell-position-$trt.out.cluster-size.txt
    perl make-cluster.pl cell-position.txt mcl-cell-position.out > cluster-final-cell-position.txt


