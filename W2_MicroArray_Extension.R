# ---------------------------------------------------------
# File: W2_MicroArray_Extension.R
# Title: SWP Programm Woche 2 - Einfuehrung in MicroArrays
# By: Yannic Lapawczyk, Silver Wolf, Michael Krivan
# Date: 29.03.2016
# Version: 1.0 (Praesentationsversion)
# ---------------------------------------------------------

# Installation:
source("https://bioconductor.org/biocLite.R")
biocLite("affy")
biocLite("hgu133plus2.db")
biocLite("affyQCReport")
biocLite("affyPLM")

# Lade affy package, hgu133plus2.db (Genzuordnung) und affyQCReport (QC-PDF) im Programm:
library("affy")
library("hgu133plus2.db")
library("affyQCReport")
library("affyPLM")

# Lese .CEL-Dateien im "Working Directory" ein:
Data_All <- ReadAffy()
Data_Ohne_Aussreisser <- ReadAffy(filenames = "ND_1_CD14_TNF_90_133Plus_2.CEL", "ND_3_CD14_TNF_90_133Plus_2.CEL", "ND_4_CD14_TNF_90_133Plus_2.CEL", "ND_51_CD14_133Plus_2.CEL", "ND_52_CD14_133Plus_2.CEL", "ND_53_CD14_133Plus_2.CEL")

# Image auslesen:
image(Data_All)

# Normalisierung:
Data_All_rma <- rma(Data_All)
Data_All_mas5 <- mas5(Data_All, sc=150)

Data_Ohne_Aussreisser_rma <- rma(Data_Ohne_Aussreisser)
Data_Ohne_Aussreisser_mas5 <- mas5(Data_Ohne_Aussreisser, sc=150)

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
heatmap(exprs(Data_All_mas5[1:100,]))

heatmap(exprs(Data_Ohne_Aussreisser_rma[1:100,]))
heatmap(exprs(Data_Ohne_Aussreisser_mas5[1:100,]))

# Heatmap mit topographischen Farben(gelb, gruen, blau)
heatmap(exprs(Data_All_rma[1:100,]),col=topo.colors(100))
heatmap(exprs(Data_All_mas5[1:100,]),col=topo.colors(100))
heatmap(exprs(Data_Ohne_Aussreisser_rma[1:100,]),col=topo.colors(100))
heatmap(exprs(Data_Ohne_Aussreisser_mas5[1:100,]),col=topo.colors(100))

# Probe Level Model Fitting (Default ist RMA)

Pset_All <- fitPLM(Data_All)
Pset_OA <- fitPLM(Data_Ohne_Aussreisser)

  # Parameter Schaetzwerte für die ersten 10 AffyIDs
  coefs(Pset_All)[1:10,]
  coefs(Pset_OA)[1:10,]
  
  # Standardfehler für die ersten 10 AffyIDs
  se(Pset_All)[1:10,]
  se(Pset_All)[1:10,]


# Erstellen der beiden Normalisierungs-Tabellen:

create_timestamp <- function() {
  
  # Timestamp erstellen fuer den Dateinamen
  now <- Sys.time()
  
  # Doppelpunkte ersetzen
  now <- gsub(":","-",now)
  
  # Luecke entfernen
  now <- gsub(" ","-",now)
  return(now)
}

# Funktion, die aus einem Datasatz ein Text-File erstellt
# dataset: Datensatz (engelesene CEL-Files)
# norm: Normalisierungsvariante (z.B. rma oder mas5)
# headerBoolean: TRUE oder FALSE => Soll Text-File header haben oder nicht
# info: Welche zusaetzliche Information mit geschrieben werden soll (z.b. GENENAME oder SYMBOL)
print_to_file <- function(dataset, norm, headerBoolean, info) {
  # Aktuelle Uhrzeit ablesen
  timestamp <- create_timestamp()
  
  # Normalisierungsmethode und Info mit an Dateinamen haengen
  filename <- paste(timestamp, norm, sep = "_")
  filename <- paste(filename, info, sep = "_")
  
  # Dateiende anhaengen
  filename <- paste(filename, ".txt", sep = "") 
  
  # Expressionset erstellen
  if (norm == "rma") {
    eset <- rma(dataset)
  }
  else if (norm == "mas5") {
    eset <- mas5(dataset, sc = 150)
  }
  else{
    print("Fehler: Keine zulaessige Normalisierung.")
  }
  
  # Vektor erstellen, der alle 7 RMA/MAS5-Werte enthaelt
  exprs_vector <- exprs(eset)
  
  # Alle AffyIDs aus Expressionset auslesen
  affyids <- featureNames(eset)
  
  # Geninfo auslesen
  geninfo <- select(hgu133plus2.db, affyids, info)
  
  # Falls nicht zu allen affyids die "info" gefunden wurde:
  # Alle affyids durchgehen und schauen, ob ein Genname gefunden wurde
  if(length(affyids) != nrow(geninfo)) {
    print("Korrigiere Info-Vektor...")
    
    # Vektor mit Infos ueberarbeiten, damit auch affyids enthalten sind
    # Fuer die keine Info gefunden wurde
    # Leeren Vektor erstellen
    modded_info <- vector(,nrow(exprs_vector))
    
    for(i in 1:length(affyids)) {
      # Position von affyid in "geninfo" rausschreiben
      position <- match(affyids[i],geninfo[,1])
      # Wenn position != NA, dann ist die affyid in "geninfo"
      # Und die Geninfo kann uebernommen werden
      # Wenn fuer die affyid keine Info gefunden wurde,
      # Wird ein "NotFound" eingefuegt
      
      if(!is.na(position)) {
        modded_info[i] <- geninfo[position,2]
      } else {
        modded_info[i] <- "NotFound"
      } 
    }
  }
  # Wenn Laenge nicht unterschiedlich, dann einfach alle uebernehmen
  else {
    modded_info <- geninfo[,2]
  }
  
  # Geninfo in Matrix einschieben
  output <- cbind(affyids,modded_info,exprs_vector)
  
  # header erstellen
  if(isTRUE(headerBoolean)) {
    header <- append(c("AffyID",info),sampleNames(eset),2)
    # header in Datei schreiben
    write.table(t(header), file = filename, row.names = FALSE, col.names = FALSE, append = FALSE, sep = "\t")
  }
  
  # output in Datei schreiben
  write.table(output, file=filename, row.names=FALSE, col.names=FALSE, append = TRUE, sep = "\t") 
  print(paste("Erstellt:",filename,sep = " "))
  
}

# Testaufruf mit rma, header und GENENAME:
print_to_file(Data_All, "rma", TRUE, "GENENAME")
print_to_file(Data_All, "mas5", TRUE, "SYMBOL")

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
