# Module 3: Cross-recurrence quantification analysis of dyadic interaction

With these five MATLAB scripts you can perform cross-recurrence quantification analysis (CRQA) on categorical data. 

Start MATLAB and select the folder where the provided material (M-functions and data file) is located. That is, make MATLAB’s current folder equal to the folder to which you downloaded this (e.g. ‘C:\...\My Documents’). After this you can call these functions on the command line.

1. First run the following code: 
```
load(‘example_data.mat’)
```

Either copy-paste to an empty MATLAB script file and then run it, or copy-paste the lines in each individual assignment to the command line followed by ‘enter’.

You have just loaded two time series, PP1 and PP2, into the Workspace. These time series consist of nominal data having integer values from 0 to 5. The time series come from a dyadic interaction study, collaborative behaviors of two children was coded from video at 1 Hz by using the same six specific behavioral categories for each.

2. Plot these time series to see what they look like. Run:
```
plotTS(PP1, PP2);
```

3. Next step is to create the cross-recurrence matrix, *rec*, by running the following:
```
rec = CatCRMatrix(PP1,PP2);
```

Have a look at the M-function *CatCRMatrix* and try to understand what it does. Also, have a look at the recurrence matrix rec consisting of 1650 × 1650 points. The analysis distinguishes between two types of matches (i.e. recurrences), which represent different combinations of behaviors of the interaction partners. Each combination corresponds to a different value (-1 or +1) in the recurrence matrix *rec*. All other combinations are considered to be non-matching (i.e. non-recurrent) and obtained the value 0.

As explained in Module 3 of the paper, for categorical data the phase-space reconstruction (like you did in the previous exercise with continuous data) is not necessary. You can directly build-up the cross-recurrence matrix by comparing the values in the two time series. In the cross-recurrence plot (CRP) a colored dot (i.e. recurrent point) is plotted whenever these values match in a pre-specified way. This first creates the main diagonal (Line-of-Synchrony) of the CRP, containing the equal-time behavioral matches. But by shifting the time series with respect to each other in both directions, lines parallel to the Line-of-Synchrony on both sides are created. Each of these lines reflects the behavioral matches with a specific (increasing) delay between the occurrence of those behaviors in the two time series.⋅⋅

4. Now let’s plot the CRP to study its structure, by running this:
```
PlotCRP(rec)
```

This is a typical checkerboard pattern you would expect for categorical CRQA. There are three colors in this CRP representing the three different types of states of the dyadic system, based on the numerical values in ‘rec’: red for the value -1, blue for the value +1, and white for the non-matching (i.e. non-recurrent) states with value 0. All together, the CRP nicely displays the rich coordinative structure of the dyadic interaction across all possible timescales. The color-coded recurrence analysis performed here is called **Chromatic CRQA**.

5. Finally, calculate some recurrence measures to quantify this structure. For now we will ignore the different types of behavioral matches (colors) and treat all recurrences as equal. Run the following function:
```
output = CRQA_out(rec);
```

This function performs **Anisotropic CRQA** by quantifying both the vertical and horizontal line structures. It produces the following measures:

*LAM* = Proportion of recurrent points on vertical/horizontal lines (Laminarity)

*TT* = Average vertical/horizontal line length (Trapping Time)

*MaxL* = Length of the longest vertical/horizontal line

*ENT_L* = Shannon entropy of vertical/horizontal line length distribution

You can have a look at the results by opening the file output from the Workspace. In the file you will find two rows. The upper row gives the values for the vertical line structures, the lower row those for the horizontal line structures.

By calculating both the vertical and horizontal line measures and comparing them, Anisotropic CRQA enables you to study asymmetries in the dynamics. Differences between these measures reflect differences in relative strength and dominance between the interaction partners. 

For more information see:
Cox, R.F.A., Van der Steen, S., De Jonge-Hoekstra, L., Guevara, M., & Van Dijk, M. (2016). Chromatic and anisotropic cross-recurrence quantification analysis of interpersonal behaviour. In C. Webber, C. Ioana, & N. Marwan (Eds). Recurrence Plots and Their Quantifications: Expanding Horizons (pp. 209-225). Springer Proceedings in Physics. ([link](https://www.researchgate.net/publication/299511690_Chromatic_and_Anisotropic_Cross-Recurrence_Quantification_Analysis_of_Interpersonal_Behavior))