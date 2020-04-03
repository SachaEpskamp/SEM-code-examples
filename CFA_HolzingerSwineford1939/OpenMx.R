# Load the package:
library("lavaan")
library("OpenMx")

# Load data:
data("HolzingerSwineford1939")
Data <- HolzingerSwineford1939[,c("x1","x2","x3","x4","x5","x6","x7","x8","x9")]

### PATH SPECIFICATION ###

# Data:
dataCov      <- mxData(observed=cov(Data), type="cov", numObs = nrow(Data))

# residual variances
resVars      <- mxPath( from=c("x1","x2","x3","x4","x5","x6","x7","x8","x9"), arrows=2,
                        free=TRUE, values=rep(1,9),
                        labels=c("e1","e2","e3","e4","e5","e6","e7","e8","e9") ) 
# latent variance
latVar       <- mxPath( from=c("visual","textual","speed"), arrows=2,
                        free=TRUE, values=1, labels = c("var_visual", "var_textual", "var_speed"))

# Latent covariances:
latCov       <- mxPath( from=c("visual","visual","textual"), 
                        to = c("textual","speed","speed"),
                        arrows=2,
                        free=TRUE, values=1, labels = c("cov_visual_textual", "cov_visual_speed", "cov)textual_speed"))


# factor loadings	
facLoads     <- mxPath( from=c("visual","visual","visual","textual","textual","textual","speed","speed","speed"), 
                        to=c("x1","x2","x3","x4","x5","x6","x7","x8","x9"), arrows=1,
                        free=c(FALSE,TRUE,TRUE,FALSE,TRUE,TRUE,FALSE,TRUE,TRUE),
                        values=rep(1,9),
                        labels =c("l1","l2","l3","l4","l5","l6","l7","l8","l9") )

# Create the model:
oneFactorModel <- mxModel("HolzingerSwineford1939", type="RAM",
                          manifestVars=c("x1","x2","x3","x4","x5","x6","x7","x8","x9"), 
                          latentVars=c("visual","textual","speed"),
                          dataCov, resVars, latVar, latCov, facLoads)

# Run the model:
oneFactorFit <- mxRun(oneFactorModel)      

# Inspect:
summary(oneFactorFit)
coef(oneFactorFit)


### MATRIX SPECIFICATION ###

# Data:
dataCov      <- mxData(observed=cov(Data), type="cov", numObs = nrow(Data))

# Lambda:
Lambda <- mxMatrix(type="Full", nrow=9, ncol = 3,
                   free = c(
                     FALSE, FALSE, FALSE,
                     TRUE, FALSE, FALSE,
                     TRUE, FALSE, FALSE,
                     FALSE, FALSE, FALSE,
                     FALSE, TRUE, FALSE,
                     FALSE, TRUE, FALSE,
                     FALSE, FALSE, FALSE,
                     FALSE, FALSE, TRUE,
                     FALSE, FALSE, TRUE
                   ),
                   values = c(
                     1, 0, 0,
                     1, 0, 0,
                     1, 0, 0,
                     0, 1, 0,
                     0, 1, 0,
                     0, 1, 0,
                     0, 0, 1,
                     0, 0, 1,
                     0, 0, 1
                   ), byrow = TRUE, name = "Lambda",
                   dimnames = list(c("x1","x2","x3","x4","x5","x6","x7","x8","x9"), c("visual","textual","speed")))

# Psi:
Psi <- mxMatrix(type="Symm", nrow=3,ncol=3,free=TRUE, name = "Psi",
                dimnames = list(c("visual","textual","speed"),c("visual","textual","speed")))

# Theta:
Theta <- mxMatrix(type = "Diag", free = TRUE, nrow = 9, ncol = 9, values = 1, name = "Theta",
                  dimnames = list(c("x1","x2","x3","x4","x5","x6","x7","x8","x9"),c("x1","x2","x3","x4","x5","x6","x7","x8","x9")))

# Expectation (model for sigma)
Sigma <- mxAlgebra(Lambda %*% Psi %*% t(Lambda) + Theta, name = "Sigma", 
                   dimnames = list(c("x1","x2","x3","x4","x5","x6","x7","x8","x9"),c("x1","x2","x3","x4","x5","x6","x7","x8","x9")))
expFunction <- mxExpectationNormal(covariance = "Sigma")

# Estimator:
funML  <- mxFitFunctionML()

oneFactorModel <- mxModel("HolzingerSwineford1939",
                          manifestVars=c("x1","x2","x3","x4","x5","x6","x7","x8","x9"), 
                          latentVars=c("visual","textual","speed"),
                          dataCov, Lambda, Psi, Theta, funML, Sigma, expFunction)

# Run the model:
oneFactorFit <- mxRun(oneFactorModel)      

# Inspect:
summary(oneFactorFit)
coef(oneFactorFit)

