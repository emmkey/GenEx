#package "hgu133plus2.db" muss installiert werden
#hgu133plus2.db laden
library(hgu133plus2.db)
#affy laden
library(affy)
#Alle CEL-Files aus Working-Directory einlesen
mydata <- ReadAffy()
#RMA-Normalisierung auf Daten anwenden und in ExpressionSet speichern
eset <- rma(mydata)
#Alle AffyIDs aus ExpressionSet auslesen
affyids <- featureNames(eset)
#6 Beispiel-IDs ausgeben
cat("\nAffyID Beispiele:\n")
print(affyids[1:6])
#mit columns(hgu133plus2.db) kann abgefragt werden
#,was man aus den affyids erhalten moechte
cat("\nBeispiele fuer ''Ausgaben'' mit select\n")
print(columns(hgu133plus2.db))
#Wir entscheiden uns hier erstmal nur fuer "GENENAME"
#(mehrere koennten als Vektor eingegeben werden)
genenames <- select(hgu133plus2.db, affyids, "GENENAME")
#Wir erhalten eine Matrix mit folgenden Dimensionen
cat("\nMatrixdimension:\n")
print(dim(genenames))
cat("1: AffyID, 2: Genname\n")
#Beispiel fuer Gennamen mit dazugehoeriger AffyID abfragen
cat("\nBeispiele fuer Gennamen mit dazugehoeriger AffyID:\n")
print(genenames[1:5, ])


