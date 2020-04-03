library("lavaan")
library("MplusAutomation") # <- is NOT Mplus, but a wrapper around mplus

# Load data:
data("HolzingerSwineford1939")
Data <- HolzingerSwineford1939[,c("x1","x2","x3","x4","x5","x6","x7","x8","x9")]

# Export for Mplus:
prepareMplusData(Data, filename = paste0(getwd(),"/HolzingerSwineford1939.dat"))
