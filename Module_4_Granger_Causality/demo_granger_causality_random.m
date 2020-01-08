% This is a demo script for running granger causality with simulated
% discrete data for ICIS workshop: Finding Structure in Time
% 
% by Tian Linger Xu, txu@indiana.edu
% Last modified June 30, 2017

clearvars;
addpath('gcause_libs');

% This demo script will create two point process data streams.
% By default, ror each dataset, the total length of each trial will be 3000: 
%   3000 data points collected per trial;
% By default, there are 2 trials.
% 
% You can modify these two parameters by setting these two fields in args:
%   args.data_length = 6000;
%   args.num_trials = 2;

% This parameter determines how many instances of variable1 occurs 
frequency_base = 10;

% Generate simulated data based on the parameters
data_matrix = generate_simulated_dataset_random(frequency_base);

% Visualize the simulated data
vis_args.title = 'Simulated_random_data';
vis_args.annotation = {'variable1', 'variable2'};
vis_args.save_name = vis_args.title;

visualize_point_process(data_matrix, vis_args);

% Compute Granger causality between two variables
[gcausal_mat, gcausal_fdr] = calculate_granger_causality(data_matrix);

% Visualize the computed results
vis_args.save_name = sprintf('Gcause_demo_with_%s', vis_args.title);
visualize_directed_graph(gcausal_mat, gcausal_fdr, vis_args)
