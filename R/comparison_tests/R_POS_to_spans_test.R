# take POS tag sequences as input and output (one sequence per line), and output
# spans, on corresponding lines to a .txt file

# uncomment this to run automatically on any machine
# install.packages("devtools")
# install.packages("stringr")
# devtools::install_git("slanglab/phrasemachine", subdir = "R/phrasemachine")

# for testing on Matt's computer
# setwd("~/Documents/Research/Congressional_Bill_Language/EMNLP_2016/phrasemachine/R/comparison_tests")

# load library
library(phrasemachine)

# read in POS tag sequences
POS_tag_sequences <- readLines("POS_tag_sequences.txt")

# vecto to save spans in
phrase_spans <- rep("",length(POS_tag_sequences))

# loop over lines of tag list
for (i in 1:length(phrase_spans)) {
    print(i)
    # split on spaces
    temp <- stringr::str_split(POS_tag_sequences[i],"[\\s]+")[[1]]
    # remove any blank entries
    remove <- which(temp == "")
    if(length(remove) >0) {
        temp <- temp[-remove]
    }
    spans <- extract_ngram_filter(temp,
                                  regex = "(A|N)*N(PD*(A|N)*N)*",
                                  maximum_ngram_length = 8,
                                  exclude_unigrams = TRUE)
    # turn into a string of spans fo the form {start,end}{start,end}
    if (!is.null(spans)) {
        # deal with the case where we only return one span
        if (class(spans) == "numeric") {
            line <- paste("{",spans[1],",",spans[2],"}",sep = "")
        } else {
            # for the case with more than one span
            line <- NULL
            for (j in 1:nrow(spans)) {
                line <- paste(line,"{",spans[j,1],",",spans[j,2],"}",sep = "")
            }
        }
        phrase_spans[i] <- line
    } else {
        phrase_spans[i] <- ""
    }
}

# write output to .txt file
write.table(x = phrase_spans,
            file = "R_POS_span_results.txt",
            row.names = FALSE,
            col.names = FALSE,
            quote = FALSE)


