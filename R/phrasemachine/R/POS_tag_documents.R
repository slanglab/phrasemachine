#' @title POS tag documents
#' @description Annotates documents (proived as a character vector with one
#' entry per document) with pars-of-speech (POS) tags using the openNLP POS
#' tagger
#'
#' @param documents A vector of strings (one per document).
#' @param memory The default amount of memory (512MB) assigned to the NLP
#' package to POS tag documents is often not enough for large documents, which
#' can lead to a "java.lang.OutOfMemoryError". The memory argument defaults to
#' "-Xmx2g" (2GB) in this package, and can be increased if necessary to
#' accomodate very large documents.
#' @return A list object.
#' @examples
#' \dontrun{
#' # load data
#' documents <- quanteda::data_corpus_inaugural
#  documents <- documents[1:10,]
#'
#' # run tagger
#' tagged_documents <- POS_tag_documents(documents)
#' }
#' @export
POS_tag_documents <- function(documents,
                              memory = "-Xmx2g"){

    # set the amount of heap space available to Java in the NLP package
    options(java.parameters = memory)

    # NULL out to deal with R CMD check note
    type <- NULL

    # create a list object to store tagged tokens
    tagged_documents <- vector(mode = "list", length = length(documents))

    # loop through documents and tag them
    for (i in 1:length(documents)) {
        cat("Currently tagging document",i,"of",length(documents),"\n")

        # extract the current document
        document <- documents[i]

        # get rid of extra spaces.
        document <- stringr::str_replace_all(document,"[\\s]+"," ")
        document <- stringr::str_replace_all(document,"[\\s]$","")

        document <- NLP::as.String(document)

        # annotate words with POS tags
        wordAnnotation <- NLP::annotate(
            document,
            list(openNLP::Maxent_Sent_Token_Annotator(),
                 openNLP::Maxent_Word_Token_Annotator()))
        POSAnnotation <- NLP::annotate(
            document,
            openNLP::Maxent_POS_Tag_Annotator(),
            wordAnnotation)

        # extract the tagged words so we can get the tokens
        POSwords <- subset(POSAnnotation, type == "word")

        # extract the tokens and tags
        tags <- sapply(POSwords$features, '[[', "POS")
        tokens <- document[POSwords][1:length(tags)]

        # store everything in a list object
        tagged_documents[[i]] <- list(tokens = tokens,
                                      tags = tags)
    }

    # give the documents names or pass on names if they were provided
    if (is.null(names(documents))) {
        names(tagged_documents) <- paste("Document_",1:length(documents),sep = "")
    } else {
        names(tagged_documents) <- names(documents)
    }

    # return everything
    return(tagged_documents)
}
