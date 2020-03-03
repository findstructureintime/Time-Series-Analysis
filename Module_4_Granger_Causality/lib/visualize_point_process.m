function visualize_point_process(data_matrix, vis_args)
% This function visualizes the point process time series in data_matrix.
% 
% @param data_matrix -- input data that contains the time series for
%           visualization. It is a N*M*K matrix in which N is the number 
%           of time series, M is the length of the trial and K is the number of trials.
% 
% @param vis_args -- users can set different fields of this input
%           parameter to add elements on the visualization plot. 
%        vis_args.title -- setting the title of the plot;
%        vis_args.annotation -- the annotation along side the visualized 
%           time series, such as the variable name;
%        vis_args.colormap -- the colors of the visualized time series;
%        vis_args.save_name -- the file name if the user wants to save the
%           plot.
% 
% @author Tian Linger Xu txu@iu.edu
% Last update: Feb, 29, 2020

if nargin < 2
    vis_args = struct();
end

plot_data = [];

[num_streams, data_length, num_trials] = size(data_matrix);

for tidx = 1:num_trials
    data_one = data_matrix(:, :, tidx);
    data_pp = point_process2interval(data_one', 1, false);
    
    for ppidx = 1:length(data_pp)
        pp_one = data_pp{ppidx};
        pp_one(:, end) = tidx;
        data_pp{ppidx} = pp_one;
    end
    plot_data = [plot_data; data_pp];
end

if ~isfield(vis_args, 'color_code')
    vis_args.color_code = 'category';
end

if ~isfield(vis_args, 'colormap')
    vis_args.colormap = get_colormap(num_streams);
end

visualize_time_series(plot_data, vis_args);