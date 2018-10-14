

# install.packages("pdftools", "tm", "tm.plugin.lexisnexis", "devtools")
library(pdftools)
library(tm)
library(tm.plugin.lexisnexis)
library(devtools)

#devtools::install_github("quanteda/quanteda")  ## fyi: massive package
library(quanteda)

### Download file is not stored already (did not work but had file downloaded already)
download.file("file://esm.ucsb.edu/mesm/co2019/msleckman/Downloads/fulltext_GreatWesterGn_EDFReEnergy.PDF", 
              "Fall 2018/lexisuni/fulltext_GreatWestern_EDFReEnergy.PDF")

# REad in text assuming pdf is downloaded and saved on computer (change path)
text <- pdf_text("G:/TextAnalysis/lexisUni/fulltext_GreatWestern_EDFReEnergy.PDF")

readPDF("G:/TextAnalysis/lexisUni/fulltext_GreatWestern_EDFReEnergy.PDF")

text2 <- strsplit(text, "\n")

inspect(text[1:2])

test_dir <- system.file("G:/TextAnalysis/lexisUni/", package = "tm")

#Corpus --> the collection of papers. essentially you merged a bunch of pdfs together to form a Corpus
pdfs <- VCorpus(DirSource(test_dir, encoding = "UTF-8"), 
                readerControl = list(language = NA))
    ## not working atm

#test_dir
head(text2)


# other tests 
read <- readPDF(control = list(text = "-layout"))
read

document <- Corpus(URISource("G:/TextAnalysis/lexisUni/fulltext_GreatWestern_EDFReEnergy.PDF"), readerControl = list(reader = read))
document
doc <- content(document[[1]])
head(doc)

readLexisNexisHTML(elem, language, id)

LexisNexisSource(text)

