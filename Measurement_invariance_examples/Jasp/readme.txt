These instructions use Jasp version 0.9.2

Step 1: Open StarWars.csv into Jasp, make all variables ordinal if needed

Step 2: Press the "+" right of the variable labels (not the gray + on the very top right)

Step 3a: Create a nominal variable called "agegroup"
Step 3b: Click "Create column"
Step 3c: Enter Q12 < 30 in the field and press compute column
Step 3d: Click the column and change labels

Step 4: Click the "+" in the top  and select SEM

Step 5: Click lavaan

Step 6: Enter the model:

Prequels =~ Q2 + Q3 + Q4 + Q1
Original =~ Q5 + Q6 + Q7 + Q1
Sequels =~ Q8 + Q9 + Q10 + Q1
Q4 ~~ Q10

Step 7: Under options, select:
	1. Grouping Variable: <your computed variable> (agegroup)
	2. "include mean structure"
	
Step 8: Click the model and press command - enter
	- If you get an error, make sure you made all variables scale, remove the model and try again
	
- You now estimated the configural invariance model!

Step 9: Go to Advanced, select model 2 under "Model name"

Step 10: Go to Options, select Loadings under "Equality Constrains"

- You now estimated the weak invariance model!

Unfortunately, Jasp does not currently allow for partial invariance settings. So if strong 
invariance is violated we cannot currently estimate a partial invariance model.

Repeat steps 9 - 10 for further invariance and homogeneity tests!