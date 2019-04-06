# Load packages:
library("dplyr") # I always load this
library("semPlot")

# For info on OpenMx, see:
# https://openmx.ssri.psu.edu/
# Install with:
# 
library("OpenMx")

# This code show an example of matrix specification in OpenMx, which is a clear benefit of OpenMx.
# You can also use path specification (see website above), but that generally does not work as nice 
# as lavaan in my oppinion.

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

# Observed variables:
obsvars <- paste0("Q",1:10)

# Latents:
latents <- c("Prequels","Original","Sequels")

# Set the data (summary statistics, raw data is also possible):
# Max likelihood cov mat:
n <- nrow(Data)
covMat <- (n-1)/n * cov(Data[,obsvars])
dataRaw <- mxData(observed=covMat, type="cov", numObs = nrow(Data))

# Lambda matrix:
Lambda <- matrix(0, 10, 3)
Lambda[1:4,1] <- 1
Lambda[c(1,5:7),2] <- 1
Lambda[c(1,8:10),3] <- 1
mxLambda <- mxMatrix("Full", 
                     nrow = 10, 
                     ncol = 3, 
                     free = Lambda!=0, 
                     values = Lambda,
                     name = "lambda",
                     dimnames = list(obsvars, latents)
)

# Psi matrix:
diag <- diag(3)
mxPsi <- mxMatrix("Symm", 
                  nrow = 3, 
                  ncol = 3,
                  values = diag,
                  free = diag != 1,
                  name = "psi",
                  dimnames = list(latents, latents)
)

# Theta matrix:
mxTheta <- mxMatrix("Diag", 
                    nrow = 10, 
                    ncol = 10,
                    name = "theta",
                    free = TRUE,
                    dimnames = list(obsvars, obsvars),
                    lbound = 0 # Lower bound
)

# Implied variance--covariance matrix:
mxSigma <- mxAlgebra(lambda %*% psi %*% t(lambda) + theta, name = "sigma")

# Expectation (this tells OpenMx that sigma is the expected cov matrix):
exp   <- mxExpectationNormal( covariance="sigma",dimnames=obsvars)

# Fit function (max likelihood)
funML  <- mxFitFunctionML()

# Combine everything in a big model:
model <- mxModel("Star Wars",
                 dataRaw,
                 mxLambda,
                 mxPsi,
                 mxTheta,
                 mxSigma,
                 exp,
                 funML)

# Run model:
model <- mxRun(model)

# Look at model summary:
summary(model)

# chi-square:  χ² ( df=30 ) = 34.56062,  p = 0.2589784
# very similar to lavaan and psychonetrics