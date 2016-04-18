# Lade affy package, hgu133plus2.db (Genzuordnung) und affyQCReport (QC-PDF) im Programm:
library("affy")
library("hgu133plus2.db")
library("affyQCReport")
library("affyPLM")

print(getwd())


Data_All <- ReadAffy()

#Histogramm als Datei schreiben
png("../plots/histogram_unnormalized.png")
hist(exprs(Data_All))