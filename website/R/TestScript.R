# ---------------------------------------------------------
# File: Cel2Table.R
# Title: SWP Programm Woche - Einfuehrung in MicroArrays
# By: Yannic Lapawczyk, Silver Wolf, Michael Krivan
# Date: 24.04.2016
# ---------------------------------------------------------

# Ueberprueft, ob die benötigten packages installiert wurden und installiert diese ggf.

source("https://bioconductor.org/biocLite.R")

checklib1 <- require(affy)
checklib2 <- require(hgu133plus2.db)
checklib3 <- require(affyQCReport)
checklib4 <- require(affyPLM)
checklib5 <- require(PECA)

if (checklib1 != TRUE) {
	biocLite("affy")
}

if (checklib2 != TRUE) {
	biocLite("hgu133plus2.db")
}

if (checklib3 != TRUE) {
	biocLite("affyQCReport")
}

if (checklib4 != TRUE) {
	biocLite("affyPLM")
}
if (checklib5 != TRUE) {
	biocLite("PECA")
}

# Lade affy package, hgu133plus2.db (Genzuordnung) und affyQCReport (QC-PDF) im Programm:
library("affy")
library("hgu133plus2.db")
library("affyQCReport")
library("affyPLM")
library("PECA")



# geladene CEL-Dateien werden eingelesen
Data_All <- ReadAffy()

# Funktion, die aus einem Datasatz ein Text-File erstellt
# dataset: Datensatz (engelesene CEL-Files)
# norm: Normalisierungsvariante (z.B. rma oder mas5)
# headerBoolean: TRUE oder FALSE => Soll Text-File header haben oder nicht
# info: Welche zusaetzliche Information mit geschrieben werden soll (z.b. GENENAME oder SYMBOL)
print_to_file <- function(dataset, norm, headerBoolean, info) {

filename <- "../tables/outtable.txt"

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

  # SLR und T-Test für alle Gene berechnen
  pecan <- PECA_AffyBatch(normalize="true", affy=Data_Ohne_Aussreisser)

  # leere Vektoren für Tabelle erzeugen
	minout1 <- vector(,nrow(exprs_vector))
	maxout1 <- vector(,nrow(exprs_vector))
	mediout1 <- vector(,nrow(exprs_vector))
	sdout1 <- vector(,nrow(exprs_vector))
	varout1 <- vector(,nrow(exprs_vector))
	minout2 <- vector(,nrow(exprs_vector))
	maxout2 <- vector(,nrow(exprs_vector))
	mediout2 <- vector(,nrow(exprs_vector))
	sdout2 <- vector(,nrow(exprs_vector))
	varout2 <- vector(,nrow(exprs_vector))
	slr  <- vector(,nrow(exprs_vector))
	ttest  <- vector(,nrow(exprs_vector))

  # Tabellen werden gefüllt	
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
	slr[i] <- pecan[i,1]
	ttest[i] <- pecan[i,2]
  }
 output_ext <- cbind(output, minout1, minout2, maxout1, maxout2, mediout1, mediout2, sdout1, sdout2, varout1, varout2, slr, ttest)
  varNames <- c("Min_Gesund","Min_TNF","Max_Gesund", "Max_TNF", "Median_Gesund", "Median_TNF", "SD_Gesund", "SD_TNF", "Var_Gesund","Var_TNF", "SLR", "T-Test")
  # header erstellen
  if(isTRUE(headerBoolean)) {
    header <- append(c("AffyID",info,sampleNames(eset)),varNames)
    # header in Datei schreiben
    write.table(t(header), file = filename, row.names = FALSE, col.names = FALSE, append = FALSE, sep = "\t")
  }
  
  # output in Datei schreiben
  write.table(output_ext, file=filename, row.names=FALSE, col.names=FALSE, append = TRUE, sep = "\t") 
  print(paste("Erstellt:",filename,sep = " "))
  
}
print_to_file(Data_All, "rma", TRUE, "GENENAME")
