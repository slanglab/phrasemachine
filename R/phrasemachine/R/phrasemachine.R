#' @title POS tag and extract phrases from a collection of documents
#' @description Extracts phrases from a set of documents using the
#' "FilterFSA" method in Handler et al. 2016.
#'
#' @param documents A vector of strings (one per document).
#' @param regex The regular expression used to find phrases. Defaults to
#' "(A|N)*N(PD*(A|N)*N)*", the "SimpleNP" grammar in Handler et al. 2016. A
#' vector of regular expressions may also be provided if the user wishes to
#' match more than one.
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
#' @param memory The default amount of memory (512MB) assigned to the NLP
#' package to POS tag documents is often not enough for large documents, which
#' can lead to a "java.lang.OutOfMemoryError". The memory argument defaults to
#' "-Xmx512M" (512MB) in this package, and can be increased if necessary to
#' accommodate very large documents.
#' @examples
#' phrasemachine("Hello there my red good cat.")
#' @return A list object.
#' @export
phrasemachine <- function(documents,
                          regex = "(A|N)*N(PD*(A|N)*N)*",
                          maximum_ngram_length = 8,
                          minimum_ngram_length = 2,
                          return_phrase_vectors = TRUE,
                          return_tag_sequences = FALSE,
                          memory = "-Xmx512M") {

    # tag documents
    tagged_documents <- POS_tag_documents(documents,
                                          memory = memory)

    # extract phrases
    phrases <- extract_phrases(tagged_documents,
                               regex = regex,
                               maximum_ngram_length = maximum_ngram_length,
                               minimum_ngram_length = minimum_ngram_length,
                               return_phrase_vectors = return_phrase_vectors,
                               return_tag_sequences = return_tag_sequences)

    return(phrases)
}
