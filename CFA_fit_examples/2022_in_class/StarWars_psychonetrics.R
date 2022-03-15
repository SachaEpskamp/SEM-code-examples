# Load packages:
library("dplyr") # I always load this
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

print(Lambda)

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

# Confidence intervals:
library("ggplot2")
CIplot(mod1, "lambda")
CIplot(mod1, "sigma_zeta", labelstart = 0.5) + ylim(-0.1,1)

# Extract implied and observed correlations:
observed_cors <- cov2cor(mod1@sample@covs$fullsample)
implied_cors <-  cov2cor(getmatrix(mod1, "sigma"))

# Obtain strongest correlation (for making graphs comparable):
max <- max(abs(c(observed_cors[upper.tri(observed_cors)],implied_cors[upper.tri(implied_cors)])))

# Plot these:
library("qgraph")
layout(t(1:2))
qgraph(observed_cors, labels = obsvars, theme = "colorblind", title = "observed", maximum = max)
qgraph(implied_cors, labels = obsvars, theme = "colorblind", title = "implied", maximum = max)
