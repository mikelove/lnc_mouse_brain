coldata <- read.csv("SraRunColdatale.txt", stringsAsFactors=FALSE)
coldata <- coldata[,c("Run","genotype.variation","litternumber_id","lncrna_previous_name","source_name","Timepoint")]
names(coldata) <- c("run","condition","litter","name0","name","time")
coldata$condition <- factor(coldata$condition, levels=c("WT","lincRNA knockout (KO)"))
levels(coldata$condition) <- c("WT","KO")
coldata <- coldata[order(coldata$condition),]
write.csv(coldata, file="coldata.csv", row.names=FALSE, quote=FALSE)

coldata$files <- file.path("quants",coldata$run,"quant.sf")
coldata$names <- coldata$run

#BiocManager::install("tximeta")
library(tximeta)
se <- tximeta(coldata)
save(se, file="se.rda")

library(SummarizedExperiment)
colData(se)
round(colSums(assay(se))/1e6,1)
