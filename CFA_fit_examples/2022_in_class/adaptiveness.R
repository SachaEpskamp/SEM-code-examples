library("dplyr")
library("lavaan")
library("semPlot")

# Read data:
data <- read.csv("adaptiveness.csv")

# Variables:

# v1: I adjust to unpredictable situations by taking appropriate action
# v2: I come up with alternative plans in a very short time as a way to cope with new situations
# v3: I alter my own opinion when it is appropriate to do so
# v4: When I encounter difficult situations, I feel like I am losing control
# v5: I get frustrated when plans change for reasons that cannot be helped (for example bad weather, car trouble, etc.)
# v6: I remain relaxed when encountering unexpected news or situations
# v7: I am flexible when dealing with others
# v8: I can get along with people from cultures that are different than mine

# Lavaan model:
mod <- "
adaptiveness =~ v1 + v2 + v3 + v4 + v5 + v6 + v7 + v8
"

# fit model:
fit <- cfa(mod, data, missing = "FIML")

# Assess fit:
print(fit)
fitMeasures(fit)

# So what does this model do?

# Extract implied and observed correlations:
observed_cors <- as.matrix(cov2cor(lavInspect(fit, "obs")$cov))
implied_cors <-  as.matrix(cov2cor(lavInspect(fit, "sigma")))

# Obtain strongest correlation (for making graphs comparable):
max <- max(abs(c(observed_cors[upper.tri(observed_cors)],implied_cors[upper.tri(implied_cors)])))

# Plot these:
library("qgraph")
layout(t(1:2))
qgraph(observed_cors, theme = "colorblind", title = "observed", maximum = max)
qgraph(implied_cors, theme = "colorblind", title = "implied", maximum = max)

# Can also be made with semPlot:
semCors(fit, theme = "colorblind", maximum = max, titles = TRUE)

# Check MIs:
modificationindices(fit) %>% arrange(-mi) %>% head(10)

# adjust:
mod2 <- "
adaptiveness =~ v1 + v2 + v3 + v4 + v5 + v6 + v7 + v8
v4 ~~ v5
"

# fit model:
fit2 <- cfa(mod2, data, missing = "FIML")

# Compare models:
anova(fit, fit2)

# Assess fit:
fitMeasures(fit2)

# Check MIs:
modificationindices(fit2) %>% arrange(-mi) %>% head(10)

# adjust:
mod3 <- "
adaptiveness =~ v1 + v2 + v3 + v4 + v5 + v6 + v7 + v8
v4 ~~ v5
v1 ~~ v2
"

# fit model:
fit3 <- cfa(mod3, data, missing = "FIML")

# Compare models:
anova(fit, fit2, fit3)

# Assess fit:
fitMeasures(fit3)

# Check MIs:
modificationindices(fit3) %>% arrange(-mi) %>% head(10)

# adjust:
mod4 <- "
adaptiveness =~ v1 + v2 + v3 + v4 + v5 + v6 + v7 + v8
v4 ~~ v5
v1 ~~ v2
v6 ~~ v8
"

# fit model:
fit4 <- cfa(mod4, data, missing = "FIML")

# Compare models:
anova(fit, fit2, fit3, fit4)

# Assess fit:
fitMeasures(fit4)

# Path diaram:
layout(1)
semPaths(fit4, intercepts = FALSE, nCharNodes = 0, sizeLat = 10, style = "lisrel")
