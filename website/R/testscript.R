library("optparse")
 
option_list = list(
  make_option("--wd", action="store", help="Name of table to use as WD"),
  make_option("--all", action="store_true", default=FALSE, help="Alles plotten"),
  make_option("--hist", action="store_true", default=FALSE, help="Histogramme plotten"),
  make_option("--heat", action="store_true", default=FALSE, help="Heatmaps plotten")
)

 
opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);


#Namen fuer Workingdirectory einlesen
tablename <- opt$wd

# Lade affy package, hgu133plus2.db (Genzuordnung) und affyQCReport (QC-PDF) im Programm:
library("affy")
library("hgu133plus2.db")
library("affyQCReport")
library("affyPLM")




setwdd <- paste0("/home/admini/Uni/Softwareprojekt/GenEx/website/Output/", tablename, "/wd")
filename <- paste0("../tables/", tablename, "_table.txt")
print(setwdd)
#WD setzen
setwd(setwdd)
print(getwd())
Data_All <- ReadAffy()

#Histogramm als Datei schreiben
png("../plots/histogram_unnormalized.png")
hist(exprs(Data_All))


# Funktion, die aus einem Datasatz ein Text-File erstellt
# dataset: Datensatz (engelesene CEL-Files)
# norm: Normalisierungsvariante (z.B. rma oder mas5)
# headerBoolean: TRUE oder FALSE => Soll Text-File header haben oder nicht
# info: Welche zusaetzliche Information mit geschrieben werden soll (z.b. GENENAME oder SYMBOL)
print_to_file <- function(filename, dataset, norm, headerBoolean, info) {

  #filename <- "../tables/outtable.txt"
  
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
    header <- append(c("AffyID",info),sampleNames(eset))
    # header in Datei schreiben
    write.table(t(header), file = filename, row.names = FALSE, col.names = FALSE, append = FALSE, sep = "\t")
  }
  
  # output in Datei schreiben
  write.table(output, file=filename, row.names=FALSE, col.names=FALSE, append = TRUE, sep = "\t") 
  print(paste("Erstellt:",filename,sep = " "))
  
}

print_to_file(filename, Data_All, "rma", TRUE, "SYMBOL")