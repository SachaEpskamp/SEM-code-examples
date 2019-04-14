#' Load packages:
library("dplyr") 

#' Install psychonetrics devel version:
library("devtools")
install_github("sachaepskamp/psychonetrics")

#' Load psychonetrics:
library("psychonetrics")

#' Read the data:
Data <- read.csv("StarWars.csv", sep = ",")

#' This data encodes the following variables:
#' 
#'   - Q1: I am a huge Star Wars fan! (star what?)
#'   - Q2: I would trust this person with my democracy.
#'   - Q3: I enjoyed the story of Anakin's early life.
#'   - Q4: The special effects in this scene are awful (Battle of Geonosis).
#'   - Q5: I would trust this person with my life.
#'   - Q6: I found Darth Vader'ss big reveal in "Empire" one of the greatest moments in movie history.
#'   - Q7: The special effects in this scene are amazing (Death Star Explosion).
#'   - Q8: If possible, I would definitely buy this droid.
#'   - Q9: The story in the Star Wars sequels is an improvement to the previous movies.
#'   - Q10: The special effects in this scene are marvellous (Starkiller Base Firing).
#'   - Q11: What is your gender?
#'   - Q12: How old are you?
#'   - Q13: Have you seen any of the Star Wars movies?
#' 
#' Let's say we are interested in seeing if people >= 30 like the original trilogy better than people < 30.
#' First we can make a grouping variable:
Data$agegroup <- ifelse(Data$Q12 < 30, "young", "less young")

#' Let's look at the distribution:
table(Data$agegroup) #' Pretty even...

#' Observed variables:
obsvars <- paste0("Q",1:10)

#' Let's look at the mean scores:
Data %>% group_by(agegroup) %>% summarize_each_(funs(mean),vars = obsvars)
#' Less young people seem to score higher on prequel questions and lower on other questions

#' Factor loadings matrix:
Lambda <- matrix(0, 10, 3)
Lambda[1:4,1] <- 1
Lambda[c(1,5:7),2] <- 1
Lambda[c(1,8:10),3] <- 1

#' Residual covariances:
Theta <- diag(1, 10)
Theta[4,10] <- Theta[10,4] <- 1

#' Latents:
latents <- c("Prequels","Original","Sequels")

#' Make model:
mod_configural <- lvm(Data, lambda = Lambda, vars = obsvars,
            latents = latents, sigma_epsilon = Theta,
            identification = "variance",
            groups =  "agegroup")

#' Run model:
mod_configural <- mod_configural %>% runmodel

#' Look at fit:
mod_configural
mod_configural %>% fit

#' Looks good, let's try weak invariance:
mod_weak <- mod_configural %>% groupequal("lambda") %>% runmodel

#' Compare models:
compare(configural = mod_configural, weak = mod_weak)

#' weak invariance can be accepted, let's try strong:
mod_strong <- mod_weak %>% groupequal("tau") %>% runmodel
#' Means are automatically identified

#' Compare models:
compare(configural = mod_configural, weak = mod_weak, strong = mod_strong)

#' Questionable p-value and AIC difference, but ok BIC difference. This is quite good, but let's take a look.
#' I have not yet implemented LM tests for equality constrains, but we can loko at something called "equality-free" MIs:
mod_strong %>% MIs(matrices = "tau", type = "free")

#' Indicates that Q10 would improve fit. We can also look at residuals:
residuals(mod_strong)

#' Let's try freeing intercept 10:
mod_strong_partial <- mod_strong %>% groupfree("tau",10) %>% runmodel

#' Compare all models:
compare(configural = mod_configural,
        weak = mod_weak,
        strong = mod_strong,
        strong_partial = mod_strong_partial)

#' This seems worth it and lead to an acceptable model! It seems that older people find the latest special effects more marvellous!
mod_strong_partial %>% getmatrix("tau")

#' Now let's investigate strict invariance:
mod_strict <- mod_strong_partial %>% groupequal("sigma_epsilon") %>% runmodel

#' Compare all models:
compare(configural = mod_configural,
        weak = mod_weak,
        strong_partial = mod_strong_partial,
        strict = mod_strict)
#' Strict invariance can be accepted!

#'  Now we can test for homogeneity!
#' Are the latent variances equal?
mod_eqvar <- mod_strict %>% groupequal("sigma_zeta") %>% runmodel

#' Compare:
compare(strict = mod_strict, eqvar = mod_eqvar) 

#' This is acceptable. What about the means? (alpha = tau_eta)
mod_eqmeans <- mod_eqvar %>% groupequal("tau_eta") %>% runmodel

#' Compare:
compare(eqvar = mod_eqvar, eqmeans = mod_eqmeans)

#' Rejected! We could look at MIs again:
mod_eqmeans %>% MIs(matrices = "tau_eta", type = "free")

#' Indicates the strongest effect for prequels. Let's see what happens:
eqmeans2 <- mod_eqvar %>% groupequal("tau_eta",row = c("Original","Sequels")) %>% runmodel

#' Compare:
compare(eqvar = mod_eqvar, eqmeans = eqmeans2)
#' Questionable, what about the sequels as well?

eqmeans3 <- mod_eqvar %>% groupequal("tau_eta", row = "Original") %>% runmodel

#' Compare:
compare(eqvar = mod_eqvar, eqmeans = eqmeans3)

#' Still questionable.. Let's look at the mean differences:
mod_eqvar %>% getmatrix("tau_eta")

#' Looks like people over 30 like the prequels better and the other two trilogies less!