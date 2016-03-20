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

# Lade affy package im Programm:
library("affy")

# Lese alle .CEL-Dateien im "Working Directory" ein:
Data <- ReadAffy()

# RNA-Normalisierung:
# Currently the rma function implements RMA in the following manner:
# 1.Probe specific correction of the PM probes using a model based on observed intensity being the sum of signal and noise
# 2.Normalization of corrected PM probes using quantile normalization
# 3.Calculation of Expression measure using median polish
eset <- rma(Data)
# Alternative Normalisierung Beispiel:
# eset <- mas5(Data)

# Speichern der Variable eset (Klasse: ExpressionSet) in Textdatei:
# write.exprs(eset, file="mydata.txt")

# Wandele "Probe level data" in "Expression values" um:
# eset <- expresso(Dilution, normalize.method="qspline", bgcorrect.method="rma", pmcorrect.method="pmonly", summary.method="liwong")

# Ausgeben weiterer Informationen der Samples (falls gegeben):
# phenoData(Data)
# pData(Data)

# Ausgegeben der MMs, PMs und affyIDs:
# pm(Data)
# mm(Data)
# probeNames(Data)

# Diagramm-Erstellung der Rohdaten:
hist(Data)
# boxplot(Data)
# MAplot(Dilution,pairs=TRUE,plot.method="smoothScatter")

# Richtige Normalisierung:
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
