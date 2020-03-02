% programming basics 
% kaya de barbaro june 2018

%this script provide basics for opening accessing and modifying numerical
%arrays in matlab. it has been designed to be run one line
% at a time so users can practice and learn. it also contains practice problems at the end of the script as well as answers. 
% for step by step instructions to run this script, see the README doc

%get rid of all existing variables and plots in the workspace
clear all 

%first we will open a csv file with event sequence data
% use the string concatenation function strcat to specify exact location and name of the data files
filename = strcat(cd, '\data\genericEventData.csv');
data_events = csvread(filename);

%data_events is an "array" - more specifically a 87 x 3 double array,
%meaning it has 87 rows, 3 columns and the values are all numeric, where 
% each event is in its own row, and the start times of the events are in
% column 1, the end times in column 2 and the type of event is in column
% 3. It contains four types of events, each coded as a number between 1 and 4 

%accessing data

% to reference array data in matlab, the notation is 
% variable_to_store = array_name(row_number, column_number)

%so, for example, to access the start time of the third event 
data_events(3,1)  % third row, first column

%to store this value in a new variable
third_event_onset = data_events(3,1)  % third row, first column

% to access other cells in the array: 
data_events(4,1)  % fourth row, first column
data_events(1,3)  % first row, third column
data_events(1,2)  % first row, second column


%to store the whole row corresponding to the third event 
%try this. nesting the array [ 1 2 3] in the column position indicates to matlab you want to grab
%the first three columns of the indicated row (i.e. third row)
third_event_all = data_events(3,[ 1 2 3])

% alternatively, the ':' allows you to grab all available rows or columns 
third_event_all_2 = data_events(3,:) 

%store the first two columns corresponding to the third event 
% the [ ] brackets allow you to grab multiple rows or columns
third_event_onset_offset = data_events(3,[1 2])

%store all events of type "4" (grab a subset of the data)
all_four_indicies = data_events(:,3)==4; % grab the indices of all rows where in the third column the value is equal to "4"
all_four_data = data_events(all_four_indicies,:);  % -> -> ->  "logical indexing"


%or , same thing but more efficiently combined in one line!
all_four_data = data_events(data_events(:,3)==4,:) 

%manipulating data arrays
%shift event 3 onset and offset by 10 seconds
third_event_all = third_event_all (1, [ 1 2]) + 10

% append the durations of the events as a fourth column: you can use basic
% arithmetic functions (and much more ) on data in the arrays!
durs = data_events(:,2)- data_events(:,1) ;
data_events = [ data_events durs] ;


%to find out how many rows and columns your new all_four_data array has
% the size function syntax is: size(array, dimension)
% where row = 1 and col = 2     

rows = size(all_four_data, 1)
cols = size(all_four_data, 2)       

%save your new variable to the data folder
csvwrite(strcat(cd, '\data\genericEventData_wDuration.csv'), all_four_data)
%or try
%csvwrite(strcat(cd, 'data\pick-a-name.csv'), all_four_data)                                
  


                                
%%Exercises

% calculate and store the overall duration of coded data for this session


% grab and store just the event-types column


%grab all events (including start, stop and type info) for events starting 
% between 40 and 50 seconds
% you will need additional logical operators on your cheat sheet


%create a dataset where all of your events are shifted forward by 10 seconds



%% Scroll down for Exercise answers 

%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%



% calculate and store the overall duration of coded data for this session
sess_dur = data_events(87,2)-data_events(1,1)

%or if you want to be fancy, use the built-in "end" reference or the size
%function
sess_dur = data_events(end,2)-data_events(1,1)
sess_dur = data_events(size(data_events, 1),2)-data_events(1,1) %


% grab and store just the event-types column
eventsCol= data_events(:,3) 

%grab all events (including start, stop and type) for events starting between 40 and 50 seconds
% you will need additional logical operators on your cheat sheet

eventsIndicies= data_events(:,1)>=40 & data_events(:,1)<=50 
events = data_events(eventsIndicies,:)


%create a dataset where all of your events are shifted forward by 10 seconds
data_events_shifted = [ ( data_events(: , [ 1 2 ]) +10)  data_events(:,3)]



