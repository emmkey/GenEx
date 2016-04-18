# Lade affy package, hgu133plus2.db (Genzuordnung) und affyQCReport (QC-PDF) im Programm:
library("affy")
library("hgu133plus2.db")
library("affyQCReport")
library("affyPLM")

# Lese .CEL-Dateien im "Working Directory" ein:
data <- ReadAffy()