library("dplyr")
library("lavaan")

# Read the data, subset of summary statistics reported by:

# Duncan, S. C., & Duncan, T. E. (1996). A multivariate latent 
# growth curve analysis of adolescent substance use. Structural 
# Equation Modeling: A Multidisciplinary Journal, 3(4), 323-347.

# Sample size: 321

covMat <- as.matrix(read.csv("covmat_univariate.csv"))
rownames(covMat) <- colnames(covMat)
means <- read.csv("means_univariate.csv")[,1]

# Lavaan growth model:
mod <- '
# Alcohol:
i_alc =~ 1*alc1 + 1*alc2 + 1*alc3 + 1*alc4
s_alc =~ 1*alc1 + 2*alc2 + 3*alc3 + 4*alc4
'

# Fit model:
# If you have raw data you can ignore the argument sample.cov, sample.mean and sample.nobs and use
# the argument "data" instead"
fit <- growth(mod, sample.cov = covMat, sample.mean = means, sample.nobs = 321)

# Look at fit:
fitMeasures(fit)

# Look at parameter estimates:
parameterEstimates(fit)

# Latent correlations:
cov2cor(lavInspect(fit, "est")$psi)

# Plot diagram:
library("semPlot")
semPaths(fit, 
         fixedStyle = 1,
         intercepts = FALSE, 
         nCharNodes = 0
         )
