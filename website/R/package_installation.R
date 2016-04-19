# Installation:
source("https://bioconductor.org/biocLite.R")

checklib1 <- require(affy,)
checklib2 <- require(hgu133plus2.db)
checklib3 <- require(affyQCReport)
checklib4 <- require(affyPLM)

if (checklib1 != TRUE) {
	biocLite("affy")
}
if (checklib2 != TRUE) {
	biocLite("hgu133plus2.db")
}
if (checklib1 != TRUE) {
	biocLite("affyQCReport")
}
if (checklib1 != TRUE) {
	biocLite("affyPLM")
}

