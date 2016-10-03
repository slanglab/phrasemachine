#' @title POS tag and extract phrases from a collection of documents
#' @description Extracts phrases from a set of documents using the
#' "FilterFSA" method in Handler et al. 2016.
#'
#' @param documents A vector of strings (one per document).
#' @param regex The regualr expression used to find phrases. Defaults to
#' "(A|N)*N(PD*(A|N)*N)*", as in Handler et al. 2016.
#' @param maximum_ngram_length The maximum length phrases returned. Defaults to
#' 8. Increasing this number can greatly increase runtime.
#' @param return_phrase_vectors Logical indicating whether a list of phrase
#' vectors (with each entry contain a vector of phrases in one document) should
#' be returned, or whether phrases should combined into a single space separated
#' string.
#' @examples
#' # load five example documents from the quanteda package
#' corp <- quanteda::corpus(quanteda::inaugTexts)
#' documents <- quanteda::texts(corp)[1:5]
#' # extract phrases using phrasemachine
#' phrases <- phrasemachine(documents)
#' @return A list object.
#' @export
phrasemachine <- function(documents,
                          regex = "(A|N)*N(PD*(A|N)*N)*",
                          maximum_ngram_length = 8,
                          return_phrase_vectors = TRUE) {

    # tag documents
    tagged_documents <- POS_tag_documents(documents)

    # extract phrases
    phrases <- extract_phrases(tagged_documents,
                               regex = regex,
                               maximum_ngram_length = maximum_ngram_length,
                               return_phrase_vectors = return_phrase_vectors)

    return(phrases)
}
