# cell-position-clustering

## Requirements

- [perl](https://www.perl.org/)
- [R](https://www.r-project.org/)
- [MCL](https://micans.org/mcl/)
- [argparser](https://mirrors.ustc.edu.cn/CRAN/)

## Steps required for clustering cell positions

    perl cal-distance.pl cell-position.txt
    mcl cell-position.distance.txt -I 1.3 --abc -o mcl-cell-position-$trt.out
    cat mcl-cell-position-$trt.out | perl -alne 'print scalar(@F)' > mcl-cell-position-$trt.out.cluster-size.txt
    perl make-cluster.pl cell-position.txt mcl-cell-position.out > cluster-final-cell-position.txt
    plot-cell-positions.R cluster-final-cell-position.txt


