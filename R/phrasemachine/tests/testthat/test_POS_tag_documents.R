context("POS Tagger")
test_that("See if tagging five documents works, and if coarsening works", {
    # load data
    corp <- quanteda::corpus(quanteda::inaugTexts)
    documents <- quanteda::texts(corp)[1:5]

    # run tagger
    tagged_documents <- POS_tag_documents(documents)

    # try coarsening one set of tags
    coarse_tags <- coarsen_POS_tags(tagged_documents[[1]]$tags)
})
