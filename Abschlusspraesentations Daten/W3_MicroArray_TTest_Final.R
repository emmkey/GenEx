# ---------------------------------------------------------
# File: W3_MicroArray_TTest_Final.R
# Title: SWP Programm Woche 3 - Einfuehrung in MicroArrays
# By: Yannic Lapawczyk, Silver Wolf, Michael Krivab
# Date: 01.05.2016
# Version: 1.1 (Praesentationsversion)
# ---------------------------------------------------------

# Installation der packages:
# source("https://bioconductor.org/biocLite.R")
# biocLite("affy")
# biocLite("hgu133plus2.db")

# Initialisiere affy package und hgu133plus2.db (Genzuordnung) im Programm:
library("affy")
library("hgu133plus2.db")

# CEL-Files einlesen:
data_to_compare <- ReadAffy(filenames = "ND_1_CD14_TNF_90_133Plus_2.CEL", "ND_51_CD14_133Plus_2.CEL")

# Normalisieren:
normalized <- rma(data_to_compare)
exprs_vector <- exprs(normalized)
#print(dim(exprs_vector))

# T-Test:
print(t.test(exprs_vector[,1], exprs_vector[,2], paired=TRUE))