Onyx supports estimating models from summary statistics (covariance matrix), but it is
not trivial. Because of this, the code simulate_data.R simulates a dataset with the same
covariance and mean structure. If you have the raw data (typically you do!) you do not
need to do this!

Steps:

1. Open Onyx
2. Drag simulatedData.csv to Onyx
3. Drag LGC_Onyx_unvariate.xml to Onyx. I created this model using:
	1. right-click
	2. Create new model
	3. Create new LGCM
	4. Edit labels and values if needed
4. Right click the data in Onyx, and select:
	1. Send data to model -> 
	2. Univariate latent growth
5. The model is now estimating, check results with:
	1. right click
	2. Show estimate summary
6. For the bivariate LGCM, repeat 3 - 5 for the file LGC_Onyx_bivariate.xml