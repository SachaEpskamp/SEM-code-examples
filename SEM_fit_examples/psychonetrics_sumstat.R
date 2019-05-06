# devtools::install_github("sachaepskamp/psychonetrics")
library("psychonetrics")
library("dplyr")
library("lavaan")

# In this example, I will use the default dataset used in the lavaan documentation at ?sem,
# the ``industrialization and Political Democracy Example '' by Bollen (1989), page 332:
# The data is available in lavaan as:
PoliticalDemocracy
# More information on the data is available in ?PoliticalDemocracy. 

# This script fits the model using summary statistics (covariance matrix) see psychonetrics_rawdata.R 
# for an example using the raw data

# Cov matrix:
S <- cov(PoliticalDemocracy[,c("y1","y2","y3","y4","y5","y6","y7","y8","x1","x2","x3")])

# Sample size:
n <- nrow(PoliticalDemocracy)

# For psychonetrics, we need to rescale S to the ML Estimate!
S <- (n-1)/n * S

# Model 1: standard SEM model without equality constraints and residual covariances:
# Lambda matrix:
Lambda <- matrix(c(
  1,0,0, # dem60 =~ y1
  1,0,0, # dem60 =~ y2
  1,0,0, # dem60 =~ y3
  1,0,0, # dem60 =~ y4
  0,1,0, # dem65 =~ y5
  0,1,0, # dem65 =~ y6
  0,1,0, # dem65 =~ y7
  0,1,0, # dem65 =~ y8
  0,0,1, # ind60 =~ x1
  0,0,1, # ind60 =~ x2
  0,0,1 # ind60 =~ x3
),ncol=3,byrow=TRUE)

# Beta matrix:
Beta <- matrix(
  c(
  0,0,1,
  1,0,1,
  0,0,0
  ),3,3,byrow=TRUE
)

# Model:
mod1 <- lvm(covs = S, nobs = n, lambda = Lambda, beta = Beta)

# Run model:
mod1 <- mod1 %>% runmodel

# Look at fit:
mod1
mod1 %>% fit

# Model 2: SEM model with added residual covariances (model 1 is nested in this model):
# Method A is to adjust mod1:
mod2a <- mod1 %>% 
  freepar("sigma_epsilon","y1","y5") %>% 
  freepar("sigma_epsilon","y2","y4") %>% 
  freepar("sigma_epsilon","y2","y6") %>% 
  freepar("sigma_epsilon","y3","y7") %>% 
  freepar("sigma_epsilon","y4","y8") %>% 
  freepar("sigma_epsilon","y6","y8") %>% 
  runmodel

# Method B is to manually specify theta (called sigma_epsilon here):
# 'Theta' matrix:
Sigma_epsilon <- diag(11)
Sigma_epsilon[1,5] <- Sigma_epsilon[5,1] <- 1
Sigma_epsilon[2,4] <- Sigma_epsilon[4,2] <- 1
Sigma_epsilon[2,6] <- Sigma_epsilon[6,2] <- 1
Sigma_epsilon[3,7] <- Sigma_epsilon[7,3] <- 1
Sigma_epsilon[4,8] <- Sigma_epsilon[8,4] <- 1
Sigma_epsilon[6,8] <- Sigma_epsilon[8,6] <- 1

# Construct model:
mod2b <- lvm(covs = S, nobs = n, lambda = Lambda, beta = Beta, sigma_epsilon = Sigma_epsilon)

# Run model:
mod2b <- mod2b %>% runmodel

# Both methods are identical:
compare(mod2a,mod2b)

# Compare to previous model:
compare(mod1,mod2a)

# Model 3: SEM model with added residual covariances AND equality constrains (nested in model 2):
# Again two methods, first by adjusting previous model. This uses a new function (update from Github).
# The way to do this now is not very pretty yet...
# First we need to know the indices of parameters, simply the rows in the parameter table.
View(mod2a@parameters)
# 16, 17 and 18 are factor loadings of dem60 and 31, 32 and 33 are factor loadings of dem65:
mod3a <- mod2a %>% 
  parequal(16,31) %>% 
  parequal(17,32) %>% 
  parequal(18,33) %>% 
  runmodel

# The second method is to use the input matrices, with integers > 1 indicating equality constrains:
Lambda <- matrix(c(
  1,0,0, # dem60 =~ y1
  2,0,0, # dem60 =~ y2
  3,0,0, # dem60 =~ y3
  4,0,0, # dem60 =~ y4
  0,1,0, # dem65 =~ y5
  0,2,0, # dem65 =~ y6
  0,3,0, # dem65 =~ y7
  0,4,0, # dem65 =~ y8
  0,0,1, # ind60 =~ x1
  0,0,1, # ind60 =~ x2
  0,0,1 # ind60 =~ x3
),ncol=3,byrow=TRUE)

# Form model:
mod3b <- lvm(covs = S, nobs = n, lambda = Lambda, beta = Beta, sigma_epsilon = Sigma_epsilon)

# Run model:
mod3b <- mod3b %>% runmodel


# Both methods are identical:
compare(mod3a,mod3b)

# Compare to previous model:
compare(mod2b,mod3b)
