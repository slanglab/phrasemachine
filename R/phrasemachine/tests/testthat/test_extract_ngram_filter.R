context("Span Extractor")
test_that("Unit test for specific tag patterns", {

    get_spans <- function(pos_tags, minimum_ngram_length) {
        spans <- extract_ngram_filter(pos_tags,
                                      regex = "(A|N)*N(PD*(A|N)*N)*",
                                      maximum_ngram_length = 8,
                                      minimum_ngram_length = minimum_ngram_length)
        return(spans)
    }

    # try all of Brendan's test cases

    pos_tags = c("JJ", "NN", "NN")
    spans <- get_spans(pos_tags, minimum_ngram_length = 2)
    correct <- c(1,1,2,2,3,3)
    expect_equal(c(spans), correct)

    pos_tags = c("VB", "JJ", "NN", "NN")
    spans <- get_spans(pos_tags, minimum_ngram_length = 2)
    correct <- c(2,2,3,3,4,4)
    expect_equal(c(spans), correct)

    pos_tags = c("VB", "JJ", "NN")
    spans <- get_spans(pos_tags, minimum_ngram_length = 2)
    correct <- c(2,3)
    expect_equal(c(spans), correct)

    pos_tags = c("NN")
    spans <- get_spans(pos_tags, minimum_ngram_length = 2)
    correct <- NULL
    expect_equal(c(spans), correct)

    spans <- get_spans(pos_tags, minimum_ngram_length = 1)
    correct <- c(1,1)
    expect_equal(c(spans), correct)


})
