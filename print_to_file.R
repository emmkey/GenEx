#package "hgu133plus2.db" muss installiert werden
#hgu133plus2.db laden
library(hgu133plus2.db)
#affy laden
library(affy)
#Alle CEL-Files aus Working-Directory einlesen
mydata <- ReadAffy()

#Funktion zum Erstellen eines Timestamps
create_timestamp <- function() {
	#timestamp erstellen fuer den Dateinamen
	now <- Sys.time()
	#Doppelpunkte ersetzen
	now <- gsub(":","-",now)
	#Luecke entfernen
	now <- gsub(" ","-",now)
	return(now)
}

#Funktion, die aus einem Datasatz Text-File erstellt
#dataset: Datensatz (engelesene CEL-Files)
#norm: Normalisierungsvariante (z.B. rma oder mas5)
#headerBoolean: TRUE oder FALSE => Soll Text-File header haben oder nicht
#info: welche zusaetzliche Information mit geschrieben werden soll (z.b. GENENAME o. SYMBOL)
print_to_file <- function(dataset, norm, headerBoolean, info) {
	
	timestamp <- create_timestamp()
	#Normalisierungsmethode und Info mit an Dateinamen haengen
	filename <- paste(timestamp, norm, sep = "_")
	filename <- paste(filename, info, sep = "_")
	#Dateiende anhaengen
	filename <- paste(filename, ".txt", sep = "") 

	#ExpressionSet erstellen
	if (norm == "rma") {
		eset <- rma(dataset)
	}
	else if (norm == "mas5") {
		eset <- mas5(dataset, sc = 150)
	}
	#Vektor erstellen, der alle 7 RMA/MAS5-Werte enthaelt
	exprs_vector <- exprs(eset)
	
	#Alle AffyIDs aus ExpressionSet auslesen
	affyids <- featureNames(eset)
	
	#Geninfo auslesen
	geninfo <- select(hgu133plus2.db, affyids, info)
		
	#falls nicht zu allen affyids die "info" gefunden wurde
	#alle affyids durchgehen und gucken, ob ein Genname gefunden wurde
       	if(length(affyids) != nrow(geninfo)) {

		print("korrigiere Info-Vektor...")
		#Vektor mit Infos ueberarbeiten, damit auch affyids enthalten sind,
        	#fuer die keine Info gefunden wurde
        	#leeren Vektor erstellen
        	modded_info <- vector(,nrow(exprs_vector))
		
		for(i in 1:length(affyids)) {
        		#Position von affyid in "geninfo" rausschreiben
        		position <- match(affyids[i],geninfo[,1])
        		#Wenn position != NA, dann ist die affyid in "geninfo"
        		#und die Geninfo kann uebernommen werden
        		#Wenn fuer die affyid keine Info gefunden wurde,
        		#wird ein "NotFound" eingefuegt

        		if(!is.na(position)) {
                		modded_info[i] <- geninfo[position,2]
        		} else {
                		modded_info[i] <- "NotFound"
       			} 
		}
	}
	#Wenn Laenge nicht unterschiedlich, dann einfach alle uebernehmen
	else {
		modded_info <- geninfo[,2]
	}

	#Geninfo in Matrix einschieben
        output <- cbind(affyids,modded_info,exprs_vector)

        #header erstellen
        if(isTRUE(headerBoolean)) {
        	header <- append(c("AffyID",info),sampleNames(eset),2)
                #header in Datei schreiben
                write.table(t(header), file = filename, row.names = FALSE, col.names = FALSE, append = FALSE, sep = "\t")
        }
                
        #output in Datei schreiben
        write.table(output, file=filename, row.names=FALSE, col.names=FALSE, append = TRUE, sep = "\t") 
	print(paste("Created:",filename,sep = " "))

}

#Testaufruf mit rma, header und GENENAME
print_to_file(mydata, "rma", TRUE, "GENENAME")
print_to_file(mydata, "mas5", TRUE, "SYMBOL")





