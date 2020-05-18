%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script converts time series data into event format temporal data. 
% 
% written by Linger Xu, txu@indiana.edu and Kaya de Barbaro, kaya@austin.utexas.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%note: this will NOT work on raw unprocessed event data directly exported
%from common annotation software- you need to run annotationImport.m first
%and then run this script

clearvars;
addpath('libs')

%edit these parameters: 
%directory where your event sequence file lives 

dataLabel = 'InfantAffect';
timeCol = 1; % indicate the column that has the time stamps
dataCol = 2; % indicate the column that has infant affect codes

% set sample_rate, very important
%   sample_rate: the interval between two consecutive time stamps of converted
%           stream data.
sample_rate = .1; %.1 corr to 10fps  % 0.034 corresponds to 29.97fps (common in US)


%loop through all participants
for pID = [3414  3367 3532] % [ 3011 3029 3292 3466 3569] % etc
    %% convert events to streams
    %file name and location
    dataDir = fullfile('.', 'data');
    fname_csv_events = fullfile(dataDir, [dataLabel '_Timeseries_', num2str(pID), '.csv']);
    data_timeseries = csvread(fname_csv_events);
    
    data_timeseries = data_timeseries(~(isnan(data_timeseries(:, dataCol))), [timeCol dataCol]);
        
    % do the conversion using the default parameter settings from Linger's original event2stream function 
    data_events = timeseries2event(data_timeseries, sample_rate);
    
    %save the data
    csvwrite(fullfile(dataDir, [dataLabel, '_Events_', num2str(pID), '.csv']), data_events);
end


