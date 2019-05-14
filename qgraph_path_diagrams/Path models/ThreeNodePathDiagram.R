library("qgraph")
E <- matrix(c(
  1,2,
  2,3,
  2,2,
  3,3
),,2,byrow=TRUE)

L <- matrix(c(
  0,1,
  1,1,
  2,1
),,2,byrow=TRUE)

labels <- list("A1","A2","E1")
elabs <- list(
  "-",
  "-",
  expression(epsilon[1]),
  expression(epsilon[2])
)
shape <- c("square","square","square")

bidir <- rep(FALSE,5)
bidir[3] <- TRUE
residEdge <- rep(FALSE,5)
residEdge[3] <- TRUE

qgraph(E, edgelist = TRUE, layout = L,
       labels = labels, edge.color = "black",
       asize = 8, shape = shape,vsize = 18,
       mar = c(1,4,5,4), esize = 5, border.width = 2,
       edge.labels = elabs, edge.label.cex = 3,
       residuals = TRUE,
       loopRotation = 0, residScale = 20,
       height = 3, width = 7, filetype = "pdf",
       filename = "ThreeNodePathDiagram")