# ---------------------------------------------------------
# File: W3_MicroArray_Scatterplots_Final.R
# Title: SWP Programm Woche 3 - Einfuehrung in MicroArrays
# By: Yannic Lapawczyk, Silver Wolf, Michael Krivab
# Date: 01.05.2016
# Version: 1.1 (Praesentationsversion)
# ---------------------------------------------------------

# Installation der packages:
# source("https://bioconductor.org/biocLite.R")
# biocLite("affy")
# biocLite("hgu133plus2.db")
# biocLite("affyQCReport")

# Initialisiere affy package, hgu133plus2.db (Genzuordnung) und affyQCReport (QC-PDF) im Programm:
library("affy")
library("hgu133plus2.db")
library("affyQCReport")

# Lese alle .CEL-Dateien im aktuellen "Working Directory" in das Objekt "Data" ein:
Data_All <- ReadAffy()
Data_All_rma <- rma(Data_All)
Data_All_mas5 <- mas5(Data_All, sc=150)

# Erstelle Namen-Vektor der .CEL-Dateien:
Data_names <- c("ND_1_CD14_TNF_90_133Plus_2.CEL","ND_2_CD14_TNF_90_133Plus_2.CEL","ND_3_CD14_TNF_90_133Plus_2.CEL", "ND_4_CD14_TNF_90_133Plus_2.CEL", "ND_51_CD14_133Plus_2.CEL", "ND_52_CD14_133Plus_2.CEL","ND_53_CD14_133Plus_2.CEL")

# Scatterplots:
for (i in 1:7) {
  for (j in 1:7){
    plotname1 <- paste("ScatterPlot", i, sep = "_")
    plotname1 <- paste(plotname1, j, sep = "_")
    plotname1 <- paste(plotname1, ".png", sep = "")
    png(filename=plotname1, width = 1500, height = 1500)
    plot(exprs(Data_All)[,i],exprs(Data_All)[,j], xlab=Data_names[i], ylab=Data_names[j], log = "xy", pch = ".", main = plotname1)
    dev.off()
    
    plotname2 <- paste("ScatterPlot_rma", i, sep = "_")
    plotname2 <- paste(plotname2, j, sep = "_")
    plotname2 <- paste(plotname2, ".png", sep = "")
    png(filename=plotname2, width = 1500, height = 1500)
    plot(exprs(Data_All_rma)[,i],exprs(Data_All_rma)[,j], xlab=Data_names[i], ylab=Data_names[j], log = "xy", pch = ".", main = plotname2)
    dev.off()
    
    plotname3 <- paste("ScatterPlot_mas5", i, sep = "_")
    plotname3 <- paste(plotname3, j, sep = "_")
    plotname3 <- paste(plotname3, ".png", sep = "")
    png(filename=plotname3, width = 1500, height = 1500)
    plot(exprs(Data_All_mas5)[,i],exprs(Data_All_mas5)[,j], xlab=Data_names[i], ylab=Data_names[j], log = "xy", pch = ".", main = plotname3)
    dev.off()
  }
}

# plot(pm(Data_All_rma)[, 1:2], log = "xy", pch = ".", main = "pm")
# plot(mm(Data_All_rma)[, 1:2], log = "xy", pch = ".", main = "mm")
# plot(pm(Data_All_mas5)[, 1:2], log = "xy", pch = ".", main = "pm")
# plot(mm(Data_All_mas5)[, 1:2], log = "xy", pch = ".", main = "mm")