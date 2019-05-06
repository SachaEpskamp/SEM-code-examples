library("lavaan")

# In this example, I will use the default dataset used in the lavaan documentation at ?sem,
# the ``industrialization and Political Democracy Example '' by Bollen (1989), page 332:
# The data is available in lavaan as:
PoliticalDemocracy
# More information on the data is available in ?PoliticalDemocracy. 

# This script fits the model using the RAW data, see lavaan_sumstat.R for an example
# using summary statistics (covariance matrix)


# Model 1: standard SEM model without equality constraints and residual covariances:
model1 <- ' 
# latent variable definitions
ind60 =~ x1 + x2 + x3
dem60 =~ y1 + y2 + y3 + y4
dem65 =~ y5 + y6 + y7 + y8

# regressions
dem60 ~ ind60
dem65 ~ ind60 + dem60
'

# Fit in Lavaan:
fit1 <- sem(model1, data=PoliticalDemocracy)

# We can look at the fit in the same way we did before!
fitMeasures(fit1)

# Model 2: SEM model with added residual covariances (model 1 is nested in this model):
model2 <- ' 
# latent variable definitions
ind60 =~ x1 + x2 + x3
dem60 =~ y1 + y2 + y3 + y4
dem65 =~ y5 + y6 + y7 + y8

# regressions
dem60 ~ ind60
dem65 ~ ind60 + dem60

# residual correlations
y1 ~~ y5
y2 ~~ y4 + y6
y3 ~~ y7
y4 ~~ y8
y6 ~~ y8
'

# Fit in Lavaan:
fit2 <- sem(model2, data=PoliticalDemocracy)

# Compare fit:
anova(fit1,fit2) # Fit is better!

# Model 3: SEM model with added residual covariances AND equality constrains (nested in model 2):
model3 <- ' 
# latent variable definitions
ind60 =~ x1 + x2 + x3
dem60 =~ y1 + a*y2 + b*y3 + c*y4
dem65 =~ y5 + a*y6 + b*y7 + c*y8

# regressions
dem60 ~ ind60
dem65 ~ ind60 + dem60

# residual correlations
y1 ~~ y5
y2 ~~ y4 + y6
y3 ~~ y7
y4 ~~ y8
y6 ~~ y8
'

# Fit in Lavaan:
fit3 <- sem(model3, data=PoliticalDemocracy)

# Compare fit:
anova(fit2, fit3) # Fit is better!