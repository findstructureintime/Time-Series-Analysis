function [unix_start_time,frequency,time,data] = E4_parse_physio( filename )

%   single input of file name, will create the vectors of E4 data to be plotted 

%first row of E4 data is unix time stamp of first datapoint
unix_start_time = csvread(filename, 0,0,[0 0 0 0]);

%second row is frequency of measurement (Hz)
frequency = csvread(filename,1,0,[1 0 1 0]);

%rest of file is average heart rate (BPM) or EDA data at the frequency of measurement
data = csvread(filename);
%remove the first two elements (does not require knowing how many data
%points are in the csv
data(1) = [];
data(1) = [];
% convert from column to vector
data = data';

%create a vector of timepoints that indicate unix time of each physio
%datapoint

% e4 and many other sensors dont actually store time information only
% sensor data itself so it is necessary to manually add it in

time = (unix_start_time:1/frequency:(length(data)-1)/frequency + unix_start_time);


end

