# test R and python versions against eachother

# set working directory
setwd("~/Documents/Research/Congressional_Bill_Language/EMNLP_2016/phrasemachine/R/comparison_tests")

# load package
library(phrasemachine)

# read in text
text <- readLines("~/Documents/Research/Congressional_Bill_Language/EMNLP_2016/phrasemachine/testdata/sotu/1985.txt")

# collapse into single string
text <- paste0(text, collapse = " ")

POS_tagged_R <- POS_tag_documents(text)

phrases_R <- phrasemachine(text, return_tag_sequences = TRUE)

# load in python results
library("rjson")
json_file <- "python_phrase_extractions.json"
phrases_Py <- fromJSON(paste(readLines(json_file), collapse=""))

json_file <- "python_pos_tags.json"
pos_tags_Py <- fromJSON(paste(readLines(json_file), collapse=""))

json_file <- "python_tokens.json"
tokens_Py <- fromJSON(paste(readLines(json_file), collapse=""))

# see how many phrases get extracted by each method
sum(unlist(phrases_Py$counts))
length(phrases_R[[1]]$phrases)
# so there are some differences, lets see why


# first, use Python POS taggings and tokens as imput for R phrase extractor
POS_tagged_from_Python <- POS_tagged_R

POS_tagged_from_Python[[1]]$tokens <- tokens_Py$tokens
POS_tagged_from_Python[[1]]$tags <- pos_tags_Py$pos

# now get phrases
phrases_from_Python <- extract_phrases(POS_tagged_from_Python)
sum(unlist(phrases_Py$counts))
length(phrases_from_Python[[1]])
