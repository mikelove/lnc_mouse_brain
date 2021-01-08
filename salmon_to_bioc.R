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
gse <- summarizeToGene(se, varReduce=TRUE)
gse$litter <- factor(gse$litter)
levels(gse$litter) <- 1:nlevels(gse$litter)
save(se, file="se.rda")
save(gse, file="gse.rda")

library(SummarizedExperiment)
colData(gse)
round(colSums(assay(gse))/1e6,1)

library(DESeq2)
dds <- DESeqDataSet(gse, ~condition)
vsd <- vst(dds, blind=FALSE)
plotPCA(vsd)
plotPCA(vsd, intgroup="litter")
plotCounts(dds, grep("ENSMUSG00000074637", rownames(dds)))
