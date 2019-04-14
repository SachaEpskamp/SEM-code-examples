library("dplyr")
library("lavaan")

# Read the data, subset of summary statistics reported by:

# Duncan, S. C., & Duncan, T. E. (1996). A multivariate latent 
# growth curve analysis of adolescent substance use. Structural 
# Equation Modeling: A Multidisciplinary Journal, 3(4), 323-347.

# Sample size: 321

covMat <- as.matrix(read.csv("covmat_bivariate.csv"))
rownames(covMat) <- colnames(covMat)
means <- read.csv("means_bivariate.csv")[,1]

# Lavaan growth model:
mod <- '
# Alcohol:
i_alc =~ 1*alc1 + 1*alc2 + 1*alc3 + 1*alc4
s_alc =~ 1*alc1 + 2*alc2 + 3*alc3 + 4*alc4

# Cigarettes:
i_cig =~ 1*cig1 + 1*cig2 + 1*cig3 + 1*cig4
s_cig =~ 1*cig1 + 2*cig2 + 3*cig3 + 4*cig4
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

# Small hack to make nicer path diagram:
library("semPlot")
semPathsMod <- semPlotModel(fit)
semPathsMod@Vars$exogenous[grepl("cig",semPathsMod@Vars$name)] <- TRUE

# Plot diagram:
semPaths(semPathsMod, 
         intercepts = FALSE, 
         curve = 0,
         nCharNodes = 0
         )