function binaryspikes = event2binaryspike(events, convert_category, sample_rate, start_time, end_time)
% event2pointprocess   Convert event data to binary spike trains with
%   categorical value 1 or 0 as event stimulus present or not.
%
% Warning:
% Note that this is a lossy conversion: if there are overlapping events in
% the events, then only one of them will come through in the point process.
%
% binaryspikes = event2binaryspike(events, convert_category, sample_rate, start_time, end_time)
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
%   binaryspikes:      the converted point process data

if isempty(events)
    warning('Input events is empty. Return empty point process.');
    binaryspikes = zeros(0, 2);
    return;
end

if size(events, 2) ~= 3
    error('Input events must be in this type of data structure: [onset offset category]');
end

if nargin < 3
    error('Please specify the event category and sample rate.');
end

if nargin < 4
    start_time = events(1, 1);
end

if nargin < 5
    end_time = events(end, 2);
end

mask_events = events(:,end) == convert_category;
events = events(mask_events, :);
events(:,2) = events(:,1) + sample_rate/2;
events(:,3) = 1;
default_value = 0;

events_count = size(events, 1);

binaryspikes = event2timeseries(events, sample_rate, default_value, start_time, end_time);

if events_count ~= sum(binaryspikes(:, 2))
    error('Error! Point process should only have the onsets of events!')
end

end
