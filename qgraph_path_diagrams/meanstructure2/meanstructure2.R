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
size <- 1.2*c(15,12,10,12,10,12,10,12)
shape <- c("circle","rectangle","circle","rectangle","circle","rectangle","circle","triangle")
borders = TRUE
Layout <- matrix(c(
  0.1,0,
  1,0,
  1.5,0,
  1,1,
  1.5,1,
  1,2,
  1.5,2,
  -0.25,2
),,2,byrow=TRUE)
Layout <- Layout[,2:1]
Layout[,2] <- -Layout[,2]
eCol <- "black"
# labels <- list(expression(eta[1]),expression(y[1]),expression(epsilon[1]),expression(y[2]),expression(epsilon[2]),
#                expression(y[3]),expression(epsilon[3]),expression("1"))
# eLabs <- list("1","",expression(theta[11]),expression(psi[11]),expression(lambda[21]),"",expression(theta[22]),
#               expression(lambda[31]),"",expression(theta[33]),expression(alpha[1]), expression(tau[1]), expression(tau[2]), expression(tau[3]))
loopRot <- c(1.5*pi,NA,0.5*pi,NA,0.5*pi,NA,0.5*pi, NA) + pi/2
labels <- list(expression(eta[1]),expression(y[1]),expression(epsilon[1]),expression(y[2]),expression(epsilon[2]),
               expression(y[3]),expression(epsilon[3]),expression("1"))

lty <- rep(1,nrow(E))
lty[11] <- 2

pdf("meanstructure2.pdf",width=8,height=4.5)
layout(t(1:2))
eLabs <- list("1","",expression(theta[111]),expression(psi[111]),expression(lambda[211]),"",expression(theta[221]),
              expression(lambda[311]),"",expression(theta[331]),expression("0"), expression(tau[11]), expression(tau[21]), expression(tau[31]))

qgraph(E,edgelist = TRUE,lty=lty,
       vsize = size,  shape = shape ,
       borders = borders, layout = Layout,
       edge.color = eCol, asize = 8, labels = labels, 
       label.scale.equal = FALSE, bidirectional = TRUE,
       mar = c(6,5,5,5), esize = 4, label.cex = 1,
       edge.labels = eLabs, edge.label.cex = 2,
       bg = "transparent", edge.label.bg = "white",
       loopRotation = loopRot, title = "Group 1")
box("figure")

eLabs <- list("1","",expression(theta[112]),expression(psi[112]),expression(lambda[212]),"",expression(theta[222]),
              expression(lambda[312]),"",expression(theta[332]),expression("0"), expression(tau[12]), expression(tau[22]), expression(tau[32]))

qgraph(E,edgelist = TRUE,lty=lty,
       vsize = size,  shape = shape ,
       borders = borders, layout = Layout,
       edge.color = eCol, asize = 8, labels = labels, 
       label.scale.equal = FALSE, bidirectional = TRUE,
       mar = c(6,5,5,5), esize = 4, label.cex = 1,
       edge.labels = eLabs, edge.label.cex = 2,
       bg = "transparent", edge.label.bg = "white",
       loopRotation = loopRot, title = "Group 2")
box("figure")
dev.off()