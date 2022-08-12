#' The four known cycles for the standard parameterisation.
#' As a "list of lists", you can iterate over them as
#' for (KC in KNOWN.CYCLES[[1]]) with an inner for (val in KC)
KNOWN.CYCLES <- list(c(list(c(1, 4, 2)), list(c(-1, -2)), list(c(-5, -14, -7, -20, -10)),
    list(c(-17, -50, -25, -74, -37, -110, -55, -164, -82, -41, -122, -61, -182, -91, -272, -136, -68, -34))))
lockBinding("KNOWN.CYCLES", globalenv())

# for (KC in KNOWN.CYCLES[[1]]){
#     print(KC)
#     for (val in KC){
#         print(val)
#     }
# }

# too large to add until implementing arb ints
# VERIFIED.MAXIMUM <- 295147905179352825856
# lockBinding("VERIFIED.MAXIMUM", globalenv())

VERIFIED.MINIMUM <- -272
lockBinding("VERIFIED.MINIMUM", globalenv())

SaneParameterErrMsg <- list(c(P="'P' should not be 0 ~ violates modulo being non-zero.", A="'a' should not be 0 ~ violates the reversability."))
lockBinding("SaneParameterErrMsg", globalenv())

SequenceState <- list()

print(VERIFIED.MINIMUM)
