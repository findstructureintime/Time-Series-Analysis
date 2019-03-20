function result = stream2event(stream, sample_rate, include_zero)
% cstream2cevent   Convert stream data to cevent data
% 
% cevent = cstream2cevent(stream, include_zero)
%
% stream - (input)category stream. list of pair [timestamp categorynumber]
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
% cevent: (output)category event. list of [start_time end_time categorynumber]
%		344.7000   344.8000  32.0000
%		344.8000   345.4000  34.0000
%		345.4000   345.7000  32.0000
%
%  This function is copied from Ikhyun's function
%  make_cevent_from_cstream.   Feb 19,2009
%  
%  Last modified by txu@indiana.edu, June 22, 2017

if isempty(stream)
    warning('Input events is empty. Return empty stream.');
    result = zeros(0, 3);
    return;
end

if size(stream, 2) ~= 2
    error('Input stream must be in this type of data structure: [timestamp category]');
end

if nargin < 2
    error(['Users need to specify the sampling rate of the time series by ' ...
        'setting SAMPLE_RATE: the interval between two consecutive time ' ...
        'stamps of converted stream data.'])
end

len_stream = size(stream, 1);
result = nan(len_stream, 3);

if isempty(stream)
    warning('The input data stream is empty. Exit funciton.');
    return
end

if ~exist('include_zero', 'var')
    include_zero = false;
end

MULTIPLIER = 1.2;

gap = 0;
result(1, 1) = stream(1, 1);   % start timestamp
result(1, 3) = stream(1, 2);   % value
% end_time = result(1,1) + gap; % temporal end timestamp
idx = 1;
for i = 2:len_stream
    gap = stream(i,1) - stream(i-1,1);
    if gap > (sample_rate*MULTIPLIER) || stream(i,2) ~= stream(i-1,2)
        idx = idx + 1;
        result(idx-1,2) = stream(i-1,1) + sample_rate;
        result(idx,1) = stream(i,1);
        result(idx,3) = stream(i,2);
    end
end
result(idx,2) = max(result(idx,1) + gap, stream(end, 1) + gap);
result = result(1:idx,:);

if include_zero == 0 % not including 0 events
    nonzeros = result(:, 3) ~= 0;
    result = result(nonzeros, :);
end

% exclude NaN data
result = result(~isnan(result(:, 3)), :);

