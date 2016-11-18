#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

output = args[1]
input  = args[2]

library(ggplot2)
library(reshape2)

data = read.table(input, header = T)
data = data[,-1]
data = melt(data, id.vars = c("POS"))

p = ggplot(data, aes(POS, value, group = variable, color = variable)) +
    geom_smooth(span = 0.1) + 
    geom_point(alpha = 0.5) +
    xlab("position on chromosome") +
    ylab("depth on snps") + 
    ggtitle("position vs depth") 
pdf(output)
p
dev.off()
