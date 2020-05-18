function [events, sample_rate] = timeseries2event(timeseries, sample_rate, include_zero)
% timeseries2event   Convert time series data to event format data
% 
% events = timeseries2event(timeseries, sample_rate, include_zero)
%
% timeseries - (input)category timeseries. list of pair [timestamp categorynumber]
%               e.g.
%               344.7000   32.0000
%               344.8000   34.0000
%               344.9000   34.0000
%               345.0000   34.0000
%               345.1000   34.0000
%               345.2000   34.0000
%               345.3000   34.0000
%               345.4000   32.0000
%               345.5000   32.0000
%               345.6000   32.0000
% include_zero: a flag determing whether 0 segments should be treated as events
% or not. include_zero == 0 means not including 0 events, which is the
% default.
%
% events: (output)category event data. list of [start_time end_time categorynumber]
%		344.7000   344.8000  32.0000
%		344.8000   345.4000  34.0000
%		345.4000   345.7000  32.0000
%  
%  Last modified by txu@indiana.edu, Jun. 19, 2014

MAX_SAMPLE_RATE = 0.1001;

num = size(timeseries,1);
events = zeros(num,3);

if (isempty(timeseries))
    return
end

if ~exist('sample_rate', 'var')
    warning('Sample_rate is a neccesary input for this function');
%     chunk_len = size(timeseries, 1);
    sr_list = timeseries(2:end,1) - timeseries(1:end-1,1);
    sample_rate = mode(sr_list);
    if sample_rate > MAX_SAMPLE_RATE
        error(['Our estimate sample rate is larger than 0.1, which is ' ...
            'the largerest sample rate in multisensory project, please enter sample rate manually']);
    end
end

if ~exist('include_zero', 'var')
    include_zero = 0;
end

max_gap = sample_rate * 1.5;

gap = 0;
events(1,1) = timeseries(1,1);   % start timestamp
events(1,3) = timeseries(1,2);   % value
% end_time = events(1,1) + gap; % temporal end timestamp
idx = 1;
for i = 2:num
    gap = timeseries(i,1) - timeseries(i-1,1);
    if gap > max_gap || timeseries(i,2) ~= timeseries(i-1,2)
        idx = idx + 1;
        events(idx-1,2) = timeseries(i-1,1) + sample_rate;
        events(idx,1) = timeseries(i,1);
        events(idx,3) = timeseries(i,2);
    end
end
events(idx,2) = max(events(idx,1) + gap, timeseries(end, 1) + gap);
events = events(1:idx,:);

if (include_zero == 0) % not including 0 events
    nonzeros = events(:, 3) ~= 0;
    events = events(nonzeros, :);
end


