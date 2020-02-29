function [result_gcause_table, gcause_type_list] = prettyprint_gcause_result(results_gcause_mat, results_gcause_fdr, variable_list)
% This function takes the output result matrix from function
% calculate_granger_causality, the matching variable name list and displays
% the result in an interpretable way.

num_vars = length(variable_list);

length_gcause_mat = size(results_gcause_mat, 1);
if num_vars ~= length_gcause_mat
    error('The number of rows in results_gcause_mat should match the length of variable_list.')
end
length_gcause_fdr = size(results_gcause_fdr, 1);
if num_vars ~= length_gcause_fdr
    error('The number of rows in results_gcause_fdr should match the length of variable_list.')
end

num_gcause = num_vars * (num_vars-1);
gcause_index_list = nan(num_vars, num_vars-1);
for vidx = 1:num_vars
    gcause_index_list(vidx, :) = setdiff(1:num_vars, vidx);
end

gcause_type_list = cell(1, num_gcause);
gcause_value_list = nan(1, num_gcause);
gcause_fdr_list = nan(1, num_gcause);

for vidx = 1:num_vars
    starti = (vidx-1) * (num_vars-1);
    for tmpi = 1:(num_vars-1)
        index_cause = gcause_index_list(vidx, tmpi);
        index_effect = vidx;
        
        gcause_type_list{1, starti+tmpi} = [variable_list{index_cause} '->' variable_list{index_effect}];
        gcause_value_list(1, starti+tmpi) = results_gcause_mat(index_effect, index_cause);
        gcause_fdr_list(1, starti+tmpi) = results_gcause_fdr(index_effect, index_cause);
    end
end

result_gcause_table = [gcause_value_list; gcause_fdr_list];

% display the significance test result
sig_str_list = {'significantly negative', 'not significant', 'significantly positive'};
disp('Display Granger Causality calculation results:')
disp('----------------------------------------')
for gidx = 1:num_gcause
    fprintf('G-CAUSE TYPE:\t%s\n', gcause_type_list{gidx});
    fprintf('G-CAUSE VALUE:\t%.4f\n', gcause_value_list(gidx));
    fprintf('SIGNIFICANCE:\t%d as %s\n\n', gcause_fdr_list(gidx), sig_str_list{gcause_fdr_list(gidx)+2});
end
disp('----------------------------------------')

