# Load packages:
library("dplyr") # I always load this

# Install psychonetrics devel version:
library("devtools")
install_github("sachaepskamp/psychonetrics")

# Load psychonetrics:
library("psychonetrics")

# Read the data:
Data <- read.csv("StarWars.csv", sep = ",")

# This data encodes the following variables:
# Q1: I am a huge Star Wars fan! (star what?)
# Q2: I would trust this person with my democracy.
# Q3: I enjoyed the story of Anakin's early life.
# Q4: The special effects in this scene are awful (Battle of Geonosis).
# Q5: I would trust this person with my life.
# Q6: I found Darth Vader'ss big reveal in "Empire" one of the greatest moments in movie history.
# Q7: The special effects in this scene are amazing (Death Star Explosion).
# Q8: If possible, I would definitely buy this droid.
# Q9: The story in the Star Wars sequels is an improvement to the previous movies.
# Q10: The special effects in this scene are marvellous (Starkiller Base Firing).
# Q11: What is your gender?
# Q12: How old are you?
# Q13: Have you seen any of the Star Wars movies?

# Factor loadings matrix:
Lambda <- matrix(0, 10, 3)
Lambda[1:4,1] <- 1
Lambda[c(1,5:7),2] <- 1
Lambda[c(1,8:10),3] <- 1

# Observed variables:
obsvars <- paste0("Q",1:10)

# Latents:
latents <- c("Prequels","Original","Sequels")

# Make model:
mod1 <- lvm(Data, lambda = Lambda, vars = obsvars, 
            identification = "variance", latents = latents)

# Run model:
mod1 <- mod1 %>% runmodel

# Look at fit:
mod1

# Look at parameter estimates:
mod1 %>% parameters

# Look at modification indices:
mod1 %>% MIs

# Add and refit:
mod2 <- mod1 %>% freepar("sigma_epsilon","Q10","Q4") %>% runmodel

# Compare:
compare(original = mod1, adjusted = mod2)

# Fit measures:
mod2 %>% fit

# Some extra things we can do: stepup search (alpha = 0.01 & BIC optimization):
mod3 <- mod2 %>% stepup(matrices = c("lambda", "sigma_epsilon"))

# The same in this case:
compare(stepup = mod3, adjusted = mod2)

# Bootstrap the difference:
mod1_withdata <- lvm(Data, lambda = Lambda, vars = obsvars, 
                     identification = "variance", latents = latents,
                     storedata = TRUE)

# Bootstrap data and run:
mod1_boot <- mod1_withdata %>% bootstrap %>% runmodel

# Add parameter and run:
mod2_boot <- mod1_boot %>% freepar("sigma_epsilon","Q10","Q4") %>% runmodel

# Compare:
compare(original_bootstrapped = mod1_boot,
        adjusted_bootstrapped = mod2_boot)


# Latent network model:
lnm <- lvm(Data, lambda = Lambda, vars = obsvars,
           latents = latents, identification = "variance",
           latent = "ggm")

# Run model:
lnm <- lnm %>% runmodel

# Look at parameters:
lnm %>% parameters

# Remove non-sig latent edge:
lnm <- lnm %>% prune(alpha = 0.05)

# Compare to the original CFA model:
compare(cfa = mod1, lnm = lnm)

# Plot network:
library("qgraph")
qgraph(lnm@modelmatrices$`1`$omega_zeta, labels = latents,
       theme = "colorblind", vsize = 10)

### NOT IN THE VIDEO ###
# A wrapper for the latent network model is the lnm function:
lnm2 <- lnm(Data, lambda = Lambda, vars = obsvars,
           latents = latents, identification = "variance")
lnm2 <- lnm2 %>% runmodel %>% prune(alpha = 0.05)
compare(lnm, lnm2) # Is the same as the model before.

# I could also estimate a "residual network model", which adds partial correlations to the residual level:
# This can be done using lvm(..., residal = "ggm") or with rnm(...)
rnm <- rnm(Data, lambda = Lambda, vars = obsvars,
            latents = latents, identification = "variance")
# Stepup search:
rnm <- rnm %>% stepup

# It will estimate the same model (with link Q10 - Q4) as above. In the case of only one partial correlation,
# There is no difference between residual covariances (SEM) or residual partial correlations (RNM).