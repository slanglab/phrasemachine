#' @title Extract phrase spans
#' @description Takes a sequences of POS tags and a regex and returns spans
#' which match regex.
#'
#' @param pos_tags A character vector of Penn TreeBank or Petrov/Gimpel
#' style tags.
#' @param regex The regular expression (or vector of regular expressions) used
#' to find phrases.
#' @param maximum_ngram_length The maximum length phrases returned.
#' @param minimum_ngram_length The minimum length phrases returned.
#' @return A numeric matrix with two columns and rows equal to number of spans
#' matched. First column is span start, second is span end.
#' @examples
#' pos_tags <- c("VB", "JJ", "NN", "NN")
#' spans <- extract_ngram_filter(pos_tags,
#'                               regex = "(A|N)*N(PD*(A|N)*N)*",
#'                               maximum_ngram_length = 8,
#'                               minimum_ngram_length = 1)
#' @export
extract_ngram_filter <- function(pos_tags,
                                 regex,
                                 maximum_ngram_length,
                                 minimum_ngram_length) {

    # decrement since we are going from minimum_ngram_length to
    # maximum_ngram_length
    maximum_ngram_length <- maximum_ngram_length - 1
    minimum_ngram_length <- minimum_ngram_length - 1

    # replace named regular expressions with their full expansion. Works for:
    # SimpleNP, PhrasesNoCoord (NP + VP), Phrases (NP + VP with coordination)
    regex <- check_for_named_regexes(regex)

    for (r in 1:length(regex)) {
        regex[r] <- paste("^",regex[r],"$",sep = "")
    }

    # first coarsen POS tags
    pos_tags <- coarsen_POS_tags(pos_tags)

    # create a matrix to hold spans that has 10000 slots (to start). Growing
    # lists or matrices in R is very slow, so it is a good idea to keep it this
    # size
    spans <- matrix(0, nrow = 10000, ncol= 2)
    max_spans <- 10000
    span_counter <- 1

    # loop over vector of regular expressions
    for(r in 1:length(regex)) {
        # loop over tags
        for (i in 1:length(pos_tags)) {
            # get the end of the span we are checking
            max_span <- min(maximum_ngram_length, (length(pos_tags) - i))
            if (max_span >= minimum_ngram_length) {
                for (j in minimum_ngram_length:max_span) {
                    # for the current pos span to look at
                    subspan <- paste0(pos_tags[i:(i+j)],collapse = "")
                    # if we find it then add the span to the list
                    if (grepl(regex[r],subspan)) {
                        # store the span
                        spans[span_counter,] <- c(i,i+j)
                        # increment the span counter
                        span_counter <- span_counter + 1

                        # grow the span matrix if necessary
                        if (span_counter > max_spans) {
                            spans <- rbind(spans,matrix(0, nrow = 10000, ncol= 2))
                            max_spans <- max_spans + 10000
                        }
                    }
                }
            }
        }
    }


    # deal with case where we find no matches
    if (sum(spans) == 0) {
        return(NULL)
    } else {
        # now subset down the spans
        if (span_counter==2){
            spans <- t(as.matrix(spans[1:(span_counter-1),]))
        } else {
            spans <- spans[1:(span_counter-1),]
        }
        # return the spans
        return(spans)
    }

}
