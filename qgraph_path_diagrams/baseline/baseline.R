library("qgraph")
library("png")

shape <- c(rep("circle",2),rep("square",6),rep("circle",6))
borders = TRUE
eCol <- "black"
lty <- 1
esize <- 4

labels <- list(
  expression(y[1]),
  expression(y[2]),
  expression(y[3]),
  expression(y[4]),
  expression(y[5]),
  expression(y[6])
)

qgraph(diag(1,6),
       vsize = 14,  shape = "square" , directed = TRUE,
       borders = borders, layout = "circle",
       edge.color = eCol, asize = 8, labels = labels,
       label.scale.equal = FALSE, bidirectional = TRUE,
       mar = 1.4*c(6,6,6,6), esize = esize, label.cex = 1.25,
       edge.label.cex = 1.5, lty = lty,
       bg = "transparent", edge.label.bg = "white",
       curveAll=TRUE, diag = TRUE, title = "Baseline model",
       filetype = "pdf", filename = "baseline",
       width = 8, height = 5)