context("POS Tagger")
test_that("See if tagging five documents works, and if coarsening works", {
    requireNamespace("quanteda", quietly = TRUE)
    # load in U.S. presidential inaugural speeches from Quanteda example data.
    documents <- quanteda::data_corpus_inaugural
    # use first 10 documents for example
    documents <- documents[1:5,]

    # run tagger
    tagged_documents <- POS_tag_documents(documents)

    # try coarsening one set of tags
    coarse_tags <- coarsen_POS_tags(tagged_documents[[1]]$tags)
})
