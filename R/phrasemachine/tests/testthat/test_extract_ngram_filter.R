context("Span Extractor")
test_that("Unit test for specific tag patterns", {

    get_spans <- function(pos_tags, exclude_unigrams = TRUE) {
        spans <- extract_ngram_filter(pos_tags,
                                      regex = "(A|N)*N(PD*(A|N)*N)*",
                                      maximum_ngram_length = 8,
                                      exclude_unigrams = exclude_unigrams)
        return(spans)
    }

    # try all of Brendan's test cases

    pos_tags = c("JJ", "NN", "NN")
    spans <- get_spans(pos_tags, exclude_unigrams = TRUE)
    correct <- c(1,1,2,2,3,3)
    expect_equal(c(spans), correct)

    pos_tags = c("VB", "JJ", "NN", "NN")
    spans <- get_spans(pos_tags, exclude_unigrams = TRUE)
    correct <- c(2,2,3,3,4,4)
    expect_equal(c(spans), correct)

    pos_tags = c("VB", "JJ", "NN")
    spans <- get_spans(pos_tags, exclude_unigrams = TRUE)
    correct <- c(2,3)
    expect_equal(c(spans), correct)

    pos_tags = c("NN")
    spans <- get_spans(pos_tags, exclude_unigrams = TRUE)
    correct <- NULL
    expect_equal(c(spans), correct)

    spans <- get_spans(pos_tags, exclude_unigrams = FALSE)
    correct <- c(1,1)
    expect_equal(c(spans), correct)


})
