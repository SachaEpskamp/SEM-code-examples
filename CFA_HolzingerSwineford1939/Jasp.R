library("lavaan")

# Load data:
data("HolzingerSwineford1939")
Data <- HolzingerSwineford1939[,c("x1","x2","x3","x4","x5","x6","x7","x8","x9")]

# Write for Jasp:
write.csv(Data, file = "HolzingerSwineford1939.csv", row.names = FALSE)