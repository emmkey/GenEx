# ---------------------------------------------------------
# File: W2_MicroArray_Extension_Final.R
# Title: SWP Programm Woche 2 - Einfuehrung in MicroArrays
# By: Yannic Lapawczyk, Silver Wolf, Michael Krivan
# Date: 01.05.2016
# Version: 1.1 (Praesentationsversion)
# ---------------------------------------------------------

# Installation der packages:
# source("https://bioconductor.org/biocLite.R")
# biocLite("affy")
# biocLite("hgu133plus2.db")
# biocLite("affyQCReport")
# biocLite("affyPLM")

# Initialisiere affy package, hgu133plus2.db (Genzuordnung) und affyQCReport (QC-PDF) im Programm:
library("affy")
library("hgu133plus2.db")
library("affyQCReport")
library("affyPLM")

# Lese alle .CEL-Dateien im aktuellen "Working Directory" in das Objekt "Data" ein:
Data_All <- ReadAffy()
Data_Ohne_Aussreisser <- ReadAffy(filenames = "ND_1_CD14_TNF_90_133Plus_2.CEL", "ND_3_CD14_TNF_90_133Plus_2.CEL", "ND_4_CD14_TNF_90_133Plus_2.CEL", "ND_51_CD14_133Plus_2.CEL", "ND_52_CD14_133Plus_2.CEL", "ND_53_CD14_133Plus_2.CEL")

# Affyimage auslesen:
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
degRNA <- AffyRNAdeg(Data_All)
plotAffyRNAdeg(degRNA)

# Quality-Control PDF erstellen:
QCReport(Data_All,file="W2QC.pdf")

# Heatmap erstellen:
heatmap(exprs(Data_All_rma[1:100,]))
heatmap(exprs(Data_All_mas5[1:100,]))
heatmap(exprs(Data_Ohne_Aussreisser_rma[1:100,]))
heatmap(exprs(Data_Ohne_Aussreisser_mas5[1:100,]))

# Heatmap mit topographischen Farben (gelb, gruen, blau)
heatmap(exprs(Data_All_rma[1:100,]),col=topo.colors(100))
heatmap(exprs(Data_All_mas5[1:100,]),col=topo.colors(100))
heatmap(exprs(Data_Ohne_Aussreisser_rma[1:100,]),col=topo.colors(100))
heatmap(exprs(Data_Ohne_Aussreisser_mas5[1:100,]),col=topo.colors(100))

# Probe Level Model Fitting (Default ist RMA)
Pset_All <- fitPLM(Data_All)

# Parameter Schaetzwerte fuer die ersten 10 AffyIDs
coefs(Pset_All)[1:10,]

# Standardfehler fuer die ersten 10 AffyIDs
se(Pset_All)[1:10,]

# Erstellen der Normalisierungs-Tabellen:

create_timestamp <- function() {
  # Timestamp erstellen fuer den Dateinamen
  now <- Sys.time()
  
  # Doppelpunkte ersetzen
  now <- gsub(":","-",now)
  
  # Luecke entfernen
  now <- gsub(" ","-",now)
  return(now)
}

# Funktion, welche aus einem Datasatz ein Text-File erstellt
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
	
  for(i in 1:length(affyids)) {
	minout1[i] <- min(output[i,3:5])
	maxout1[i] <- max(output[i,3:5])
	mediout1[i] <- median(output[i,3:5])
	sdout1[i] <- sd(output[i,3:5])
	varout1[i] <- var(output[i,3:5])
	minout2[i] <- min(output[i,6:8])
	maxout2[i] <- max(output[i,6:8])
	mediout2[i] <- median(output[i,6:8])
	sdout2[i] <- sd(output[i,6:8])
	varout2[i] <- var(output[i,6:8])
  }
 output_ext <- cbind(output, minout1, minout2, maxout1, maxout2, mediout1, mediout2, sdout1, sdout2, varout1, varout2)
  varNames <- c("Min_Gesund","Min_TNF","Max_Gesund", "Max_TNF", "Median_Gesund", "Median_TNF", "SD_Gesund", "SD_TNF", "Var_Gesund","Var_TNF")
  # header erstellen
  if(isTRUE(headerBoolean)) {
    header <- append(c("AffyID",info),sampleNames(eset),varNames)
    # header in Datei schreiben
    write.table(t(header), file = filename, row.names = FALSE, col.names = FALSE, append = FALSE, sep = "\t")
  }
  
  # output in Datei schreiben
  write.table(output_ext, file=filename, row.names=FALSE, col.names=FALSE, append = TRUE, sep = "\t") 
  print(paste("Erstellt:",filename,sep = " "))
  
}

# Testaufruf mit rma, header und GENENAME:
print_to_file(Data_Ohne_Aussreisser, "rma", TRUE, "GENENAME")
print_to_file(Data_All, "rma", TRUE, "SYMBOL")

# T-Test der Expressionsvektoren der beiden Gruppen (Gesund und TNF)
Data_Gesund <- ReadAffy(filenames = "ND_51_CD14_133Plus_2.CEL", "ND_52_CD14_133Plus_2.CEL", "ND_53_CD14_133Plus_2.CEL")
Data_TNF <- ReadAffy(filenames = "ND_1_CD14_TNF_90_133Plus_2.CEL", "ND_2_CD14_TNF_90_133Plus_2", "ND_3_CD14_TNF_90_133Plus_2.CEL", "ND_4_CD14_TNF_90_133Plus_2.CEL")
eset1 <- rma(Data_Gesund)
eset2 <- rma(Data_TNF)
exprs_vector <- exprs(eset1)
exprs_vector2 <- exprs(eset2)
tt <- t.test(exprs_vector, exprs_vector2, var.equal=TRUE)

# Signal Log Ratio berechnen
ps1 <- probeset(Data_Gesund, affyids[1:length(affyids)])
ps2 <- probeset(Data_TNF, affyids[1:length(affyids)])

for (i in 1:length(affyids)) {
	slr <- pm(ps1[[i]])-mm(ps1[[i]])/pm(ps2[[i]])-mm(ps2[[i]])
}