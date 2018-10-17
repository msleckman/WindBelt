
#########################################
# Windbelt script brainstorm lexisUni
#
#
#########################################

#----Notes------------------------------------

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
# pdf into df  

#---------------------------------------------

### Read in 
Windbelt_Project_Database_1_ <- read_csv("G:/Data/wind project dataset/Windbelt Project Database (1).csv")
wind_df <- Windbelt_Project_Database_1_

### Packages 
install.packages("pdftools", "devtools")
library(pdftools)
library(tm)
# library(tm.plugin.lexisnexis)
library(devtools)
# install.packages("tidytext")
library(tidytext)
library(broom)
install.packages("tidyverse")
library(data.table)
library(tidyverse)
### tidytext()

directory <- "G:/TextAnalysis/lexisUni/sample_pdfs"
pdfs_2 <- paste(directory, "/", list.files(directory, pattern = "*.pdf", ignore.case = T), sep = "")
pdfs_names <- list.files(directory, pattern = "*.pdf", ignore.case = T)
pdfs_names
pdfs_text <- map(pdfs_2, pdftools::pdf_text)
pdfs_text
my_data <- data_frame(document = pdfs_names, text = pdfs_text)

# dataset with each page in one row
my_data1 <- my_data %>% 
  unnest()
View(my_data1)

#Dataset with each work in or row associated with its pdf source 
my_data2 <- my_data %>% 
  unnest() %>% 
  unnest_tokens(word, text, strip_numeric = TRUE)
View(my_data2)
# Word per row with grouping by document and summary of word count 

my_data3 <- my_data %>%
  unnest() %>% 
  unnest_tokens(word, text, strip_numeric = TRUE) %>%  # removing all numbers
  group_by(document, word) %>% 
  summarise(count = n())

View(my_data3)

# --- other stuff explored

#devtools::install_github("quanteda/quanteda")  ## fyi: massive package
library(quanteda)

### Download file is not stored already (did not work but had file downloaded already)
download.file("file://esm.ucsb.edu/mesm/co2019/msleckman/Downloads/fulltext_GreatWesterGn_EDFReEnergy.PDF", 
              "Fall 2018/lexisuni/fulltext_GreatWestern_EDFReEnergy.PDF")

# Read-in text assuming pdf is downloaded and saved on computer (change path)
file <- "G:/TextAnalysis/lexisUni/fulltext_GreatWestern_EDFReEnergy.PDF"
text <- pdftools::pdf_text(file)
info <- pdftools::pdf_info(file)
tail(text)


# 
text2 <- strsplit(text, "\n")

text2[1:2]


tidy_text <- text2 %>%
  unlist() %>% 
  unnest_tokens(word, text)


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

text2[6:7]




dir.create("~/Desktop/sample-pdfs")

# Fill directory with 2 pdf files from my github repo

download.file("https://github.com/thomasdebeus/colourful-facts/raw/master/projects/sample-data/'s-Gravenhage_coalitieakkoord.pdf", destfile = "~/Desktop/sample-pdfs/'s-Gravenhage_coalitieakkoord.pdf")
download.file("https://github.com/thomasdebeus/colourful-facts/raw/master/projects/sample-data/Aa%20en%20Hunze_coalitieakkoord.pdf", destfile = "~/Desktop/sample-pdfs/Aa en Hunze_coalitieakkoord.pdf")

# Create vector of file paths

dir <- "~/Desktop/sample-pdfs"
pdfs <- paste(dir, "/", list.files(dir, pattern = "*.pdf"), sep = "")

# Read the text from pdf's with pdftools package

pdfs_text <- map(pdfs, pdftools::pdf_text)

# Convert to document-term-matrix

converted <- Corpus(VectorSource(pdfs_text)) %>%
  DocumentTermMatrix()

# Now I want to convert this to a tidy format

converted %>%
  tidy() %>%
  filter(!grepl("[0-9]+", term))



















