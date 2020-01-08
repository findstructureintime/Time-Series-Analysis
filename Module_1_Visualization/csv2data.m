function data = csv2data(csv_filename)
% This function reads data from a csv file and converts the data into time
% stream.

if ~exist(csv_filename, 'file')
    error('Cannot locate file %s.\n', csv_filename);
end

data = csvread(csv_filename);