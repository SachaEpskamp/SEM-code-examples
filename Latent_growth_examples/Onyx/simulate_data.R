library("dplyr")
library("MASS")

# Read the data, subset of summary statistics reported by:

# Duncan, S. C., & Duncan, T. E. (1996). A multivariate latent 
# growth curve analysis of adolescent substance use. Structural 
# Equation Modeling: A Multidisciplinary Journal, 3(4), 323-347.

# Sample size: 321

covMat <- as.matrix(read.csv("covmat_bivariate.csv"))
rownames(covMat) <- colnames(covMat)
means <- read.csv("means_bivariate.csv")[,1]

# Generate a dataset with same means and cov matrix:
library(MASS)
simData <- mvrnorm(321, mu = means, Sigma = covMat, empirical = TRUE)
names(simData) <- colnames(covMat)
write.csv(simData,"simulatedData.csv", row.names = FALSE)

