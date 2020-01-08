function [ unix_start_time,time,data] = E4_parse_acc( filename )
%   single input of file name, will create the vectors of E4 data to be plotted for motion data (ACCelerometer) 

%first row is unix time of first datapoint
unix_start_time = csvread(filename, 0,0,[0 0 0 0]);

data_x = csvread(filename,1,0);
data_y = csvread(filename,1,1);
data_z = csvread(filename,1,2);

% take the root mean squared of X + Y + Z dimensions of motion
data = rms([ data_x ]'/32);


%create time vector, we know from the sensor itself that it collects acc data at 32 hz
% e4 and many other sensors dont actually store time information only
% sensor data itself so it is necessary to manually add it in
time = (unix_start_time: 1/32 :(length(data)-1)/32 + unix_start_time);


end

%864811 - acc - 32hz
%27017 - HR  - 1/second