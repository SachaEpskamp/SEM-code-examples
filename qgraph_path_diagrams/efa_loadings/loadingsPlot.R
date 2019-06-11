# Needed libraries:
library("semPlot")
library("qgraph")
library("GA")

# Unstandardized factor loadings:
lambda <- structure(c(0, 0.347309557389605, 0, 0, 0.291403542576795, 0, 
                      0.27467525445669, 0, 0, 0, 0, 0, 0, -0.135747404769135, 0, 0, 
                      0.220977530548909, 0, 0, 0.177371401901561, 0, 0, 0, 0.602166263050583, 
                      0.360068645572603, 0, 0, 0, 0.602797696702521, 0, 0, 0, 0, 0, 
                      0, 0.442838991127218, 0.540960096837521, 0, 0, 0, 0, -0.230286259625514, 
                      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.468494433270527, 0.166956348004494, 
                      0.119204135288922, 0, 0, 0.187579836080558, 0.16924386870456, 
                      0, 0.173066446586688, 0, 0, 0, 0, 0, 0, 0, 0), .Dim = c(14L, 5L))

# Residual variances:
theta <- diag(c(0.486348735347288, 0.163964724976415, 0.050523237006943, 0.00939202259935427, 
                0.178308156862288, 0.0696469267486953, 0.167008251796478, 0.242443317918602, 
                0.137411018927023, 0.127953455640805, 0.11052415282475, 0.086872942979836, 
                0.267132369318934, 0.451194076239714))

# Latent variance-covariance:
psi <- structure(c(2.63859380152006, -0.793345350197633, -1.497683288397, 
                   -1.00124376108535, -0.669807660275558, -0.793345350197633, 1.23853495157823, 
                   0.450308066453413, 0.30104371571473, 0.201390904693342, -1.497683288397, 
                   0.450308066453413, 1.85009493733043, 0.568312579119007, 0.380187256809703, 
                   -1.00124376108535, 0.30104371571473, 0.568312579119007, 1.3799330797089, 
                   0.254165965444068, -0.669807660275558, 0.201390904693342, 0.380187256809703, 
                   0.254165965444068, 1.1700308329025), .Dim = c(5L, 5L))

# Use semPlot to standardize:
library("semPlot")
semPlot_mod <- lisrelModel(LY = lambda, TE = theta, PS = psi)
modMats <- modelMatrices(semPlot_mod, "Mplus")
lambdastd <- modMats$Lambda[[1]]$std

# Number of latents:
nLat <- ncol(lambdastd)

# Number of observed:
nObs <- nrow(lambdastd)

# Edgelist for graph:
Edgelist <- cbind(
  c(col(lambdastd)),c(row(lambdastd))+ncol(lambdastd),c(lambdastd)
)

# shape:
shape <- c(rep("ellipse",nLat),rep("rectangle",nObs))

# Size1:
size1 <-  c(rep(13,nLat),rep(25,nObs))
            
# Size2:
size2 <-  c(rep(13,nLat),rep(4,nObs))

# Edge connect points:
ECP <- Edgelist
ECP[,1] <- 0.5*pi
ECP[,2] <- 1.5*pi

# Labels:
latLabels <- paste0("F",1:5)

# Manifest labels:
manLabels <- c("irritated", "satisfied", "lonely", "anxious", 
               "enthusiastic", "guilty", "strong", "restless", "agitated", 
               "worry", "ashamed", "tired", "headache", "sleepy"
)

# Size of labels:
labelCex <- c(
  rep(2,nLat),
  rep(1,nObs)
)

# Starting layout:
Layout <- rbind(
  cbind(
    0,
    seq(-1,1,length=nLat+2)[-c(1,nLat+2)]
  ),
  cbind(
    1,
    seq(-1,1,length=nObs+2)[-c(1,nObs+2)]
  )
)

# Use genetic algorithm (GA) to find best placement:
# fit function:
fit <- function(x){
  # Order layout:
  Layout2 <- Layout[x,]
  
  # Penalty for if the latents are placed wrong:
  penalty <- 1 + sum(!x[1:nLat] %in% (1:nLat))

  # Which edges are not zero?
  noZero <- Edgelist[,3]!=0

  # Return fit:
  -penalty * sum(sqrt((Layout2[Edgelist[noZero,2],2] - Layout2[Edgelist[noZero,1],2])^2))
}

# Run GA:
res <- ga(type = "permutation", fitness = fit, lower = 1, upper = nrow(Layout), parallel = FALSE,
          popSize = 1000, maxiter = 1000, seed = 1)

# Extract best order:
order <- c(res@solution[1,])

# Final layout:
LayoutFinal <- Layout[order,]

# Plot and save to PDF:
qgraph(Edgelist,
       shape = shape,
       vsize = size1,
       vsize2 = size2,
       layout = LayoutFinal,
       mar = c(1,3,1,5),
       edgeConnectPoints = ECP,
       labels = c(latLabels, manLabels),
       label.scale = FALSE,
       label.cex = labelCex,
       asize = 5,
       theme = "colorblind",
       filetype = "pdf",
       filename = "loadings",
       width = 6,
       height = 8)
