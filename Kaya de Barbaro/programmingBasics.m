% programming basics 
% accessing and manipulating array elements
% kaya de barbaro june 2018
% programming basics 
% accessing and manipulating array elements
% kaya de barbaro june 2018

%the recommendation is to go through this script, running each line one at a
%time and checking the results on the variables by double clicking the variable names in the
%workspace. lines can be run one at a time by highlighting the line and
%pressing F9 (keyboard) or "run selection" on the GUI


%first we will open a csv file with event sequence data
% you will need to change the next line to point to the name and location of your file on your computer
csv_events_loc = 'C:\Users\kdeba\Dropbox\Libraries\Documents\presentations\2018 ICIS\workshop\final materials\Kaya materials\data\cevent_eye_roi_child.csv';
data_events = csvread(csv_events_loc)

%data_events is an "array" - more specifically a 87 x 3 double array,
%meaning it has 87 rows, 3 columns and the values are all numeric, where 
% each event is in its own row, and the start times of the events are in
% column 1, the end times in column 2 and the type of event is in column
% 3 (XXXXFIXXX four types of events, each coded as a number between 1 and 4) 

% to reference array data in matlab, the notation is 
% variable_to_store = array_name(row, column)

%so, for example, to store the start time of the third event 
third_event = data_events(3,1)  

%store the whole row corresponding to the third event 
% the ':' allows you to grab all rows or columns
third_event_all = data_events(3,:) % see also  data_events(3,[ 1 2 3])

%store the first two columns corresponding to the third event 
% the [ ] brackets allows you to grab multiple rows or columns
third_event_onset_offset = data_events(3,[1 2])

% append the durations of the events as a fourth column: you can use basic
% arithmetic functions (and much more ) on data in the arrays!
durs = data_events(:,2)- data_events(:,1) 
data_events = [ data_events durs] 

%shift event 3 onset and offset by 10 seconds
third_event_all = third_event_all (1, [ 1 2]) + 10

%store all events of type "4" (grab a subset of the data)
all_four_indicies = data_events(:,3)==4 % grab the indices of all rows where in the third column the value is equal to "4"
all_four_data = data_events(all_four_indicies,:)     % -> -> ->  "logical indexing"


%or , same thing but more efficiently combined in one line!
all_four_data = data_events(data_events(:,3)==4,:) 


%find out how many rows and columns your new all_four_data array has
rows = size(all_four_data, 1)
cols = size(all_four_data, 2)       % -> the size function syntax: size(array, dimension)
                                %    where row = 1 and col = 2     

%save your new datafile to the data folder
csvwrite('C:\Users\kdeba\Dropbox\Libraries\Documents\presentations\2018 ICIS\workshop\final materials\Kaya materials\data\cevent_eye_roi_child2.csv', all_four_data) 
                               
                                
                                
%%Exercises

% calculate and store the overall duration of coded data for this session


% grab and store just the event-types column


%grab all events (including start, stop and type info) for events starting 
% between 40 and 50 seconds
% you will need additional logical operators on your cheat sheet


%create a dataset where all of your events are shifted forward by 10 seconds

