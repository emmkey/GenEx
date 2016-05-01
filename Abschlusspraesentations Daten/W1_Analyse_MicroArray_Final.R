# ---------------------------------------------------------
# File: W1_Analyse_MicroArray_Final.R
# Title: SWP Programm Woche 1 - Einfuehrung in MicroArrays
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
Data <- ReadAffy()

# Ausgegeben der MMs, PMs und affyIDs:
# pm(Data)
# mm(Data)
# probeNames(Data)

# RMA-Normalisierung:
Data.normalized <- rma(Data)

# Alternative (mas5) Normalisierung:
# eset <- mas5(Data, sc = 150)

# Diagramm-Erstellung:
vec <- c(1,3,4,5,6,7)
hist(Data)
hist(Data[,vec])
hist(Data.normalized)

# RNA-Degradation-Plot:
degRNA <- AffyRNAdeg(Data)
plotAffyRNAdeg(degRNA)

# Affyimage auslesen:
image(Data)

# Quality-Control PDF erstellen:
QCReport(Data,file="W1QC.pdf")

# affyIDs den entsprechenden Genen zuordnen:
eset <- Data.normalized

# affyIDs aus dem ExpressionSet auslesen:
affyids <- featureNames(eset)

# 6 Beispiel-IDs ausgeben:
cat("\nAffyID Beispiele:\n")
print(affyids[1:6])

# Mit columns(hgu133plus2.db) kann abgefragt werden, was man aus den affyIDs erhalten moechte:
cat("\nBeispiele fuer 'Ausgaben' mittels dem Befehl 'select':\n")
print(columns(hgu133plus2.db))

# Wir entscheiden uns hier erstmal nur fuer "GENENAME" (mehrere koennen als Vektor eingegeben werden):
genenames <- select(hgu133plus2.db, affyids, "GENENAME")

# Wir erhalten eine Matrix mit folgenden Dimensionen:
cat("\nMatrixdimension:\n")
print(dim(genenames))
cat("1: AffyID, 2: Genname\n")

# Beispiel fuer Gennamen mit dazugehoeriger AffyID abfragen:
cat("\nBeispiele fuer Gennamen mit dazugehoeriger AffyID:\n")
print(genenames[1:5, ])