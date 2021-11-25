OPT <- commandArgs(trailingOnly = TRUE)
WD <- OPT[1]
PROT <-  OPT[2]

setwd(as.character(WD))

file5 <- paste0("./",PROT,".pH_5.dat")
file7 <- paste0("./",PROT,".pH_7.dat")

pH_7 <- read.table(file7, quote="\"",sep=" ")
pH_5 <- read.table(file5, quote="\"",sep=" ")

Diff <-pH_5 - pH_7

write.table(as.matrix(Diff), file = "tmp" ,
          sep = " ", quote = F, row.names = F,col.names = F)
 
