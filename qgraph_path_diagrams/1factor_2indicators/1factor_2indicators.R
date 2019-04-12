library("qgraph")
library("png")
# images <- c("sun2.png", "thermometer.png", NA)
E <- matrix(c(
  1,2,
  3,2,
  3,3,
  1,1,
  1,4,
  5,4,
  5,5
),,2,byrow=TRUE)
# aspect <- c(sapply(img, function(x) nrow(x)/ncol(x)),1)
size <- 1.2*c(20,13,10,13,10)
shape <- c("circle","rectangle","circle","rectangle","circle")
borders = TRUE
Layout <- matrix(c(
  0,1,
  1,0,
  1.5,0,
  1,2,
  1.5,2
),,2,byrow=TRUE)
eCol <- "black"
labels <- list(expression(eta[1]),expression(y[1]),expression(epsilon[1]),expression(y[2]),expression(epsilon[2]))
eLabs <- list("1","",expression(theta[11]),expression(psi[11]),expression(lambda[21]),"",expression(theta[22]))
loopRot <- c(1.5*pi,NA,0.5*pi,NA,0.5*pi)
qgraph(E,edgelist = TRUE,
       vsize = size,  shape = shape ,
       borders = borders, layout = Layout,
       edge.color = eCol, asize = 8, labels = labels, 
       label.scale.equal = FALSE, bidirectional = TRUE,
       mar = c(8,12,8,5), esize = 6, label.cex = 1.25,
       edge.labels = eLabs, edge.label.cex = 2,
       bg = "transparent", edge.label.bg = "white",
       loopRotation = loopRot,
       filetype = "pdf", filename = "1fac2ind",
       width = 8, height = 3)