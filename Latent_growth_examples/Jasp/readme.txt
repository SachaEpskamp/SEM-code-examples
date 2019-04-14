Jasp supports estimating models from covariance matrices but not yet from means. Because 
of this, the code simulate_data.R simulates a dataset with the same covariance and mean 
structure. If you have the raw data (typically you do!) you do not need to do this!

When fitting a latent growth curve model in Jasp, there are some options that are 
important:

1. Set in options:
[x] Include mean strructure

2. Set in advanced:
[x] Fix manufest intercepts to zero
[ ] Fix latent intercepts to zero

Next, you can use the same models as in lavaan. For the univariate latent growth model:

i_alc =~ 1*alc1 + 1*alc2 + 1*alc3 + 1*alc4
s_alc =~ 1*alc1 + 2*alc2 + 3*alc3 + 4*alc4

and for the bivariate latent growth model:

# Alcohol:
i_alc =~ 1*alc1 + 1*alc2 + 1*alc3 + 1*alc4
s_alc =~ 1*alc1 + 2*alc2 + 3*alc3 + 4*alc4

# Cigarettes:
i_cig =~ 1*cig1 + 1*cig2 + 1*cig3 + 1*cig4
s_cig =~ 1*cig1 + 2*cig2 + 3*cig3 + 4*cig4