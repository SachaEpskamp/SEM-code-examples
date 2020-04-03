# Load the packages:
library("lavaan")
library("psychonetrics")
library("dplyr")

# Load data:
data("HolzingerSwineford1939")
Data <- HolzingerSwineford1939

# Model:
lambda <- simplestructure(
  c("visual",
    "visual",
    "visual",
    "textual",
    "textual",
    "textual",
    "speed",
    "speed",
    "speed"))

# Form psychonetrics model:
mod <- lvm(Data, lambda = lambda, vars = paste0("x",1:9), 
           latents = colnames(lambda))

# Run the model:
mod <- runmodel(mod)

# Inspect fit:
mod

# Parameters:
mod %>% parameters

# Fit measures:
mod %>% fit

# Modification indices:
mod %>% MIs

# Add a parameter:
mod2 <- mod %>% freepar("lambda", 9, 3) %>% runmodel

# Compare models:
compare(
  original = mod,
  adjusted = mod2
)
