%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a script for converting between event and stream (time series) data
% by txu@indiana.edu, June 22, 2017
 % It was modified to take as input files output files from the annotationImport code 
 %created for the ICIS 2018 workshop by kaya de barbaro
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%note this will NOT work on raw /unprocessed event data directly exported
%from common annotation software

clearvars;

%edit these parameters: 
%directory where your event sequence file lives 
dataDir ='C:\Users\kdeba\Dropbox\Libraries\Documents\presentations\2018 ICIS\workshop\final materials\Kaya materials\data\';
%directory where your timeseries data to be saved (happens to be same directory on my computer)
saveDir='C:\Users\kdeba\Dropbox\Libraries\Documents\presentations\2018 ICIS\workshop\final materials\Kaya materials\data\';
dataCol = 4; % indicate the column that has the data you want to convert - in the case of sample data, infant affect data is in col 4
dataLabel = 'Infant Affect';
eventOnsetCol = 1; % indicate the column that has event onsets 
eventOffsetCol =2;% indicate the column that has event offsets 

% set sample_rate, very important
%   sample_rate: the interval between two consecutive time stamps of converted
%           stream data.
sample_rate = .1; %.1 corr to 10fps  % 0.034 corresponds to 29.97fps (common in US)


%loop through all participants
for pID = [ 3011 ] % [ 3011 3029 3292 3466 3569] % etc
    %% convert events to streams
    %file name and location
    fname_csv_events=strcat(dataDir,'MoInfAffectArray_', num2str(pID), '.csv');
    data_events = csv2data(fname_csv_events);
    
    data_events= data_events( ~(isnan(data_events(:, dataCol))), [ eventOnsetCol eventOffsetCol dataCol ]);
        
    % do the conversion using the default parameter settings from Linger's original event2stream function 
    data_stream = event2stream(data_events, sample_rate);
    
    %save the data
    csvwrite(strcat(saveDir, dataLabel, '_Timeseries_', num2str(pID), '.csv'),data_stream);

end



