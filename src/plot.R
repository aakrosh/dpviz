#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

output = args[1]
input  = args[2]

library(ggplot2)
library(reshape2)

# function to normalize the data
standardize <- function(z) {
    colmed <- apply(z, 2, median)
    rv <- sweep(z, 2, colmed,"/")  #subtracting median expression
    return(rv)
}
options(digits=1)

data = read.table(input, header = T)
data = data[,-1]
tmp = standardize(data[,2:ncol(data)])
data = cbind(data[,1], tmp)
names(data)[1] = "POS"
data = melt(data, id.vars = c("POS"))

# maximum coverage I should show in the figure
maxcov = quantile(data$value, 0.99)

p = ggplot(data, aes(POS, value, group = variable, color = variable)) +
    geom_smooth(method = "loess", span = 0.1) + 
    xlab("position on chromosome") +
    ylab("depth on snps") + 
    ggtitle("position vs depth") +
    ylim(0,maxcov)

# if there are more than 10 samples, do not create a legend
if (length(unique(data$variable)) > 10) {
    p = p + theme(legend.position="none")
} else {
    p = p + geom_point(alpha = 0.1)
}   

png(output, width = 960, height = 480)
p
dev.off()
