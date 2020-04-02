library("dplyr")
library("devtools")
library("psychonetrics")

#' Read the data, subset of summary statistics reported by:

#' Duncan, S. C., & Duncan, T. E. (1996). A multivariate latent 
#' growth curve analysis of adolescent substance use. Structural 
#' Equation Modeling: A Multidisciplinary Journal, 3(4), 323-347.

#' Sample size: 321

covMat <- as.matrix(read.csv("covmat_univariate.csv"))
rownames(covMat) <- colnames(covMat)
means <- read.csv("means_univariate.csv")[,1]

#' I have implemented a wrapper called 'latentgrowth' that automates the model specification
#' This requires a Design matrix. This matrix controls the design of the latent growth model.
#' It must contain character strings with the names of your variables.
#' The rows indicate variables and the columns indicare time points.
#' E.g., here the row indicates "alcohol", the columns indicate time points
#' 1, 2, 3 and 4, and the unique values indicate the names of the variables
#' indicating alcohol at time 1, 2, 3 and 4:
vars <- matrix(colnames(covMat), nrow = 1, ncol = 4, byrow = TRUE)
rownames(vars) <- "alc"

#' If you have raw data you can ignore the argument covs, means and nobs and use
#' the argument "data" instead". We can  construct the model (note I rescale the cov matrix 
#' here manually to max likelihood estimate):
mod <- latentgrowth(vars, covs = (321-1)/321 * covMat, means = means, nobs = 321)

#' Run model:
mod <- mod %>% runmodel

#' Look at fit:
mod
mod %>% fit

#' Look at parameters:
mod %>% parameters

#' Latent correlations:
cov2cor(getmatrix(mod,"sigma_zeta"))

#' We could also specify the model manually via lvm:
mod_lvm <- lvm(covs = (321-1)/321 * covMat, means = means, nobs = 321,
               lambda = matrix(1,4,2))

#' Fix intercept loadings:
mod_lvm <- mod_lvm %>% fixpar("lambda",row=1:4,col=1,value = 1)

#' Fix slope loadings:
mod_lvm <- mod_lvm %>% 
  fixpar("lambda",row=1,col=2,value = 1) %>% 
  fixpar("lambda",row=2,col=2,value = 2) %>% 
  fixpar("lambda",row=3,col=2,value = 3) %>% 
  fixpar("lambda",row=4,col=2,value = 4)

#' Fix intercepts:
mod_lvm <- mod_lvm %>% fixpar("nu", row = 1:4, col = 1, value = 1)

#' Free latent means:
mod_lvm <- mod_lvm %>% freepar("nu_eta", row = 1:2, col = 1)

#' Run the model:
mod_lvm <- mod_lvm %>% runmodel

#' This model is the same!
compare(mod, mod_lvm)
