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

# CFA Model:
Model <- '
Prequels =~ Q1 + Q2 + Q3 + Q4
Original =~ Q1 + Q5 + Q6 + Q7
Sequels =~ Q1 + Q8 + Q9 + Q10
'

# Fit in lavaan:
fit <- cfa(Model, Data, std.lv=TRUE) # Automatically sets first factor loading to 1. Use std.lv = TRUE for latent variable variance scaling!

# Look at fit:
fit

# Look at parameters:
parameterEstimates(fit)

# Extract implied and observed correlations:
observed_cors <- as.matrix(cov2cor(lavInspect(fit, "obs")$cov))
implied_cors <-  as.matrix(cov2cor(lavInspect(fit, "sigma")))

# Obtain strongest correlation (for making graphs comparable):
max <- max(abs(c(observed_cors[upper.tri(observed_cors)],implied_cors[upper.tri(implied_cors)])))

# Plot these:
library("qgraph")
layout(t(1:2))
qgraph(observed_cors, labels = obsvars, theme = "colorblind", title = "observed", maximum = max)
qgraph(implied_cors, labels = obsvars, theme = "colorblind", title = "implied", maximum = max)

# semPlot:
library("semPlot")

# We can make this nicer. First let's define the node labels:
nodeNames <- c(
  "I am a huge Star Wars\nfan! (star what?)",
  "I would trust this person with\nmy democracy (Jar-Jar Binks).",
  "I enjoyed the story of\nAnakin's early life.",
  "The special effects in\nthis scene are awful (Battle of Geonosis).",
  "I would trust this person\nwith my life (Han Solo).",
  "I found Darth Vader's big\nreveal in 'Empire' one of the greatest\nmoments in movie history.",
  "The special effects in\nthis scene are amazing (Death Star\nExplosion).",
  "If possible, I would definitely buy\nthis droid (BB-8).",
  "The story in the Star\nWars sequels is an improvement to\nthe previous movies.",
  "The special effects in\nthis scene are marvellous (Starkiller\nBase Firing).",
  "Prequel trilogy",
  "Original trilogy",
  "Sequel trilogy"
)

# Now we can plot:
semPaths(fit,
         what = "std", # this argument controls what the color of edges represent. In this case, standardized parameters
         whatLabels = "est", # This argument controls what the edge labels represent. In this case, parameter estimates
         style = "lisrel", # This will plot residuals as arrows, closer to what we use in class
         residScale = 8, # This makes the residuals larger
         theme = "colorblind", # qgraph colorblind friendly theme
         nCharNodes = 0, # Setting this to 0 disables abbreviation of nodes
         manifests = paste0("Q",1:10), # Names of manifests, to order them appropriatly.
         reorder = FALSE, # This disables the default reordering
         nodeNames = nodeNames, # Add a legend with node names
         legend.cex = 0.5, # Makes the legend smaller
         rotation = 2, # Rotates the plot
         layout = "tree2", # tree layout options are "tree", "tree2", and "tree3"
         cardinal = "lat cov", # This makes the latent covariances connet at a cardinal center point
         curvePivot = TRUE, # Changes curve into rounded straight lines
         sizeMan = 4, # Size of manifest variables
         sizeLat = 10, # Size of latent variables
         mar = c(2,5,2,5.5), # Figure margins
         filetype = "pdf", width = 8, height = 6, filename = "StarWars" #  Save to PDF
)