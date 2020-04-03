# Load the package:
library("umx")
library("lavaan")

# Load data:
data("HolzingerSwineford1939")
Data <- HolzingerSwineford1939

# Model:
Model <- '
  visual  =~ x1 + x2 + x3
  textual =~ x4 + x5 + x6
  speed   =~ x7 + x8 + x9
'

# Fit in lavaan:
fit <- umxRAM(Model,data =  Data)

# Inspect fit:
umxSummary(fit)
