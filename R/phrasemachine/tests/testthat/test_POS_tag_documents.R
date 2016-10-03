context("Factorial Preprocessing")
test_that("Small example works", {
    # load data
    corp <- quanteda::corpus(quanteda::inaugTexts)
    documents <- quanteda::texts(corp)[1:5]

    # run tagger
    tagged_documents <- POS_tag_documents(documents)


})
