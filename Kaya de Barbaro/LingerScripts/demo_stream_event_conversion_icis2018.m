%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a demo script for converting between event and stream (time series) data
% by txu@indiana.edu, June 22, 2017
 % modified to work with annotationImport code by kaya de barbaro
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars;


saveDir='C:\Users\kdeba\Dropbox\Libraries\Documents\presentations\2018 ICIS\workshop\';
dataRow = 4; % indicate the row that has the data you want to convert 

%% convert events to streams
csv_events = 'C:\Users\kdeba\Dropbox\Libraries\Documents\presentations\2018 ICIS\workshop\MoInfAffectArray_3011.csv';
data_events = csv2data(csv_events);

data_events= data_events( ~(isnan(data_events(:, dataRow))), [ 1 2 dataRow ]);

% set sample_rate, very important
%   sample_rate: the interval between two consecutive time stamps of converted
%           stream data.
sample_rate = .1; %.1 corr to 10fps  % 0.034 corresponds to 29.97fps

% use default parameter settings
data_stream = event2stream(data_events, sample_rate);

csvwrite(strcat(saveDir,'3011_InfAffect.csv'),data_stream);


% exercise 
% edit this so that it converts both mom and infant's affect data and could be modified to convert 
% mulitple participants data at once 


