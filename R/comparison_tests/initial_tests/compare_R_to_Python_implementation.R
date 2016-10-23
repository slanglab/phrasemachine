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

phrases_R <- phrasemachine(text, return_tag_sequences = TRUE, maximum_ngram_length = 7)

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

# first, find the different tokens
R_tokens <- unique(tolower(POS_tagged_R[[1]]$tokens))
Py_tokens <- unique(tolower(tokens_Py$tokens))

for (i in 1:length(R_tokens)) {
    if (length(which(Py_tokens == R_tokens[i])) != 1) {
        print(R_tokens[i])
    }
}

for (i in 1:length(Py_tokens)) {
    if (length(which(R_tokens == Py_tokens[i])) != 1) {
        print(Py_tokens[i])
    }
}

# see if we remove these tokens if we get the same thing.
POS_tagged_R[[1]]$tokens <- tolower(POS_tagged_R[[1]]$tokens)
remove <- rep(0, length(POS_tagged_R[[1]]$tokens))
for (i in 1:length(POS_tagged_R[[1]]$tokens)) {
    if (length(which(Py_tokens == POS_tagged_R[[1]]$tokens[i])) == 0) {
        remove[i] <- 1
    }
}

POS_tagged_R[[1]]$tokens <- POS_tagged_R[[1]]$tokens[-which(remove == 1)]
POS_tagged_R[[1]]$tags <- POS_tagged_R[[1]]$tags[-which(remove == 1)]

# now from Python
POS_tagged_from_Python <- POS_tagged_R
POS_tagged_from_Python[[1]]$tokens <- tokens_Py$tokens
POS_tagged_from_Python[[1]]$tags <- pos_tags_Py$pos
remove <- rep(0, length(POS_tagged_R[[1]]$tokens))
for (i in 1:length(POS_tagged_from_Python[[1]]$tokens)) {
    if (length(which(R_tokens == POS_tagged_from_Python[[1]]$tokens[i])) == 0) {
        remove[i] <- 1
    }
}

POS_tagged_from_Python[[1]]$tokens <- POS_tagged_from_Python[[1]]$tokens[-which(remove == 1)]
POS_tagged_from_Python[[1]]$tags <- POS_tagged_from_Python[[1]]$tags[-which(remove == 1)]

# get phrases
phrases_1 <- extract_phrases(POS_tagged_R, maximum_ngram_length = 7)
phrases_2 <- extract_phrases(POS_tagged_from_Python, maximum_ngram_length = 7)

# get counts of unique for both
unique_phrases <- unique(tolower(phrases_1[[1]]))
unique_counts <- rep(0,length(unique_phrases))
for(i in 1:length(unique_phrases)) {
    unique_counts[i] <- length(which(tolower(phrases_1[[1]]) == unique_phrases[i]))
}

Phrases_1 <- data.frame(term = unique_phrases[order(unique_phrases)],
                        count = unique_counts[order(unique_phrases)],
                        stringsAsFactors = FALSE)

unique_phrases <- unique(tolower(phrases_2[[1]]))
unique_counts <- rep(0,length(unique_phrases))
for(i in 1:length(unique_phrases)) {
    unique_counts[i] <- length(which(tolower(phrases_2[[1]]) == unique_phrases[i]))
}

Phrase_2 <- data.frame(term = unique_phrases[order(unique_phrases)],
                        count = unique_counts[order(unique_phrases)],
                        stringsAsFactors = FALSE)


# now go through and find differences
for(i in 1:nrow(Phrases_1)) {
    in_py <- which(Phrase_2$term == Phrases_1$term[i])
    if (length(in_py) == 1) {
        if(Phrase_2$count[in_py] != Phrases_1$count[i]) {
            cat(Phrases_1$term[i], "has count:",Phrases_1$count[i],"in R, but",Phrase_2$count[in_py],"in Python...\n")
        }
    } else {
        cat(Phrases_1$term[i], "is not in Python output but occurs",Phrases_1$count[i],"times in R output...\n")
    }
}


# no terms in python that are not in R
for(i in 1:nrow(Phrase_2)) {
    in_py <- which(Phrases_1$term == Phrase_2$term[i])
    if (length(in_py) == 1) {
        if(Phrases_1$count[in_py] != Phrase_2$count[i]) {
            cat(Phrase_2$term[i],"has count:",Phrases_1$count[in_py],"in R, but",Phrase_2$count[i],"in Python...\n")
        }
    } else {
        cat(Phrase_2$term[i], "is not in R output but occurs",Phrase_2$count[i],"times in Python output...\n")
    }
}


# second, use Python POS taggings and tokens as imput for R phrase extractor
POS_tagged_from_Python <- POS_tagged_R

POS_tagged_from_Python[[1]]$tokens <- tokens_Py$tokens
POS_tagged_from_Python[[1]]$tags <- pos_tags_Py$pos

# now get phrases
phrases_from_Python <- extract_phrases(POS_tagged_from_Python, maximum_ngram_length = 7)
sum(unlist(phrases_Py$counts))
length(phrases_from_Python[[1]])

# form counts matrices for both
Python_Phrases <- data.frame(term = names(phrases_Py$counts)[order(names(phrases_Py$counts))],
                        count = unlist(phrases_Py$counts)[order(names(phrases_Py$counts))],
                        stringsAsFactors = FALSE)

# underscore separation for comparability
Python_Phrases$term <- sapply(Python_Phrases$term,stringr::str_replace_all,"[\\s]+","_")

# get phrase counts for R
unique_phrases <- unique(tolower(phrases_from_Python[[1]]))
unique_counts <- rep(0,length(unique_phrases))
for(i in 1:length(unique_phrases)) {
    unique_counts[i] <- length(which(tolower(phrases_from_Python[[1]]) == unique_phrases[i]))
}

R_Phrases <- data.frame(term = unique_phrases[order(unique_phrases)],
                             count = unique_counts[order(unique_phrases)],
                             stringsAsFactors = FALSE)


# now go through and find differences
for(i in 1:nrow(R_Phrases)) {
    in_py <- which(Python_Phrases$term == R_Phrases$term[i])
    if (length(in_py) == 1) {
        if(Python_Phrases$count[in_py] != R_Phrases$count[i]) {
            cat("Term:", R_Phrases$term[i], "has count:",R_Phrases$count[i],"in R, but",Python_Phrases$count[in_py],"in Python...\n")
        }
    } else {
        cat("Term:", R_Phrases$term[i], "is not in Python output but occurs",R_Phrases$count[i],"times in R output...\n")
    }
}


# no terms in python that are not in R
for(i in 1:nrow(Python_Phrases)) {
    in_py <- which(R_Phrases$term == Python_Phrases$term[i])
    if (length(in_py) == 1) {
        if(R_Phrases$count[in_py] != Python_Phrases$count[i]) {
            cat("Term:", Python_Phrases$term[i], "has count:",R_Phrases$count[in_py],"in R, but",Python_Phrases$count[i],"in Python...\n")
        }
    } else {
        cat("Term:", Python_Phrases$term[i], "is not in R output but occurs",Python_Phrases$count[i],"times in Python output...\n")
    }
}

# see how many 8-length terms are in python output
for(i in 1:nrow(Python_Phrases)) {
    str <- stringr::str_split(Python_Phrases$term[i],"_")
    if(length(str[[1]]) == 8) {
        print(Python_Phrases$term[i])
    }
}


