
# Lade affy package, hgu133plus2.db (Genzuordnung) und affyQCReport (QC-PDF) im Programm:
library("affy")
library("hgu133plus2.db")
library("affyQCReport")
library("affyPLM")



print(getwd())

#Ordner erstellen
dir.create("/home/admini/Uni/Softwareprojekt/GenEx/website/Output/firsttest/table", showWarnings = TRUE, recursive = TRUE, mode = "0777")
dir.create("/home/admini/Uni/Softwareprojekt/GenEx/website/Output/firsttest/wd", showWarnings = TRUE, recursive = TRUE, mode = "0777")
dir.create("/home/admini/Uni/Softwareprojekt/GenEx/website/Output/firsttest/plots", showWarnings = TRUE, recursive = TRUE, mode = "0777")

#WD setzen
setwd("/home/admini/Uni/Softwareprojekt/GenEx/website/Output/wd")

Data_All <- ReadAffy()
capabilities()
#Histogramm als Datei schreiben
#png("../firsttest/plots/histogram_unnormalized.png", type="cairo")
png("/tmp/test14.png")
hist(exprs(Data_All))


