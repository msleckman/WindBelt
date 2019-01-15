#----
# title: "NexisUni_pdf_scraping"
# author: "Margaux Sleckman"
# date: "October 18, 2018"
# output: html_document
#----
  
#----
    # Outline of lexisUni text analysis (checked if done):
    # 1. Dowload pdf from lexisUni - search terms: "Master Project Name" AND "Project Developer" AND "wind" AND "energy' (if necessary, the state was added in the search term if location was not precise enough. 
    # 2. Save pdf in sample_pdfs folder x
    # Each pdf saved as "fulltext"+ # search results if <10" + "abbreved project developer" "# of results pages in         >10", collapsed with "_" x
    # 2. Create a df with everypdf in each row. my_data x
    # 3. Add a column with all titles from pdf 
    # 3. Create df with unested text unested,such that each row is a pdf page.x
    # 4. Created new df that splits each page by word, sch that every row is a word in the text (unest_tokens where tokens are pdf) x
    # 5. Get word count of specific words through group_by()
    # Conduct sentiment analysis on unique words x 
    # 6. get hits and number of hits of different 'negative words' x

# Following meeting 10/22/18:
    # 1. Unest token by group of words or sentences and conduct sentiment analysis on this.x
    # 2. Clean scripts - ID words in pdf that consistently pop up and need to be filtered out.x
    # 3. separate headlines from text to ensure we don't have duplicates
    # 4. create csv format (NAME, Developer, State, Sentiment, subjectivity ...) x

# Other notes: 
# *tidytext::tokenize function - every element in list become df. rbind dfs 
# str_count() how many times does a search term come up 
# str_match()
# regex() 
# 

#-----
### Packages 

# install.packages("pdftools", "devtools")
library(pdftools)
library(tm)
# library(tm.plugin.lexisnexis)
library(devtools)
# install.packages("tidytext")
library(tidytext)
library(broom)
# install.packages("tidyverse")
library(data.table)
library(tidyverse)
library(purrr)
# install.packages("googledrive")
library(googledrive)
library(tibble)
# remove.packages("rlang")
library(stringr)
library(gsubfn)

#-----
## Gdrive directory

drive_auth()

    # the google drive folder id is simply the id in the folder url after the last dash
    # so the id here is derived from https://drive.google.com/drive/folders/1kZuJF3eS7SIiC8VBeGc6vVNvpBZHLnxg?ogsrc=32

## Example: want to access to top level NexisUni folder in gdrive (WindBelt GP/NexisUni):
    # GPteam_drive_id <- "1kZuJF3eS7SIiC8VBeGc6vVNvpBZHLnxg?ogsrc=32"
    # #create a dribble of Nexis Uni articles
    # NexisUni_folder_gdrive <- googledrive::drive_ls(googledrive::as_id(GPteam_drive_id))

## Access to  Bren GP 2019 WindBelt/NU_PDFs_R folder in gdrive

NU_PDFs_R_id  <- "1alXSN-uUouUNM2cTHq5OS3LSxVhSDa_v"
NU_PDFs_R_folder <- googledrive::drive_ls(googledrive::as_id(NU_PDFs_R_id))
View(NU_PDFs_R_folder)

# Create folder in desktop for pdfs. Decided to set on desktop to be compatible with all computers.
NU_PDFS_R <- "H:/Desktop/NU_PDFS_R"
dir.create(NU_PDFS_R, showWarnings = TRUE)

# function to download all lexisUni pdfs
pdf_downloader <- function(templates_dribble, local_folder){
  # download all pdfs
  
  for (i in 1:nrow(templates_dribble)){
    drive_download(as_id(templates_dribble$id[[i]]), 
                   file.path(local_folder, templates_dribble$name[[i]]),
                   overwrite = TRUE) #check if overwrite is neede here
  }
}

pdf_downloader(NU_PDFs_R_folder, NU_PDFS_R)

#------

## Full number of pdfs - file set up

directory <- "H:/Desktop/NU_PDFS_R"

#change path if not on windbelt comp.
pdfs <- paste(directory, "/", list.files(directory, pattern = "*.pdf", ignore.case = T), sep = "")
# View(pdfs)
pdfs_names <- list.files(directory, pattern = "*.pdf", ignore.case = T)
# View(pdfs_names)
pdfs_text <- purrr::map(pdfs, pdftools::pdf_text)
# head(pdfs_text,2)

#-------------

## Dataframe 1 with just pdfs and full text of the pdf ##
    #each row is a pdf doc name (document) with the full pdf text

projects_pdftext <- tibble::data_frame(document = pdfs_names, text = pdfs_text)
head(projects_pdftext)
View(head(projects_pdftext)) # large. slow to open

## Creating new column with title of articles

# function: 
  # titles_extract <- function(text, )
  # strapply(text, "\r\n 1.(.*?)Client/Matter:")  

# Extracts most titles - to clean
head_projects_pdftext_extract <- head(projects_pdftext) %>% 
  tidyr::unnest()

head_projects_pdftext_extract[1,2] <- head_projects_pdftext_extract %>% 
  stringr::str_replace_all(string = text, pattern = "Date", replacement = "_")

%>% 
  tidyr::nest() %>% 
mutate(title_extract = strapply(text, "\r\n \\d.(.*?)Client/Matter:"))

test_remove_words <- str_remove_all(project_pdfpages$text[1], string = "lexis")

View(test_remove_words)

## Dataframe 2 spliting text by page ##

