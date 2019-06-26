
### NOTE: This code is *not* executable without the data, which can be requested from
# http://www.share-project.org/home0.html. Here I select some variables on three of the 
# waves and remove all cases with at least one NA as well as cases with z-scores on any
# variable > 5 (mostly because BMI has severe outliers influencing the results). I do 
# this to obtain a reproducible example that uses the summary statistics only,
# saved in SHARE_summary_statistics.RData and available. Probably these analysis steps 
# would not be the most optimal for a genuine empirical study (many observations are 
# removed)

# Load packages:
library("dplyr")
library("tidyr")
library("reshape2")

# Load dataset:
load("easySHARE_rel6_1_1.rda")

# Select variables and waves 3-6:
SHARE_selected <- easySHARE_rel6_1_1 %>% 
  dplyr::select(mergeid,  # ID variable
                wave, # Wave variable
                sphus, # Perceived health
                casp, # Quality of life
                eurod, # Depression symptoms
                hc002_mod, # Doctor visists
                maxgrip, # Maximum grip strength measure
                bmi # BMI
                ) %>% 
  # Select waves 4 - 6:
  filter(wave >= 4)

# Input NAs:
SHARE_selected[SHARE_selected < 0] <- NA

# Rescore to more interpretable scale:
SHARE_selected <- SHARE_selected %>%
  mutate(sphus = 6-sphus)

# To long format:
SHARE_selected_long <- SHARE_selected %>% gather(variable,value,sphus:bmi) %>% 
  mutate(fullvar = paste0(wave,"_",variable))

# Standardize per variable:
SHARE_selected_long <- SHARE_selected_long %>% 
  group_by(variable) %>% 
  mutate(value = scale(value)) %>% 
  ungroup %>% 
  dplyr::select(fullvar,value,mergeid)

# Remove any with z > 5:
SHARE_selected_long <- SHARE_selected_long %>% 
  filter(abs(value) < 5)

# To wide format:
SHARE_selected_wide <-  SHARE_selected_long %>% 
  spread(fullvar,value) %>%
  select(-mergeid)

# Remove rows with any missing:
SHARE_selected_wide <- na.omit(SHARE_selected_wide)


# Write summary statistics:
n <- nrow(SHARE_selected_wide)
covMat <- (n-1)/n * cov(SHARE_selected_wide) # Note: Maximum likelihood estimate
means <- colMeans(SHARE_selected_wide)
save(covMat, means, file = "SHARE_summary_statistics.RData")
