function timeseries = event2timeseries(events, sample_rate, default_value, start_time, end_time)
% event2timeseries   Convert event data to time series format data
%
% Warning:
% Note that this is a lossy conversion: if there are overlapping events in
% the events, then only one of them will come through in the timeseries.
%
% timeseries = event2timeseries(events, sample_rate, default_value, start_time, end_time)
% 
% INPUT
%   events:  input events data
%   sample_rate: the interval between two consecutive time stamps of converted
%           time series data.
%   default_value:  the default_value value for converted time series data
%   start_time: the timestamp when the converted timeseries starts.
%   end_time: (optional) the timestamp when the converted time series ends.
% 
% OUTPUT
%   timeseries:      the converted time series data

if isempty(events)
    warning('Input events is empty. Return empty time series.');
    timeseries = zeros(0, 2);
    return;
end

if size(events, 2) ~= 3
    error('Input events must be in this type of data structure: [onset offset category]');
end

if nargin < 2
    error('Please specify sample rate.');
end

if nargin < 3
    default_value = 0;
end

if nargin < 4 
    start_time = events(1, 1);
end

if nargin < 5
    end_time = events(end, 2);
end

time_base = start_time:sample_rate:end_time;

% change to account for empty events
if size(events,1) == 0
    event_count = 0;
    start = 0;
    stop = 0;
else
    event_count = 1;
    start = events(1,1);
    stop = events(1,2);
end

total = length(time_base);
timeseries = zeros(total,2);
timeseries(:,1) = time_base;
timeseries(:,2) = default_value;
total_event = size(events, 1);

% For each time
for i = 1:total
    time = time_base(i);
    
    % if this time is past the stop of the events, search for a new events.
    while(time >= stop && event_count < total_event)
        event_count = event_count + 1;
        start = events(event_count ,1);
        stop = events(event_count ,2);
    end

    % Check if before events
    if(time < start)
        timeseries(i,2) = 0;
    elseif (time < stop) % not before.  During?
        timeseries(i,2) = events(event_count, 3);
    else % Not before or during.  After.
        % This should only happen when we've run out of events.
        assert(event_count == total_event);
        % The rest of the variable should be zeros, which it already is.
        % We're done!
        break
    end
end

end
