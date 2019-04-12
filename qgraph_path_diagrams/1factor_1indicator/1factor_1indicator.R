library("qgraph")


E <- matrix(c(
  1,2,
  3,2,
  3,3,
  1,1
),4,2,byrow=TRUE)
img <- lapply(images[1:2],readPNG)
# aspect <- c(sapply(img, function(x) nrow(x)/ncol(x)),1)
size <- 1.2*c(20,15,10)
shape <- c("circle","rectangle","circle")
borders = c(TRUE,TRUE,TRUE)
Layout <- matrix(c(
  0,1,
  1,1,
  1.5,1
),3,2,byrow=TRUE)
eCol <- c("black","black","black","black")
labels <- list(expression(eta[1]),expression(y[1]),expression(epsilon[1]))
eLabs <- list(expression(lambda[11]),"1",expression(theta[11]),expression(psi[11]))
qgraph(E,edgelist = TRUE,
       vsize = size,  shape = shape ,
       borders = borders, layout = Layout,
       edge.color = eCol, asize = 8, labels = labels, 
       label.scale.equal = FALSE, bidirectional = TRUE,
       mar = c(2,12,2,5), esize = 6, label.cex = 1.25,
       edge.labels = eLabs, edge.label.cex = 2,
       bg = "transparent", edge.label.bg = "white",
       filetype = "pdf", filename = "1fac1ind",
       width = 8, height = 3)