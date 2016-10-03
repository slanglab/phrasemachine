context("Phrase Extractor")
test_that("See if extractor works", {
    # load data
    corp <- quanteda::corpus(quanteda::inaugTexts)
    documents <- quanteda::texts(corp)[1:5]

    # run tagger
    tagged_documents <- POS_tag_documents(documents)

    phrases <- extract_phrases(tagged_documents,
                               regex = "(A|N)*N(PD*(A|N)*N)*",
                               maximum_ngram_length = 8,
                               return_phrase_vectors = TRUE)
})
