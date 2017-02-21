check_for_named_regexes <- function(regexes) {
    # initialize output vector
    output <- NULL

    # loop over the regular expressions and replace special names with the
    # appropriate regular expression, or just the supplied regular expression.
    for (i in 1:length(regexes)) {
        if (regexes[i] == "SimpleNP") {
            # allow the user to just put in "SimpleNP" for the regex, which gets
            # replaced with the correct regex.
            output <- c(output, "(A|N)*N(PD*(A|N)*N)*")
        } else if ((regexes[i] == "PhrasesNoCoord")){
            # thhis gets NP + VP (but with no coordination).
            output <- c(output,
                        "(A|N)*N(P+D*(A|N)*N)*", # Just NP
                        "((A|N)*N(P+D*(A|N)*N)*P*(M|V)*V(M|V)*|(M|V)*V(M|V)*D*(A|N)*N(P+D*(A|N)*N)*|(M|V)*V(M|V)*(P+D*(A|N)*N)+|(A|N)*N(P+D*(A|N)*N)*P*((M|V)*V(M|V)*D*(A|N)*N(P+D*(A|N)*N)*|(M|V)*V(M|V)*(P+D*(A|N)*N)+))") # Verb-Arg
        } else if ((regexes[i] == "Phrases")){
            # now get NP + VP with coordination
            output <- c(output,
                        "((A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*(C(D(CD)*)*(A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*)*)", # NP
                        "(((A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*(C(D(CD)*)*(A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*)*)(P(CP)*)*(M(CM)*|V)*V(M(CM)*|V)*(C(M(CM)*|V)*V(M(CM)*|V)*)*|(M(CM)*|V)*V(M(CM)*|V)*(C(M(CM)*|V)*V(M(CM)*|V)*)*(D(CD)*)*((A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*(C(D(CD)*)*(A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*)*)|(M(CM)*|V)*V(M(CM)*|V)*(C(M(CM)*|V)*V(M(CM)*|V)*)*((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)+|((A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*(C(D(CD)*)*(A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*)*)(P(CP)*)*((M(CM)*|V)*V(M(CM)*|V)*(C(M(CM)*|V)*V(M(CM)*|V)*)*(D(CD)*)*((A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*(C(D(CD)*)*(A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*)*)|(M(CM)*|V)*V(M(CM)*|V)*(C(M(CM)*|V)*V(M(CM)*|V)*)*((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)+))") # VP
        } else {
            # if the current rety in regexes is just a regex, then just append it
            # to the output vector
            output <- c(output, regexes[i])
        }
    }

    # return everything
    return(output)
}

# below are the methods by which I generated the above regexes. I decided to
# just hardcode them to minimize the possibility of weird OS specific issues.

# NP + verby grammar (no coordination)
# BaseNP <- "(A|N)*N"
# PP <- paste("P+D*",BaseNP, sep = "")
# NP <- paste(BaseNP,"(",PP,")*",sep = "")
# VG <- "(M|V)*V(M|V)*"
# SV <- paste(NP,"P*",VG,sep = "")
# VO <- paste(VG,"D*",NP,sep = "")
# VPP <- paste(VG,"(",PP,")+", sep = "")
# NPVP <- paste(NP,"P*","(",VO,"|",VPP,")",sep = "")
# VerbArg <- paste("(",SV,"|",VO,"|",VPP,"|",NPVP,")",sep ="")
# reg <- c(NP,VerbArg)

# NP + Very grammar (with coordination)
# A <- "A(CA)*"
# D <- "(D(CD)*)"
# M <- "M(CM)*"
# P <- "(P(CP)*)"
# BaseNP <- paste("(",A,"|N)*N",sep = "")
# PP <- paste(P,"+",D,"*",BaseNP, sep = "")
# NP1 <- paste(BaseNP,"(",PP,")*",sep = "")
# NP <- paste("(",NP1,"(C",D,"*",NP1,")*)",sep = "")
# VG1 <- paste("(",M,"|V)*V(",M,"|V)*", sep = "")
# VG <- paste(VG1,"(C",VG1,")*",sep = "")
# SV <- paste(NP,P,"*",VG,sep = "")
# VO <- paste(VG,D,"*",NP,sep = "")
# VPP <- paste(VG,"(",PP,")+", sep = "")
# NPVP <- paste(NP,P,"*","(",VO,"|",VPP,")",sep = "")
# VerbArg <- paste("(",SV,"|",VO,"|",VPP,"|",NPVP,")",sep ="")
# reg <- c(NP,VerbArg)
