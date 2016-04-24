# Lade affy package, hgu133plus2.db (Genzuordnung) und affyQCReport (QC-PDF) im Programm:
library("affy")
library("hgu133plus2.db")


#CEL-Files einlesen
data_to_compare <- ReadAffy(filenames = "ND_1_CD14_TNF_90_133Plus_2.CEL", "ND_51_CD14_133Plus_2.CEL")

#Normalisieren
normalized <- rma(data_to_compare)
exprs_vector <- exprs(normalized)
#print(dim(exprs_vector))

print(t.test(exprs_vector[,1], exprs_vector[,2], paired=TRUE))
