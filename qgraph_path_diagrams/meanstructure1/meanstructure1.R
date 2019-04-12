library("qgraph")
# images <- c("sun2.png", "thermometer.png", NA)
E <- matrix(c(
  1,2,
  3,2,
  3,3,
  1,1,
  1,4,
  5,4,
  5,5,
  1,6,
  7,6,
  7,7,
  8,1, # Mean
  8,2, # Intercepts
  8,4,
  8,6
),,2,byrow=TRUE)
# aspect <- c(sapply(img, function(x) nrow(x)/ncol(x)),1)
size <- 1.2*c(20,12,10,12,10,12,10,12)
shape <- c("circle","rectangle","circle","rectangle","circle","rectangle","circle","triangle")
borders = TRUE
Layout <- matrix(c(
  0,0,
  1,0,
  1.5,0,
  1,1,
  1.5,1,
  1,2,
  1.5,2,
  -0.25,2
),,2,byrow=TRUE)
eCol <- "black"
labels <- list(expression(eta[1]),expression(y[1]),expression(epsilon[1]),expression(y[2]),expression(epsilon[2]),
               expression(y[3]),expression(epsilon[3]),expression("1"))
eLabs <- list("1","",expression(theta[11]),expression(psi[11]),expression(lambda[21]),"",expression(theta[22]),
              expression(lambda[31]),"",expression(theta[33]),expression("0"), expression(tau[1]), expression(tau[2]), expression(tau[3]))
loopRot <- c(1.5*pi,NA,0.5*pi,NA,0.5*pi,NA,0.5*pi, NA)
lty <- rep(1,nrow(E))
lty[11] <- 2
qgraph(E,edgelist = TRUE,
       vsize = size,  shape = shape ,
       borders = borders, layout = Layout,
       edge.color = eCol, asize = 8, labels = labels, 
       label.scale.equal = FALSE, bidirectional = TRUE,
       mar = c(6,5,5,5), esize = 4, label.cex = 1,
       edge.labels = eLabs, edge.label.cex = 2,
       bg = "transparent", edge.label.bg = "white",
       loopRotation = loopRot, lty = lty,
       filetype = "pdf", filename = "meanstructure1",
       width = 8, height = 5)