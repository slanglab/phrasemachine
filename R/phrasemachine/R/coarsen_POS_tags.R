#' @title Coarsen POS tags
#' @description Coarsens PTB or Petrov/Gimpel coarse tags into one of five
#' categories:
#' 'A' = adjective, 'D' = determiner, 'P' = preposition,
#' 'N' = common/proper noun, 'O' = all else
#' @param tag_vector A vector of POS tags.
#' @return A vector of coarse tags.
#' @export
coarsen_POS_tags <- function(tag_vector) {
    for (i in 1:length(tag_vector)) {
        if (tag_vector[i] %in% c("JJ","JJR","JJS","CoarseADJ", "CD", "CoarseNUM")) {
            tag_vector[i] <- "A"
        } else if (tag_vector[i] %in% c("DT","CoarseDET")) {
            tag_vector[i] <- "D"
        } else if (tag_vector[i] %in% c("IN", "TO", "CoarseADP")) {
            tag_vector[i] <- "P"
        } else if (tag_vector[i] %in% c("NN", "NNS", "NNP", "NNPS", "FW", "CoarseNOUN")) {
            tag_vector[i] <- "N"
        } else {
            tag_vector[i] <- "O"
        }
    }
    return(tag_vector)
}
