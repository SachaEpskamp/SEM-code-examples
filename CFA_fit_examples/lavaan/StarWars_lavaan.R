# Load packages:
library("dplyr") # I always load this
library("lavaan")

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

# Three factor model for trilogies using lavaan:
Model <- '
# Factor loadings:
Prequels =~ 1*Q2 + Q3 + Q4 + Q1
Original =~ 1*Q5 + Q6 + Q7 + Q1
Sequels =~ 1*Q8 + Q9 + Q10 + Q1

# Reisdual variances:
Q1 ~~ Q1
Q2 ~~ Q2
Q3 ~~ Q3
Q4 ~~ Q4
Q5 ~~ Q5
Q6 ~~ Q6
Q7 ~~ Q7
Q8 ~~ Q8
Q9 ~~ Q9
Q10 ~~ Q10

# Factor variances / covariances:
Prequels ~~ Prequels
Prequels ~~ Original
Prequels ~~ Sequels
Original ~~ Original
Original ~~ Sequels
Sequels ~~ Sequels
'

# Fit model in lavaan:
fit <- lavaan(Model, Data)

# Look at fit:
fit

# We can do this easier with the cfa function!
Model <- '
Prequels =~ Q2 + Q3 + Q4 + Q1
Original =~ Q5 + Q6 + Q7 + Q1
Sequels =~ Q8 + Q9 + Q10 + Q1
'

# Fit in lavaan:
fit <- cfa(Model, Data) # Automatically sets first factor loading to 1. Use std.lv = TRUE for latent variable variance scaling!

# Look at fit:
fit

# Let's look at the top 10 modification indices:
modificationindices(fit) %>% arrange(-mi) %>% head(10) # These are some dplyr tricks

# We could add Q4 ~~ Q10 (special effects of prequels and sequels)
Model2 <- '
Prequels =~ Q2 + Q3 + Q4 + Q1
Original =~ Q5 + Q6 + Q7 + Q1
Sequels =~ Q8 + Q9 + Q10 + Q1
Q4 ~~ Q10
'

# Fit in lavaan:
fit2 <- cfa(Model2, Data) # Automatically sets first factor loading to 1. Use std.lv = TRUE for latent variable variance scaling!

# Compare fit:
anova(fit,fit2)
# Fit 2 has better AIC, BIC and fits significantly better, so it would be prefered. 
# However, we could make a good argument *not* to add this parameter, as the model
# already fit well and the previous model was *theoretical*.

# Let's fit the model using scaling in latent variable variance, it makes raw parameters a bit easier to interpret:
fit2b <- cfa(Model2, Data, std.lv=TRUE)

# It is the same model:
anova(fit2,fit2b)

# look at the parameter estimates:
parameterestimates(fit2b)

# Some things to note: the star wars fandom questionary only strongly loads on the original factor, and relatively low correlations with the prequel trilogy

# Look at fit measures:
fitMeasures(fit2b) # All really good!

# Finally, we could also fit the model using only the covariances!
covMat <- cov(Data[,1:10])
fit2c <- cfa(Model2, sample.cov = covMat, sample.nobs = nrow(Data))

# Gives the same mode:
anova(fit2b, fit2c)
