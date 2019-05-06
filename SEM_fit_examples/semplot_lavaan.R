library("lavaan")
library("semPlot")

# Using model 2 from lavaan_rawdata.R:

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

# Some possible semPlot examples:
semPaths(fit2,"mod","est", edge.color = "black", style = "lisrel", residScale = 8) # Nice already, another three based options is:
semPaths(fit2,"mod","est", layout = "tree2", edge.color = "black", 
         style = "lisrel", residScale = 8)

# Also nice is the layoutSplit option for complicated models:
semPaths(fit2,"mod","est", layoutSplit = TRUE, 	subScale = 0.3,
         rotation = 2, edge.color = "black", style = "lisrel", 
         residScale = 8)

# Some pretty colors:
semPaths(fit2,"col","est", layout = "tree2", 
         style = "lisrel", residScale = 8,
         groups = "latents", 
         pastel = TRUE, 
         borders = FALSE)
