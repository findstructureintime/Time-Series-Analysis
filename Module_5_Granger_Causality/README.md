# Module 5: Discovering directional influence among multimodal behavioral variables with Granger Causality

With this code module, users can perform Granger Causality computation among a set of point process time series variables. The demo script, *demo_granger_causality.m*, provides guidance through the process step by step with a demo example. The sub-folder, *lib/*, contains all the supporting functions involved in the calculation of GC and significance test. 

Start MATLAB or Octave and set the current working directory to the folder where the provided material is located. For example, if the material is located in this directory, ‘C:\Downloads\Time-Series-Analysis\Module_4_Granger_Causality’, you can type this command line in MATLAB/Octave console to set the current working directory:
```matlab
cd C:\Downloads\Time-Series-Analysis\Module_4_Granger_Causality
```

If you are using Octave, please download *statistics* package from [here](https://octave.sourceforge.io/statistics/index.html) and *image* package from [here](https://octave.sourceforge.io/image/). After open Octave, please install and load the packages by typing the commands below: 
```
pkg install statistics-1.4.1.tar.gz
pkg load statistics
pkg install image-2.12.0.tar.gz
pkg load image
```

In *demo_granger_causality.m*, the script goes through five main steps.

1. Clean the current workspace and load all supporting functions for Granger Causality (GC) computation:
```matlab
clearvars;
addpath('lib');
```

2. Load the samle example dataset:
```matlab
sample_data_name = 'gcause_sample_data2.mat';
load(sample_data_name);
```
There are two sample dataset files, the user can try out both files. Each sample file contains two variables: 

**data_matrix** contains the behavioral time series. This is a *N by M by K* matrix in which *N* is the number of  time series variables, *M* is the length of the trial and *K* is the number of trials.

**variable_list** contains the *N* variable names in **data_matrix** from top to last row. In our example, we titled our variables with the source behavioral module: infant eye, parent eye, infant hand, parent hand and parent speech. For in-depth explanation of the sample dataset, please see the Scripts & Sample Data section and the Results section in our paper [link](https://psyarxiv.com/mpz9g/);

3. Visualize the sample time series:
```matlab
vis_args.title = 'Sample_time_series_visualization';
vis_args.annotation = variable_list; 
visualize_point_process(data_matrix, vis_args);
```

With these three lines of codes, the script will generate a plot to visualize the raw time series. The first line of codes specifies the plot title. The second line of codes sets the text annotation next to the visualized times series as our behavioral module list. The last line of codes calls the supporting function *visualize_point_process()* to generate the plot.

4. Specify the length of the history window that will be used for prediction model fitting in GC computation and call the core function *calculate_granger_causality()* to calcuate GC among all five time series in the input *data_matrix*:
```matlab
model_history_range = 9;
[results_gcause_mat, results_gcause_fdr] = calculate_granger_causality(data_matrix, model_history_range);
```

In the calculation, the function *calculate_granger_causality()* will first generate a set of likelihood estimation models for each time series contained in *data_matrix* iterating through history window durations from 1 to *model_history_range*. Then, the best estimation model will be chosen from this set of candidate models using Akaike’s information criterion (AIC) (Akaike, 1974; Burnham & Anderson, 1998). In our sample case, we set the history window as 9 which is equivalent to 3 seconds since the sampling rate is 3HZ in the sample dataset.

Then, the directional GC influence from one variable *X* to another *Y* is assessed by calculating the relative reduction in the likelihood of producing the particular history of time series of *Y* when the history of *X* is excluded, compared with the likelihood when all the available covariates are used in the prediction. The results are returned in the output *results_gcause_mat* which is a *N by N* matrix. In the result matrix, value at row *i* column *j* is the GC influence from jth variable to ith variable in the input *data_matrix*. 

The second return value *results_gcause_fdr* contains the significance test result for every directional GC influence. Similarly, value at row *i* column *j* is the test result for the GC influence from jth variable to ith variable in the input *data_matrix*. The significance test can result in three outputs: 1/-1/0. 1 means that it is a significantly positive GC influence; -1 means that it is a significantly positive GC influence; 0 means not significant.

5. Display the GC results and organize the results in a table format with the matching GC type:
```matlab
[result_gcause_table, gcause_type_list] = prettyprint_gcause_result(results_gcause_mat, results_gcause_fdr, variable_list);
```

Lastly, the script calls a function to display and organize the results in an easily interpretable format.

This code module is written by [Dr. Tian Linger Xu](https://lingerxu.github.io/), if you have any question please contact *txu at iu.edu*.