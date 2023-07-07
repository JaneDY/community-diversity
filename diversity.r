#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly=T)

if(length(args)<2) {
  print(paste0("Usage: ", args[0], "[tax_profile.xls/otu_table.xls] [a/b/ab]"))
  quit()
}

library(vegan)
library(fossil)

data <- read.table(args[1], sep="\t", header=T, row.names=1, comment.char="", check.names=F, quote="")
data <- t(data)

chao <- apply(data, 1, function(x) chao1(x))
ace <- apply(data, 1, function(x) ACE(x))
shannon <- diversity(data, index = "shannon", base = exp(1))
invsimpson <- diversity(data, index = "invsimpson", base = exp(1))

div <- cbind(chao,ace,shannon,invsimpson)
write.table(div, paste0("alpha_div.",args[1]), sep="\t", row.names=T, col.names=NA, quote=F)

dist <- vegdist(data, method="bray")
write.table(as.matrix(dist), paste0("beta_div.",args[1]), sep="\t", row.names=T, col.names=NA, quote=F)
