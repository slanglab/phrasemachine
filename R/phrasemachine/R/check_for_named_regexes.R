check_for_named_regexes <- function(regexes) {
    # if we are not doing anything, then
    output <- NULL

    # loop over the regular expressions and replace special names with the
    # appropriate regular expression.
    for (i in 1:length(regexes)) {
        if (regexes[i] == "SimpleNP") {
            output <- c(output, "(A|N)*N(PD*(A|N)*N)*")
        } else if ((regexes[i] == "PhrasesNoCoord")){
            output <- c(output,
                        "(A|N)*N(P+D*(A|N)*N)*",
                        "((A|N)*N(P+D*(A|N)*N)*P*(M|V)*V(M|V)*|(M|V)*V(M|V)*D*(A|N)*N(P+D*(A|N)*N)*|(M|V)*V(M|V)*(P+D*(A|N)*N)+|(A|N)*N(P+D*(A|N)*N)*P*((M|V)*V(M|V)*D*(A|N)*N(P+D*(A|N)*N)*|(M|V)*V(M|V)*(P+D*(A|N)*N)+))")
        } else if ((regexes[i] == "Phrases")){
            # now with coordination
            output <- c(output,
                        "((A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*(C(D(CD)*)*(A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*)*)",
                        "(((A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*(C(D(CD)*)*(A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*)*)(P(CP)*)*(M(CM)*|V)*V(M(CM)*|V)*(C(M(CM)*|V)*V(M(CM)*|V)*)*|(M(CM)*|V)*V(M(CM)*|V)*(C(M(CM)*|V)*V(M(CM)*|V)*)*(D(CD)*)*((A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*(C(D(CD)*)*(A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*)*)|(M(CM)*|V)*V(M(CM)*|V)*(C(M(CM)*|V)*V(M(CM)*|V)*)*((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)+|((A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*(C(D(CD)*)*(A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*)*)(P(CP)*)*((M(CM)*|V)*V(M(CM)*|V)*(C(M(CM)*|V)*V(M(CM)*|V)*)*(D(CD)*)*((A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*(C(D(CD)*)*(A(CA)*|N)*N((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)*)*)|(M(CM)*|V)*V(M(CM)*|V)*(C(M(CM)*|V)*V(M(CM)*|V)*)*((P(CP)*)+(D(CD)*)*(A(CA)*|N)*N)+))")
        } else {
            # if it is just a regex, then just append it to the vector
            output <- c(output, regexes)
        }
    }

    return(output)
}

# verby grammar (no coordination)
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

# # now try with the verby grammar (with coordination)
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
# reg <- c(VerbArg,NP)
