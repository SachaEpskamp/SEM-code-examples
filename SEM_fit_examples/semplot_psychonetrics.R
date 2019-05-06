library("lavaan")
library("semPlot")

# Using model 2 from psychonetrics_rawdata.R:

# Model 2: SEM model with added residual covariances (model 1 is nested in this model):
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
Sigma_epsilon <- diag(11)
Sigma_epsilon[1,5] <- Sigma_epsilon[5,1] <- 1
Sigma_epsilon[2,4] <- Sigma_epsilon[4,2] <- 1
Sigma_epsilon[2,6] <- Sigma_epsilon[6,2] <- 1
Sigma_epsilon[3,7] <- Sigma_epsilon[7,3] <- 1
Sigma_epsilon[4,8] <- Sigma_epsilon[8,4] <- 1
Sigma_epsilon[6,8] <- Sigma_epsilon[8,6] <- 1

# Construct model:
mod2b <- lvm(PoliticalDemocracy, lambda = Lambda, beta = Beta, sigma_epsilon = Sigma_epsilon)

# Run model:
mod2b <- mod2b %>% runmodel

# Estravct matrices:
Psi_est <- getmatrix(mod2b, "sigma_zeta")[[1]]
Lambda_est <- getmatrix(mod2b, "lambda")[[1]]
Beta_est <- getmatrix(mod2b, "beta")[[1]]
Theta_est <- getmatrix(mod2b, "sigma_epsilon")[[1]]

# Make semPlot model:
plotmod <- lisrelModel(
  LY = Lambda_est, PS = Psi_est, TE = Theta_est, BE = Beta_est,
  manNamesEndo = names(PoliticalDemocracy),
  latNamesEndo = c("dem60","dem65","ind60") 
)

# This is an all-y model, let;s make ind60 exogenous:
plotmod@Vars$exogenous[plotmod@Vars$name %in% c("x1","x2","x3","ind60")] <- TRUE

# Some possible semPlot examples:
semPaths(plotmod,"mod","est", edge.color = "black", style = "lisrel", residScale = 8) # Nice already, another three based options is:
semPaths(plotmod,"mod","est", layout = "tree2", edge.color = "black", 
         style = "lisrel", residScale = 8)

# Also nice is the layoutSplit option for complicated models:
semPaths(plotmod,"mod","est", layoutSplit = TRUE, 	subScale = 0.3,
         rotation = 2, edge.color = "black", style = "lisrel", 
         residScale = 8)

# Some pretty colors:
semPaths(plotmod,"col","est", layout = "tree2", 
         style = "lisrel", residScale = 8,
         groups = "latents", 
         pastel = TRUE, 
         borders = FALSE)
