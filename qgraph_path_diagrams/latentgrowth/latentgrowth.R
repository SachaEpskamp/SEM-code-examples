library("qgraph")

# images <- c("sun2.png", "thermometer.png", NA)
# Two factors (1-2), three indicators each:
E <- matrix(c(
  1,3, # Loading
  1,4, # Loading
  1,5, # Loading
  1,6,
  1,7,
  1,8,
  2,3,
  2,4,
  2,5,
  2,6, # Loading
  2,7, # Loading
  2,8, # Loading
  
  9,3,
  10,4,
  11,5,
  12,6,
  13,7,
  14,8,
  1,1,
  2,2,
  1,2,
  9,9,
  10,10,
  11,11,
  12,12,
  13,13,
  14,14,
  2,1,
  15,1,
  15,2
),,2,byrow=TRUE)


# aspect <- c(sapply(img, function(x) nrow(x)/ncol(x)),1)
size <- 1*c(rep(13,2),rep(10,6),rep(8,6),10)
shape <- c(rep("circle",2),rep("square",6),rep("circle",6),"triangle")
borders = TRUE
Layout <- matrix(c(
  1,2,
  6,2,
  1,1,
  2,1,
  3,1,
  4,1,
  5,1,
  6,1,
  1,0.5,
  2,0.5,
  3,0.5,
  4,0.5,
  5,0.5,
  6,0.5,
  3.5,2
),,2,byrow=TRUE)
eCol <- "black"
labels <- list(expression("Intercept"),
               expression("Slope"),
               expression(y[t == 1]),
               expression(y[t == 2]),
               expression(y[t == 3]),
               expression(y[t == 4]),
               expression(y[t == 5]),
               expression(y[t == 6]),
               expression(epsilon[1]),
               expression(epsilon[2]),
               expression(epsilon[3]),
               expression(epsilon[4]),
               expression(epsilon[5]),
               expression(epsilon[6]),
               expression("1")
)
curve <- rep(0,nrow(E))
curve[21] <- 1.2
loopRot <- c(rep(0,2),rep(pi,2*6))


# lty <- c(rep(1,nrow(E)), rep(2,nrow(E2)))
# esize <- c(rep(4,nrow(E)), rep(1,nrow(E2)))

eLabs <- list(
  "1","1","1","1","1","1",
  "1", expression(lambda[2,1]),
  expression(lambda[3,1]), expression(lambda[4,1]),
  expression(lambda[5,1]), expression(lambda[6,1]),
  "","","","","","",
  expression(psi[1,1]),
  expression(psi[2,2]),
  expression(psi[2,1]),
  expression(theta[1,1]),
  expression(theta[2,2]),
  expression(theta[3,3]),
  expression(theta[4,4]),
  expression(theta[5,5]),
  expression(theta[6,6]),
  expression(psi[2,1]),
  expression(alpha[1]),
  expression(alpha[2])
)

# ECP <- matrix(NA,nrow(E),2)
# ECP[1:12,2] <- 0
edgelabpos <- rep(0.5,nrow(E))
edgelabpos[1:12] <- 0.3
qgraph(E,edgelist = TRUE, edge.labels = eLabs,
       vsize = size,  shape = shape ,# edgeConnectPoints = ECP,
       borders = borders, layout = Layout, edge.label.position = edgelabpos,
       edge.color = eCol, asize = 5, labels = labels, 
       label.scale.equal = FALSE, bidirectional = TRUE,
       mar = c(5,2,7,2), esize = 2, label.cex = 1.25,
       edge.label.cex = 1.5,# lty = lty,
       bg = "transparent", edge.label.bg = "white",
       loopRotation = loopRot, curve = curve, curveAll=TRUE,
       filetype = "pdf", filename = "latentgrowth",
       width = 8, height = 6)