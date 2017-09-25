#!/usr/bin/env Rscript

require(argparser)

p <- arg_parser("Plot cell positions")
p <- add_argument(p, "--input", help = "Input cell positions with cluster index in the third column")

argv <- parse_args(p)
input <- argv$input

if(is.na(input)){
  print(p)
  stop("# ERROR: Input file is required with --input")
}

dat <- read.table(input)

outfile = paste0(input, ".pdf")
pdf(outfile, width = 6, height = 6)
plot(dat[,1], dat[,2], col = dat[,3], xlab = "X", ylab = "Y")
dev.off()

