# Load packages:
library("dplyr") # I always load this
library("semPlot")

# Location of output file:
outFile <- "StarWars_mPlus.out"

# Plot with semPlot:
semPaths(outFile, "std", "est", intercepts = FALSE)

# We can make this nicer. First let's define the node labels:
nodeNames <- c(
  "I am a huge Star Wars\nfan! (star what?)",
  "I would trust this person\nwith my democracy.",
  "I enjoyed the story of\nAnakin's early life.",
  "The special effects in\nthis scene are awful (Battle of Geonosis).",
  "I would trust this person\nwith my life.",
  "I found Darth Vader's big\nreveal in 'Empire' one of the greatest\nmoments in movie history.",
  "The special effects in\nthis scene are amazing (Death Star\nExplosion).",
  "If possible, I would\ndefinitely buy this\ndroid.",
  "The story in the Star\nWars sequels is an improvement to\nthe previous movies.",
  "The special effects in\nthis scene are marvellous (Starkiller\nBase Firing).",
  "Prequel trilogy",
  "Original trilogy",
  "Sequel trilogy"
)

# Now we can plot:
semPaths(outFile,
         what = "std", # this argument controls what the color of edges represent. In this case, standardized parameters
         whatLabels = "est", # This argument controls what the edge labels represent. In this case, parameter estimates
         style = "lisrel", # This will plot residuals as arrows, closer to what we use in class
         residScale = 8, # This makes the residuals larger
         theme = "colorblind", # qgraph colorblind friendly theme
         nCharNodes = 0, # Setting this to 0 disables abbreviation of nodes
         manifests = paste0("Q",1:10), # Names of manifests, to order them appropriatly.
         reorder = FALSE, # This disables the default reordering
         nodeNames = nodeNames, # Add a legend with node names
         legend.cex = 0.25, # Makes the legend smaller
         rotation = 2, # Rotates the plot
         layout = "tree2", # tree layout options are "tree", "tree2", and "tree3"
         cardinal = "lat cov", # This makes the latent covariances connet at a cardinal center point
         curvePivot = TRUE, # Changes curve into rounded straight lines
         sizeMan = 4, # Size of manifest variables
         sizeLat = 10, # Size of latent varibales
         intercepts = FALSE # Disables intercepts
)

# Some other things we can do with semPlot is do some algebra:
semMatrixAlgebra(outFile, Lambda) # Obtain factor loadings
semMatrixAlgebra(outFile, Psi) # Obtain latent variance-covariance matrix
semMatrixAlgebra(outFile, Theta) # Obtain residual variance-covariance matrix
semMatrixAlgebra(outFile, Lambda %*% Psi %*% t(Lambda) + Theta) # Obtain Sigma

# And we can generate lavaan syntax:
semSyntax(outFile)
