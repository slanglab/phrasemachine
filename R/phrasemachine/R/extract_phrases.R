#' @title Extract Phrases
#' @description Extracts phrases from a list of POS tagged document using the
#' "FilterFSA" method in Handler et al. 2016.
#'
#' @param POS_tagged_documents A list object of the form produced by the
#' `POS_tag_documents()` function, with either Penn TreeBank or Petrov/Gimpel
#' style tags.
#' @param regex The regualr expression used to find phrases. Defaults to
#' "(A|N)*N(PD*(A|N)*N)*", as in Handler et al. 2016.
#' @param maximum_ngram_length The maximum length phrases returned. Defaults to
#' 8. Increasing this number can greatly increase runtime.
#' @param return_phrase_vectors Logical indicating whether a list of phrase
#' vectors (with each entry contain a vector of phrases in one document) should
#' be returned, or whether phrases should combined into a single space separated
#' string.
#' @return A list object.
#' @export
extract_phrases <- function(POS_tagged_documents,
                            regex = "(A|N)*N(PD*(A|N)*N)*",
                            maximum_ngram_length = 8,
                            return_phrase_vectors = TRUE) {
    # determine the return type
    if (return_phrase_vectors) {
        to_return <- vector(mode = "list", length = length(POS_tagged_documents))
    } else {
        to_return <- rep("",length(POS_tagged_documents))
    }

    for (i in 1:length(POS_tagged_documents)) {
        cat("Extracting phrases from document",i,"of",length(POS_tagged_documents),"\n")
        # get the spans
        spans <- extract_ngram_filter(pos_tags = POS_tagged_documents[[i]]$tags,
                                      regex = regex,
                                      maximum_ngram_length = maximum_ngram_length)
        # allocate phrases vector
        phrases <- rep("",nrow(spans))

        for (j in 1:length(phrases)) {
            #populate phrases vector
            phrases[j] <- paste0(
                POS_tagged_documents[[i]]$tokens[spans[j,1]:spans[j,2]],
                collapse = "_")
        }

        if (return_phrase_vectors) {
            to_return[[i]] <- phrases
        } else {
            to_return[i] <- paste0(phrases,collapse = " ")
        }
    }

    return(to_return)
}