# dataset with each page in one row
project_pdfpages <- projects_pdftext %>% 
  tidyr::unnest() %>%
  
  mutate(title_extract = strapply(text, "\r\n \\d.(.*?)Client/Matter:")) # this function also extracts most titles. helps verify whether extracted article titles are feasible. 


# splits pdf text by page and removes list format ( c("")) since each element of the list is now its own row.

# View(project_pdfpages) # large

## Dataframe 3 spliting page text by word (unnest_tokens()) ##

# Dataset with each work in or row associated with its pdf source 

projects_pdfwords <- projects_pdftext %>% 
tidyr::unnest() %>% 
tidytext::unnest_tokens(output = word, input = text, token = 
"words", to_lower = T, strip_numeric = FALSE)%>%      
filter(!word %in% c("lexis",
"nexis", "Uni",
"about lexisnexis",
"Privacy Policy",
"Terms & Conditions", "Copyright © 2018 LexisNexis",
" | ",  "@", "lexisnexis")) 

# %>% gsub("[^A-Za-z0-9,;._-]","")

View(projects_pdfwords)

# playing with ngrams
projects_pdfnest <- projects_pdftext %>% 
unnest() %>% 
tidytext::unnest_tokens(output = ngrams, input = text, token = "ngrams", n = 5, to_lower = F)

# View(my_data4)
# note: unnest_tokens() splits text by respective element (ie word, phrase, ...) word is default

## Dataframe wordsgrouped by pdf and summarised by frequency of word or ngrams ##

projects_pdfwords_count <- projects_pdfwords %>%
group_by(document, word) %>% 
summarise(count = n())

# View(projects_pdfwords_count)

# counts the number of time a specific words is found in the page pdf.
# View(my_data2_sum)

projects_pdfnest_count <- projects_pdfnest %>%
group_by(document, ngrams) %>% 
summarise(count = n())

# View(projects_pdfnest_count)

#### Sentiment dictionaries ##

# using 'afinn' vs. 'nrc sentiment tests

View(get_sentiments("afinn")) 

  #afinn scores/ranks from -5 to +5 for positive or negative sentiment. 

# get_sentiments("nrc") 
  # nrc associates word with another sentiment feeling word
    
    #--> Sticking to numeric sentiment scores 

## Bind Sentiments ##

projects_score_bind <-projects_pdfwords_count %>% 
  left_join(get_sentiments("afinn"), by = "word")  

# projects_score_bind <-projects_pdfwords_count %>% 
#   inner_join(get_sentiments("afinn"), by = "word")  

# my_data4_bind <-my_data4 %>% 
#   left_join(get_sentiments("afinn"))  

View(projects_score_bind)
# Note: Many of the scores per words are NA simply because that word does not exist. 

## Final table ##
total_sentiment1 <- projects_score_bind %>% 
  filter(score !="NA") %>% 
  group_by(document) %>% 
  summarise(totals = weighted.mean(score, w = count),
            standard_dev = sd(score),
            variance = var(score))

total_sentiment <- projects_score_bind %>% 
  filter(score !="NA") %>% 
  group_by(document) %>% 
  summarise(totals = mean(score))

View(total_sentiment1)
View(total_sentiment)

# count_mydata3_bind <-my_data3_bind %>% 
#   count(word, score, sort = TRUE) 
# View(count_mydata3_bind)

#### Populate with negative words 

library(stringr)

negative_words <- paste0(c('negative|postpone|against|delay|lawsuit|litigation|protest|^cost|^stop'))

# Function to replace `character(0)` with NAs as NULL values are dropped when flattening list
# inspired by: https://colinfay.me/purrr-set-na/

charnull_set <- function(x){
  p <- purrr::as_mapper(~identical(., character(0)))
  x[p(x)] <- NA
  return(x)
}

# Create Column with word hits  
projects_pdftext_query <- projects_pdftext %>%
  mutate(query_hits = str_extract_all(text, pattern = regex(negative_words, ignore_case=TRUE)) %>%  # Extract all the keywords
           map(~charnull_set(.x)) %>%   # Replace character(0) with NAs
           map_chr(~glue::glue_collapse(.x, sep = ";")) %>%   # collapse the multiple hits
           tolower) # all our keywords are lower case

View(projects_pdftext_query)


##############


## test with MS_sample_pdfs folder

directory_sample <- "G:/TextAnalysis/NexisUni/Margaux_PDFs"

pdfs_sample <- paste(directory_sample, "/", list.files(directory_sample, pattern = "*.pdf", ignore.case = T), sep = "")
# View(pdfs)
pdfs_names_sample <- list.files(directory_sample, pattern = "*.pdf", ignore.case = T)
# View(pdfs_names)
pdfs_text_sample <- purrr::map(pdfs_sample, pdftools::pdf_text)

# head(pdfs_text,2)
View(pdfs_text_sample)

projects_pdftext_sample <- tibble::data_frame(document = pdfs_names_sample, text = pdfs_text_sample)
View(projects_pdftext)

require(dplyr)
project_pdfpages_sample <- projects_pdftext_sample %>% 
  unnest(pdfs_text_sample) 

projects_pdfwords_sample <- projects_pdftext_sample %>% 
  tidyr::unnest() %>% 
  tidytext::unnest_tokens(output = word, input = text, token = 
                            "words", to_lower = T
                          # strip_numeric = TRUE
  )%>%      
  filter(!word %in% c("lexis",
                      "nexis", "Uni",
                      "about lexisnexis",
                      "Privacy Policy",
                      "Terms & Conditions", "Copyright © 2018 LexisNexis",
                      " | ",  "@", "lexisnexis")) 

# splits pdf text by page and removes list format ( c("")) since each element of the list is now its own row.

########################
