# Load the package:
library("lavaan")
library("dplyr")

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
fit <- cfa(Model, Data)

# Inspect fit:
fit

# Parameter estimates:
parameterestimates(fit)

# Fit measures:
fitMeasures(fit)

# Modification indices:
modificationindices(fit) %>% arrange(-mi)

# Model with extra residual covariance:
# Model:
Model2 <- '
  visual  =~ x1 + x2 + x3
  textual =~ x4 + x5 + x6
  speed   =~ x7 + x8 + x9
  visual =~ x9
'

# Fit in lavaan:
fit2 <- cfa(Model2, Data)

# Compare models:
anova(fit, fit2)
