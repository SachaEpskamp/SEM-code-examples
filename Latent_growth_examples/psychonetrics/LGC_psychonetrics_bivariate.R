library("dplyr")
library("devtools")
library("psychonetrics")

# Read the data, subset of summary statistics reported by:

# Duncan, S. C., & Duncan, T. E. (1996). A multivariate latent 
# growth curve analysis of adolescent substance use. Structural 
# Equation Modeling: A Multidisciplinary Journal, 3(4), 323-347.

# Sample size: 321

covMat <- as.matrix(read.csv("covmat_bivariate.csv"))
rownames(covMat) <- colnames(covMat)
means <- read.csv("means_bivariate.csv")[,1]

# Design matrix. This matrix controls the design of the latent grwoth model.
# It must contain character strings with the names of your variables.
# The rows indicate variables and the columns indicare time points.
# E.g., here the first row indicates "alcohol", the columns indicate time points
# 1, 2, 3 and 4, and the unique values of the first row indicate the names of the variables
# indicating alcohol at time 1, 2, 3 and 4:
vars <- matrix(colnames(covMat), nrow = 2, ncol = 4, byrow = TRUE)
rownames(vars) <- c("alc","cig")

# Form model (note I rescale the cov matrix here manually to max likelihood estimate):
# If you have raw data you can ignore the argument covs, means and nobs and use
# the argument "data" instead"
mod <- latentgrowth(vars, covs = covMat, means = means, nobs = 321)

# Run model:
mod <- mod %>% runmodel


mod %>% parameters

# Look at fit:
mod
mod %>% fit

# Look at parameters:
mod %>% parameters
