#Histogramm als Datei schreiben
png("histogram_unnormalized.png")
hist(exprs(data))
