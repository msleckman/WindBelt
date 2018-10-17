

install.packages("pdftools", "tm.plugin.lexisnexis", "devtools")
library(pdftools)
library(tm)
library(tm.plugin.lexisnexis)
library(devtools)

#devtools::install_github("quanteda/quanteda")  ## fyi: massive package
library(quanteda)

### Download file is not stored already (did not work but had file downloaded already)
download.file("file://esm.ucsb.edu/mesm/co2019/msleckman/Downloads/fulltext_GreatWesterGn_EDFReEnergy.PDF", 
              "Fall 2018/lexisuni/fulltext_GreatWestern_EDFReEnergy.PDF")

# Read-in text assuming pdf is downloaded and saved on computer (change path)
text <- pdftools::pdf_text("C:/Users/Jocelyne/OneDrive/Bren/courses/Spring 2018/GP/fulltext_GreatWestern_EDFReEnergy.PDF")
  # 

text2 <- strsplit(text, "\n")
text2[1:2]

test_dir <- system.file("G:/TextAnalysis/lexisUni/", package = "tm")

#Corpus --> the collection of papers. essentially you merged a bunch of pdfs together to form a Corpus
pdfs <- VCorpus(DirSource(test_dir, encoding = "UTF-8"), 
                readerControl = list(language = NA))
    ## not working atm

# other tests 
read <- readPDF(control = list(text = "-layout"))
read

document <- Corpus(URISource("G:/TextAnalysis/lexisUni/fulltext_GreatWestern_EDFReEnergy.PDF"), readerControl = list(reader = read))
document
 doc <- content(document[[1]])
head(doc)

readLexisNexisHTML(elem, language, id)

LexisNexisSource(text)

## tidytext()
# ceate a dataframe for every pdf 
# take a pdf list - 
# lapply - 
# tidytext::tokenize function - every element in list become df. rbind dfs 
# 
# str_count() how many times does a search term come up 
# str_match()
# regex() 
# Download as docx and then use xml package  
# Convert to dataframe 
# 
# 1rst step of getting into a dataframe
# tm package uses corpus - tidytext
# Analyzing 
# pdf into df -  
#
# Do this weekend 
#
text2[6:7]
