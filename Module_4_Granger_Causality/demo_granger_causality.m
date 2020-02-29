% This is a demo script for running granger causality with example data
% from an empirical infant-parent play study.

% STEP 1: clean the current workspace and load all supporting 
% functions for Granger Causality (GC) computation
clearvars;
addpath('lib');

% STEP 2: load the sample example dataset
sample_data_name = 'gcause_sample_data2.mat';
% This sample file loads two variables into the current workspace:
%   1. "data_matrix" contains the behavioral time series
%   2. "variable_list" contains the names of the variables from top to last row
load(sample_data_name);

% STEP 3: Visualize the sample time series
vis_args.title = 'Sample_time_series_visualization'; % set the title of the plot
vis_args.annotation = variable_list; % set the text annotation along side the visualized time series
visualize_point_process(data_matrix, vis_args);

% STEP 4: Compute Granger causality among all the variables in the input 
%   data_matrix. Variable data_matrix is a M*N*K matrix in which N is the 
%   number of collected time series, M is the length of the trial 
%   and K is the number of trials.
% 
%   In this example, we set the history window as 9 which is equivalent to 3
%   seconds since the sampling rate is 3HZ in the sample dataset. This is 
%   setting the length of the history window for prediction model fitting 
%   in GC computation. 
% 
% Please see README or use "help calculate_granger_causality" command for 
% detailed explanation about the input/output parameters for this function.
model_history_range = 9;
[results_gcause_mat, results_gcause_fdr] = calculate_granger_causality(data_matrix, model_history_range);

% STEP 4: Display the results and organize the results in a table format with
% the matching gcause type
[result_gcause_table, gcause_type_list] = prettyprint_gcause_result(results_gcause_mat, results_gcause_fdr, variable_list);
