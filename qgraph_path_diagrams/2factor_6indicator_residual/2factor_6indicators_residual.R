library("qgraph")

# images <- c("sun2.png", "thermometer.png", NA)
# Two factors (1-2), three indicators each:
E <- matrix(c(
  1,3, # Loading
  1,4, # Loading
  1,5, # Loading
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
  11,12,
  12,11
),,2,byrow=TRUE)



# aspect <- c(sapply(img, function(x) nrow(x)/ncol(x)),1)
size <- 1*c(rep(13,2),rep(10,6),rep(8,6))
shape <- c(rep("circle",2),rep("square",6),rep("circle",6))
borders = TRUE
Layout <- matrix(c(
  2,2,
  5,2,
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
  6,0.5
),,2,byrow=TRUE)
eCol <- "black"
labels <- list(expression(eta[1]),
               expression(eta[2]),
               expression(y[1]),
               expression(y[2]),
               expression(y[3]),
               expression(y[4]),
               expression(y[5]),
               expression(y[6]),
               expression(epsilon[1]),
               expression(epsilon[2]),
               expression(epsilon[3]),
               expression(epsilon[4]),
               expression(epsilon[5]),
               expression(epsilon[6])
)
eLabs <- list(
  "1",
  expression(lambda[21]),
  expression(lambda[31]),
  "1",
  expression(lambda[52]),
  expression(lambda[62]),
  "","","","","","",
  expression(psi[11]),
  expression(psi[22]),
  expression(psi[21]),
  expression(theta[11]),
  expression(theta[22]),
  expression(theta[33]),
  expression(theta[44]),
  expression(theta[55]),
  expression(theta[66]),
  expression(psi[21]),
  expression(theta[43]),
  expression(theta[43])
)
curve <- rep(0,24)
curve[15] <- 2
curve[23:24] <- -3
loopRot <- c(rep(0,2),rep(pi,2*6))
qgraph(E,edgelist = TRUE,
       vsize = size,  shape = shape ,
       borders = borders, layout = Layout,
       edge.color = eCol, asize = 4, labels = labels, 
       label.scale.equal = FALSE, bidirectional = TRUE,
       mar = c(6,5,9,5), esize = 4, label.cex = 1.25,
       edge.labels = eLabs, edge.label.cex = 1.3,
       bg = "transparent", edge.label.bg = "white",
       loopRotation = loopRot, curve = curve, curveAll=TRUE,
       filetype = "pdf", filename = "2fac6ind_resid",
       width = 8, height = 5)