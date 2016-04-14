#Histogramm als Datei schreiben
png("histogram_normalized.png")
hist(exprs(normalized))
