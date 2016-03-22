# ---------------------------------------------------------
# File: W1_Analyse_MicroArray.R
# Title: SWP Programm Woche 1 - Einfuehrung in MicroArrays
# By: Yannic Lapawczyk, Silver Wolf, Michael Krivab
# Date: 19.03.2016
# Version: 1.0 (Praesentationsversion)
# ---------------------------------------------------------

# Installation:
source("https://bioconductor.org/biocLite.R")
biocLite("affy")
bioLite ("hgu133plus2.db")

# Lade affy package und hgu133plus2.db (fuehr spaetere Genzuordnung) im Programm:
library("affy")
library("hgu133plus2.db")

# Lese alle .CEL-Dateien im "Working Directory" ein:
Data <- ReadAffy()

# Alternative Normalisierung Beispiel:
# eset <- mas5(Data)

# Ausgegeben der MMs, PMs und affyIDs:
# pm(Data)
# mm(Data)
# probeNames(Data)

# Normalisierung:
Data.normalized <- normalize(Data)

# Diagramm-Erstellung:
vec <- c(1,3,4,5,6,7)
hist(Data)
hist(Data[,vec])
hist(Data.normalized)
hist(Data.normalized[,vec])

# RNA-Degradation-Plot:
degR1 <- AffyRNAdeg(Data)
degR2 <- AffyRNAdeg(Data[,vec])
degN1 <- AffyRNAdeg(Data.normalized)
degN2 <- AffyRNAdeg(Data.normalized[,vec])
plotAffyRNAdeg(degR1)
plotAffyRNAdeg(degR2)
plotAffyRNAdeg(degN1)
plotAffyRNAdeg(degN2)

# RNA-Normalisierung:
eset <- rma(Data)

# affyIDs zu Genen zuordnen:

# Alle affyIDs aus ExpressionSet auslesen:
affyids <- featureNames(eset)

# 6 Beispiel-IDs ausgeben:
cat("\nAffyID Beispiele:\n")
print(affyids[1:6])

# Mit columns(hgu133plus2.db) kann abgefragt werden, was man aus den affyIDs erhalten moechte:
cat("\nBeispiele fuer ''Ausgaben'' mit select\n")
print(columns(hgu133plus2.db))

# Wir entscheiden uns hier erstmal nur fuer "GENENAME" (mehrere koennten als Vektor eingegeben werden):
genenames <- select(hgu133plus2.db, affyids, "GENENAME")

# Wir erhalten eine Matrix mit folgenden Dimensionen:
cat("\nMatrixdimension:\n")
print(dim(genenames))
cat("1: AffyID, 2: Genname\n")

# Beispiel fuer Gennamen mit dazugehoeriger AffyID abfragen
cat("\nBeispiele fuer Gennamen mit dazugehoeriger AffyID:\n")
print(genenames[1:5, ])