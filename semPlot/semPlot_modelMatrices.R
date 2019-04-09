# Load packages:
library("semPlot")

# Factor loadings matrix:
Lambda <- matrix(0, 10, 3)
Lambda[1:4,1] <- 1
Lambda[c(1,5:7),2] <- 1
Lambda[c(1,8:10),3] <- 1 # Could also contain estimates

# Dummy Psi:
Psi <- matrix(1,3,3)

# Theta matrix:
Theta <- diag(10)
Theta[4,10] <- Theta[10,4] <- 1

# LISREL Model: LY = Lambda (lambda-y), TE = Theta (theta-epsilon), PS = Psi
mod <- lisrelModel(LY =  Lambda, PS = Psi, TE = Theta)

# Plot with semPlot:
semPaths(mod, "mod", "name", as.expression=c("nodes","edges"))


# We can make this nicer (set whatLabels = "none" to hide labels):
semPaths(mod,
    what = "col", # this argument controls what the color of edges represent. In this case, standardized parameters
    whatLabels = "name", # This argument controls what the edge labels represent. In this case, parameter estimates
    as.expression = c("nodes","edges"), # This argument draws the node and edge labels as mathematical exprssions
    style = "lisrel", # This will plot residuals as arrows, closer to what we use in class
    residScale = 10, # This makes the residuals larger
    theme = "colorblind", # qgraph colorblind friendly theme
    layout = "tree2", # tree layout options are "tree", "tree2", and "tree3"
    cardinal = "lat cov", # This makes the latent covariances connet at a cardinal center point
    curvePivot = TRUE, # Changes curve into rounded straight lines
    sizeMan = 4, # Size of manifest variables
    sizeLat = 10, # Size of latent varibales
    edge.label.cex = 1,
    mar = c(9,1,8,1), # Sets the margins
    reorder = FALSE, # Prevents re-ordering of ovbserved variables
    filetype = "pdf", # Store to PDF
    filename = "semPlotExample1", # Set the name of the file
    width = 8, # Width of the plot
    height = 5, # Height of plot
    groups = "latents", # Colors according to latents,
    pastel = TRUE, # Pastel colors
    borders = FALSE # Disable borders
    )

