# ---------------------------------------------------------
# File: W2_MicroArray_Extension.R
# Title: SWP Programm Woche 2 - Einfuehrung in MicroArrays
# By: Yannic Lapawczyk, Silver Wolf, Michael Krivab
# Date: 27.03.2016
# Version: 1.0 (Praesentationsversion)
# ---------------------------------------------------------

# Installation:
source("https://bioconductor.org/biocLite.R")
biocLite("affy")
biocLite("hgu133plus2.db")
biocLite("affyQCReport")

# Lade affy package, hgu133plus2.db (Genzuordnung) und affyQCReport (QC-PDF) im Programm:
library("affy")
library("hgu133plus2.db")
library("affyQCReport")

# Lese .CEL-Dateien im "Working Directory" ein:
Data_All <- ReadAffy()
Data_Ohne_Aussreisser <- ReadAffy(filenames = "ND_1_CD14_TNF_90_133Plus_2.CEL", "ND_3_CD14_TNF_90_133Plus_2.CEL", "ND_4_CD14_TNF_90_133Plus_2.CEL", "ND_51_CD14_133Plus_2.CEL", "ND_52_CD14_133Plus_2.CEL", "ND_53_CD14_133Plus_2.CEL")

# Image auslesen:
image(Data_All)

# Normalisierung:
Data_All_rma <- rma(Data_All)
Data_All_mas5 <- mas5(Data_All,sc ="150")

Data_Ohne_Aussreisser_rma <- rma(Data_Ohne_Aussreisser)
Data_Ohne_Aussreisser_mas5 <- mas5(Data_Ohne_Aussreisser,sc ="150")

# Histogramm-Erstellung:
hist(Data_All)
hist(Data_Ohne_Aussreisser)
hist(Data_All_rma)
hist(Data_All_mas5)
hist(Data_Ohne_Aussreisser_rma)
hist(Data_Ohne_Aussreisser_mas5)

# RNA-Degradation-Plot:
RNAdeg_All <- AffyRNAdeg(Data_All)
RNAdeg_Ohne_Aussreisser <- AffyRNAdeg(Data_Ohne_Aussreisser)

plotAffyRNAdeg(RNAdeg_All)
plotAffyRNAdeg(RNAdeg_Ohne_Aussreisser)

# Quality-Control PDF erstellen:
QCReport(Data_All,file="W2QC_All.pdf")
QCReport(Data_Ohne_Aussreisser,file="W2QC_Ohne_Aussreisser.pdf")

# Heatmap erstellen:
heatmap(exprs(Data_All_rma[1:100,]))

# Ausgegeben der MMs, PMs und affyIDs:
# pm(Data_All)
# mm(Data_All)
# probeNames(Data_All)

# affyIDs zu Genen zuordnen:

# Alle affyIDs aus ExpressionSet auslesen:
# affyids <- featureNames(Data_All_rma)

# 6 Beispiel-IDs ausgeben:
# cat("\nAffyID Beispiele:\n")
# print(affyids[1:6])

# Mit columns(hgu133plus2.db) kann abgefragt werden, was man aus den affyIDs erhalten moechte:
# cat("\nBeispiele fuer ''Ausgaben'' mit select\n")
# print(columns(hgu133plus2.db))

# Wir entscheiden uns hier erstmal nur fuer "GENENAME" (mehrere koennten als Vektor eingegeben werden):
# genenames <- select(hgu133plus2.db, affyids, "GENENAME")

# Wir erhalten eine Matrix mit folgenden Dimensionen:
# cat("\nMatrixdimension:\n")
# print(dim(genenames))
# cat("1: AffyID, 2: Genname\n")

# Beispiel fuer Gennamen mit dazugehoeriger AffyID abfragen:
# cat("\nBeispiele fuer Gennamen mit dazugehoeriger AffyID:\n")
# print(genenames[1:5, ])