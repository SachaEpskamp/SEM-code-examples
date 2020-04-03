# Load the package:
library("lavaan")

# Load data:
data("HolzingerSwineford1939")
Data <- HolzingerSwineford1939

# Model:
Model <- '
  # Factor loadings:
  visual  =~ 1*x1 + x2 + x3
  textual =~ 1*x4 + x5 + x6
  speed   =~ 1*x7 + x8 + x9
  
  # Factor variances:
  visual ~~ visual + textual + speed
  textual ~~ textual + speed
  speed ~~ speed
  
  # Residual variances:
  x1 ~~ x1
  x2 ~~ x2
  x3 ~~ x3
  x4 ~~ x4
  x5 ~~ x5
  x6 ~~ x6
  x7 ~~ x7
  x8 ~~ x8
  x9 ~~ x9
'

# Fit in lavaan:
fit <- lavaan(Model, Data)

# Inspect fit:
fit

# Parameter estimates:
parameterestimates(fit)

# Fit measures:
fitMeasures(fit)

# Modification indices:
modificationindices(fit) %>% arrange(-mi)