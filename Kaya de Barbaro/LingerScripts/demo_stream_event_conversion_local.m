%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a demo script for converting between stream (time series) data
% type and event data type.
% by txu@indiana.edu, June 22, 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars;

%% convert events to streams
%csv_events = 'C:\Users\kdeba\Dropbox\Libraries\Documents\UT Austin\projects\visualization scripts\LingerScripts\cevent_eye_roi_child.csv';
csv_events = 'C:\Users\kdeba\Dropbox\Libraries\Documents\presentations\2018 ICIS\workshop\MoInfAffectArray_3011.csv';
data_events = csv2data(csv_events);

% set sample_rate, very important
%   sample_rate: the interval between two consecutive time stamps of converted
%           stream data.
sample_rate = 0.034; %corresponds to 30 frames per second

% use default parameter settings
data_stream = event2stream(data_events, sample_rate);

% specify all parameters
default_value = 0;
start_time = 30;
end_time = 750;
data_stream2 = event2stream(data_events, sample_rate, default_value, start_time, end_time);

%% convert streams to events
csv_stream = 'C:\Users\kdeba\Dropbox\Libraries\Documents\UT Austin\projects\visualization scripts\LingerScripts\cstream_eye_roi_child.csv';
data_stream = csv2data(csv_stream);

% use default parameter settings
data_events = stream2event(data_stream, sample_rate);

% specify whether to include segments with 0 as category value
include_zero = false;
data_events2 = stream2event(data_stream, sample_rate, include_zero);