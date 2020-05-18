%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script converts event data into point process data which is a
% specific type of time series data with only 1 or 0 as its categories.
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
eventOnsetCol = 1; % indicate the column that has event onsets 
eventOffsetCol = 2;% indicate the column that has event offsets 
dataCol = 3; % indicate the column that has infant affect codes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Because point process data has only binary catogories, only events with
% specified category will be converted into point process
eventCategory = 2; % indicate the category that will be converted into point processes

% set sample_rate, very important
%   sample_rate: the interval between two consecutive time stamps of converted
%           stream data.
sample_rate = .1; %.1 corr to 10fps  % 0.034 corresponds to 29.97fps (common in US)


%loop through all participants
for pID = [3414  3367 3532] % [ 3011 3029 3292 3466 3569] % etc
    %% convert events to streams
    %file name and location
    dataDir = fullfile('.', 'data');
    fname_csv_events = fullfile(dataDir, [dataLabel '_Events_', num2str(pID), '.csv']);
    data_events = csvread(fname_csv_events);
    
    data_events = data_events(~(isnan(data_events(:, dataCol))), [eventOnsetCol eventOffsetCol dataCol]);
        
    % do the conversion using the default parameter settings from Linger's original event2stream function 
    data_pointprocess = event2pointprocess(data_events, eventCategory, sample_rate);
    
    %save the data
    csvwrite(fullfile(dataDir, [dataLabel, '_PointProcess_', num2str(pID), '.csv']), data_stream);
end



