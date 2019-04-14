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

# Let's say we are interested in seeing if people >= 30 like the original trilogy better than people < 30.
# First we can make a grouping variable:
Data$agegroup <- ifelse(Data$Q12 < 30, "young", "less young")

# Let's look at the distribution:
table(Data$agegroup) # Pretty even...

# Test for configural invariance:
Model <- '
Prequels =~ Q2 + Q3 + Q4 + Q1
Original =~ Q5 + Q6 + Q7 + Q1
Sequels =~ Q8 + Q9 + Q10 + Q1
Q4 ~~ Q10
'
conf <- cfa(Model, Data, group = "agegroup")

# Look at fit:
conf # P > 0.05 so we do not reject exact fit!
fitMeasures(conf) # Looks good!

# Test for weak invariance:
weak <- cfa(Model, Data, group = "agegroup",
            group.equal = "loadings")

# Compare groups:
anova(conf,weak) # Weak variance is accepted

# Test for strong invariance:
strong <- cfa(Model, Data, group = "agegroup",
            group.equal = c("loadings","intercepts"))

# Compare groups:
anova(conf,weak, strong) # Questionable... 

# What do the residuals tell us?
residuals(strong) # Some misfit in Q8 and Q10 in both groups

# And the lagrange multiplier tests?
lavTestScore(strong)$uni %>% arrange(-X2)
# Tells me .p37 and .p39., which parameters are those:

parameterEstimates(strong)
# Intercepts for Q8 and Q10, Q10 is the highest

# Lets' try freeing up intercept for Q10 on special effects (this is also reasonable, it could be that older
# people judge special effects on different criteria than younger people).
strong_partial <- cfa(Model, Data, group = "agegroup",
              group.equal = c("loadings","intercepts"),
              group.partial = "Q10 ~ 1")

# Compare:
anova(conf,weak, strong_partial) 
# The partial strong invariance model can be accepted

# Test for strict invariance:
strict <- cfa(Model, Data, group = "agegroup",
              group.equal = c("loadings","intercepts","residuals",
              "residual.covariances"),
              group.partial = "Q10 ~ 1")

# Compare:
anova(conf,weak, strong_partial, strict) 
# Strict invariance can be accepted!

### Now we can test for homogeneity! ###
# Are the variances and covariances equal?
eqvars <- cfa(Model, Data, group = "agegroup",
              group.equal = c("loadings","intercepts","residuals",
                              "residual.covariances",
                              "lv.variances","lv.covariances"),
              group.partial = "Q10 ~ 1")


# Compare:
anova(strict, eqvars)  # Acceptable

# What about the means?
eqvars_and_means <- cfa(Model, Data, group = "agegroup",
              group.equal = c("loadings","intercepts","residuals",
                              "residual.covariances",
                              "lv.variances","lv.covariances",
                              "means"),
              group.partial = "Q10 ~ 1")

# Compare:
anova(strict, eqvars, eqvars_and_means)  # Rejected!

# Let's look at the means:
parameterEstimates(eqvars)[82:84, ] # I looked before and saw rows 82-84 are the ones of interest

# Interestingly, People >= 30 seem to like the prequels more and the sequels less than people < 30!