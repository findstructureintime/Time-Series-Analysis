function pointprocess = event2pointprocess(events, convert_category, sample_rate, start_time, end_time)
% event2pointprocess   Convert event data to point process format data with
%   categorical value 1 or 0 as event present or not.
%
% Warning:
% Note that this is a lossy conversion: if there are overlapping events in
% the events, then only one of them will come through in the point process.
%
% pointprocess = event2pointprocess(events, convert_category, sample_rate, default_value, start_time, end_time)
% 
% INPUT
%   events:  input events data
%   convert_category: selected category that will be converted into point
%       process; Event input data can have multiple categories, only the
%       events with this selected category will be converted.
%   sample_rate: the interval between two consecutive time stamps of converted
%           point process data.
%   default_value:  the default_value value for converted point process data
%   start_time: the timestamp when the converted point process starts.
%   end_time: (optional) the timestamp when the converted point process ends.
% 
% OUTPUT
%   pointprocess:      the converted point process data

if isempty(events)
    warning('Input events is empty. Return empty point process.');
    pointprocess = zeros(0, 2);
    return;
end

if size(events, 2) ~= 3
    error('Input events must be in this type of data structure: [onset offset category]');
end

if nargin < 3
    error('Please specify the event category and sample rate.');
end

default_value = 0;

if nargin < 4
    start_time = events(1, 1);
end

if nargin < 5
    end_time = events(end, 2);
end

mask_events = events(:,end) == convert_category;
events = events(mask_events, :);

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
pointprocess = zeros(total,2);
pointprocess(:,1) = time_base;
pointprocess(:,2) = default_value;
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
        pointprocess(i,2) = 0;
    elseif (time < stop) % not before.  During?
        pointprocess(i,2) = events(event_count, 3);
    else % Not before or during.  After.
        % This should only happen when we've run out of events.
        assert(event_count == total_event);
        % The rest of the variable should be zeros, which it already is.
        % We're done!
        break
    end
end

end
