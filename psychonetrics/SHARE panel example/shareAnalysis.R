# Install psychonetrics:

# Step 1: download the binary file from Dropbox (.zip file for Windows or .tgz file for Mac)
# Note: do *not* unpack these! That is, don't unpack the zip file or open it

# Step 2: Run the following code:
# install.packages(file.choose(), type = "binary", repos = NULL)

# Step 3: You get a popup window, select the .zip or .tgz file

# If you get an error saying you miss certain packages/dependencies that are installed. install these and try again

# The package should now be installed and loadable with library("...")

# Alternatively, the package can be compiled from source:
# library("devtools")
# install_github("sachaepskamp/psychonetrics")

# Load psychonetrics:
library("psychonetrics")

# Also load dplyr:
library("dplyr")

# And qgraph:
library("qgraph")

# Load SHARE summary statistics This is a relatively small (n = 2911) subset of 
# http://www.share-project.org/home0.html containing only participants with no missings 
# on a selected set of variables. 
load("SHARE_summary_statistics.RData")
# Gives objects covMat and means

# This dataset contains the following variables:
# bmi: BMI
# casp: Quality of life
# eurod: # Depression symptoms
# hc002_mod: # Doctor visists
# maxgrip: Maximum grip strength measure
# sphus: Perceived health

# Form the design matrix:
design <- matrix(colnames(covMat),6)
# This design matrix encodes the design. Rows indicate variables and columns indicate 
# measurements. An NA can indicate a variable missing at a certain measurement.

# Form panel-gvar model:
Model <- panelgvar(covs = covMat, means = means, nobs = 2911, vars = design)

# if we had raw data, we could have instead used:
# Model <- panelgvar(Data, nobs = 2911, vars = design, estimator = "FIML")

# Run model:
Model <- Model %>% runmodel

# Prune model:
Model_pruned <- Model %>% prune(adjust = "fdr", recursive = FALSE, alpha = 0.05)

# Stepup search to optimize BIC:
Model_pruned_stepup <- Model_pruned %>% stepup(criterion = "bic")

# Compare all models:
compare(
  full = Model,
  pruned = Model_pruned,
  pruned_stepup = Model_pruned_stepup # <- best AIC and BIC
)

# Print some results:
Model_pruned_stepup

# Inspect fit:
Model_pruned_stepup %>% fit # SEM fit indices

# Inspect parameters:
Model_pruned_stepup %>% parameters

# Extract networks:
temporal <- Model_pruned_stepup %>% getmatrix("PDC")
contemporaneous <- Model_pruned_stepup %>% getmatrix("omega_zeta_within")
betweensubjects <- Model_pruned_stepup %>% getmatrix("omega_zeta_between")

# bmi: BMI
# casp: Quality of life
# eurod: # Depression symptoms
# hc002_mod: # Doctor visists
# maxgrip: Maximum grip strength measure
# sphus: Perceived health

# Labels:
Labels <- c("BMI","Quality\nof Life","Depression","Doctor Visits","Grip Strength", "Perceived\nHealth")

# Plot and save to PDF file:
pdf("SHAREresults.pdf",width = 12, height = 4)
layout(t(1:3))
qgraph(temporal, layout = "circle", labels = Labels, theme = "colorblind",
       asize = 7, vsize = 28, label.cex = 1.1, mar = c(8,8,8,8), title = "Temporal", 
       label.scale = FALSE)
box("figure")

qgraph(contemporaneous, layout = "circle", labels = Labels, theme = "colorblind",
      vsize =  28, label.cex = 1.1, mar = c(8,8,8,8), 
      title = "Contemporaneous", label.scale = FALSE)
box("figure")

qgraph(betweensubjects, layout = "circle", labels = Labels, theme = "colorblind",
       vsize = 28, label.cex = 1.1, mar = c(8,8,8,8), title = "Between-subjects", label.scale = FALSE)
box("figure")

# Close pdf device and finalise image:
dev.off()
