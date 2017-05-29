context("Phrase Extractor")
test_that("See if extractor works", {
    requireNamespace("quanteda", quietly = TRUE)
    # load in U.S. presidential inaugural speeches from Quanteda example data.
    documents <- quanteda::data_corpus_inaugural
    # use first 10 documents for example
    documents <- documents[1:5,]

    # run tagger
    tagged_documents <- POS_tag_documents(documents)

    phrases <- extract_phrases(tagged_documents,
                               regex = "(A|N)*N(PD*(A|N)*N)*",
                               maximum_ngram_length = 8,
                               minimum_ngram_length = 1)
})



