#' @title POS tag documents
#' @description Annotates documents (proived as a character vector with one
#' entry per document) with pars-of-speech (POS) tags using the openNLP POS
#' tagger
#'
#' @param documents A vector of strings (one per document).
#' @return A list object.
#' @export
POS_tag_documents <- function(documents){

    # create a list object to store tagged tokens
    tagged_documents <- vector(mode = "list", length = length(documents))

    # loop through documents and tag them
    for (i in 1:length(documents)) {
        cat("Currently tagging document",i,"of",length(documents),"\n")

        # extract the current document
        document <- documents[i]

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
