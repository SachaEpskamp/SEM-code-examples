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
  2,1
),,2,byrow=TRUE)
E2 <- matrix(c(
  1,6,
  1,7,
  1,8,
  2,3,
  2,4,
  2,5
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
curve <- rep(0,nrow(E) + nrow(E2))
curve[15] <- 2
loopRot <- c(rep(0,2),rep(pi,2*6))

Efull <- rbind(E,E2)
lty <- c(rep(1,nrow(E)), rep(2,nrow(E2)))
esize <- c(rep(4,nrow(E)), rep(1,nrow(E2)))

qgraph(Efull,edgelist = TRUE,
       vsize = size,  shape = shape ,
       borders = borders, layout = Layout,
       edge.color = eCol, asize = 5, labels = labels, 
       label.scale.equal = FALSE, bidirectional = TRUE,
       mar = c(6,5,9,5), esize = esize, label.cex = 1.25,
       edge.label.cex = 1.5, lty = lty,
       bg = "transparent", edge.label.bg = "white",
       loopRotation = loopRot, curve = curve, curveAll=TRUE,
       filetype = "pdf", filename = "2fac6ind_allcross",
       width = 8, height = 5)