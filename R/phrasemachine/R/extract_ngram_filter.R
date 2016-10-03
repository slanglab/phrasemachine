extract_ngram_filter <- function(pos_tags,
                                 regex,
                                 maximum_ngram_length) {

    # decrement since we are going from 0 to maximum_ngram_length
    maximum_ngram_length <- maximum_ngram_length - 1

    regex <- paste("^",regex,"$",sep = "")

    # first coarsen POS tags
    pos_tags <- coarsen_POS_tags(pos_tags)

    # create a matrix to hold spans that has 10000 slots (to start). Growing
    # lists or matrices in R is very slow, so it is a good idea to keep it this
    # size
    spans <- matrix(0, nrow = 10000, ncol= 2)
    max_spans <- 10000
    span_counter <- 1

    # loop over tags
    for (i in 1:length(pos_tags)) {
        # get the end of the span we are checking
        max_span <- min(maximum_ngram_length, (length(pos_tags) - i))
        for (j in 0:max_span) {
            # for the current pos span to look at
            subspan <- paste0(pos_tags[i:(i+j)],collapse = "")
            # if we find it then add the span to the list
            if (grepl(regex,subspan)) {
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

    # now subset down the spans
    spans <- spans[1:(span_counter-1),]
    # return the spans
    return(spans)
}
