#' @title Extract Phrases
#' @description Extracts phrases from a list of POS tagged document using the
#' "FilterFSA" method in Handler et al. 2016.
#'
#' @param POS_tagged_documents A list object of the form produced by the
#' `POS_tag_documents()` function, with either Penn TreeBank or Petrov/Gimpel
#' style tags.
#' @param regex The regular expression used to find phrases. Defaults to
#' "(A|N)*N(PD*(A|N)*N)*", the "SimpleNP" grammar in Handler et al. 2016. Can
#' also be "PhrasesNoCoord", which will be substituted for more complex noun
#' and verb-argument phrases (without coordination), or "Phrases", which will
#' be substituted for a very complex regular expression capturing noun and
#' verb-argument phrases with coordination. A vector of regular expressions may
#' also be provided if the user wishes to match more than one.
#' @param maximum_ngram_length The maximum length phrases returned. Defaults to
#' 8. Increasing this number can greatly increase runtime.
#' @param minimum_ngram_length The minimum length phrases returned. Defaults to
#' 2. Can be increased to remove shorter phrases, or decreased to include
#' unigrams.
#' @param return_phrase_vectors Logical indicating whether a list of phrase
#' vectors (with each entry contain a vector of phrases in one document) should
#' be returned, or whether phrases should combined into a single space separated
#' string.
#' @param return_tag_sequences Logical indicating whether tag sequences should
#' be returned along with phrases. Defaults to FALSE.
#' @return A list object.
#' @examples
#' \dontrun{
#' # load data
#' corp <- quanteda::corpus(quanteda::inaugTexts)
#' documents <- quanteda::texts(corp)[1:5]
#'
#' # run tagger
#' tagged_documents <- POS_tag_documents(documents)
#'
#' phrases <- extract_phrases(tagged_documents,
#'                            regex = "(A|N)*N(PD*(A|N)*N)*",
#'                            maximum_ngram_length = 8,
#'                            minimum_ngram_length = 1)
#' }
#' @export
extract_phrases <- function(POS_tagged_documents,
                            regex = "(A|N)*N(PD*(A|N)*N)*",
                            maximum_ngram_length = 8,
                            minimum_ngram_length = 2,
                            return_phrase_vectors = TRUE,
                            return_tag_sequences = FALSE) {

    # make sure that the lengths make sense
    if (minimum_ngram_length > maximum_ngram_length) {
        minimum_ngram_length <- maximum_ngram_length
        warning("minimum_ngram_length was smaller than maximum_ngram_length, the two have been set equal.")
    }
    # make sure they have psitive length
    if (minimum_ngram_length < 1) {
        minimum_ngram_length <- 1
        warning("minimum_ngram_length < 1. Resetting to 1.")
    }
    if (maximum_ngram_length < 1) {
        maximum_ngram_length <- 1
        warning("maximum_ngram_length < 1. Resetting to 1.")
    }

    # determine the return type
    if (return_phrase_vectors) {
        to_return <- vector(mode = "list", length = length(POS_tagged_documents))
    } else {
        to_return <- rep("",length(POS_tagged_documents))
        to_return2 <- vector(mode = "list", length = length(POS_tagged_documents))
    }

    for (i in 1:length(POS_tagged_documents)) {
        cat("Extracting phrases from document",i,"of",length(POS_tagged_documents),"\n")
        # get the spans
        spans <- extract_ngram_filter(pos_tags = POS_tagged_documents[[i]]$tags,
                                      regex = regex,
                                      maximum_ngram_length = maximum_ngram_length,
                                      minimum_ngram_length = minimum_ngram_length)

        # only get phrases if we found spans
        if (!is.null(spans)) {
            # allocate phrases vector
            phrases <- rep("",nrow(spans))

            # if we are returning tags, tehn coarsen them to put in output
            if (return_tag_sequences) {
                pos_tags <- coarsen_POS_tags(POS_tagged_documents[[i]]$tags)
                tagseqs <- rep("",nrow(spans))
            }


            for (j in 1:length(phrases)) {
                #populate phrases vector
                phrases[j] <- paste0(
                    POS_tagged_documents[[i]]$tokens[spans[j,1]:spans[j,2]],
                    collapse = "_")
                if (return_tag_sequences) {
                    tagseqs[j] <- paste0(
                        pos_tags[spans[j,1]:spans[j,2]],
                        collapse = "")
                }
            }

            if (return_phrase_vectors) {
                if (return_tag_sequences) {
                    to_return[[i]] <- list(phrases = phrases,
                                           tags = tagseqs)
                } else {
                    to_return[[i]] <- phrases
                }
            } else {
                if (return_tag_sequences) {
                    to_return2[[i]] <- list(phrases =  paste0(phrases,collapse = " "),
                                            tags =  paste0(tagseqs,collapse = " "))
                } else {
                    to_return[i] <- paste0(phrases,collapse = " ")
                }
            }
        }
    }

    return(to_return)
}
