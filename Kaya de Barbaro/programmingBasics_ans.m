% programming basics 
% accessing array elements
% kaya de barbaro june 2018


%open a csv file with event sequence data
% you will need to change this to point to the name and location of your file
% on your computer
csv_events = 'C:\Users\kdeba\Dropbox\Libraries\Documents\UT Austin\projects\visualization scripts\LingerScripts\cevent_eye_roi_child.csv';
data_events = csvread(csv_events);

%data_events is an "array" - more specifically a 87 x 3 double array,
%meaning it has 87 rows, 3 columns and the values are all numeric

% to reference array data in matlab, the notation is 
% variable_to_store = array_name(row, column)

%to store the start time of the third event 
third_event = data_events(3,1);      

%store the whole row corresponding to the third event 
% the ':' allows you to grab all rows or columns
third_event_all = data_events(3,:);

% append the durations of the events as a fourth column
durs = data_events(:,2)- data_events(:,1); 
data_events = [ data_events durs]; 

%store all events of type "4"
all_four_ind = data_events(:,3)==4;
all_four = data_events(all_four_ind,:);     % -> -> ->  "logical indexing"


%or , same thing but combined in one line
all_four = data_events(data_events(:,3)==4,:); 


%find out how many rows and columns your new all_four array has
rows = size(all_four, 1);
cols = size(all_four, 2);       % -> the size function syntax: size(array, dimension)
                                %    where row = 1 and col = 2     



%%Exercises

% calculate and store the overall duration of coded data for this session
sess_dur = data_events(87,2)-data_events(1,1);

%or if you want to be fancy, use some built-in functions
sess_dur = data_events(end,2)-data_events(1,1);

% grab and store just the event-types column
eventsCol= data_events(:,3); 

%grab all events (including start, stop and type) for events starting between 40 and 50 seconds
% you will need additional logical operators on your cheat sheet

eventsInd= data_events(:,1)>=40 & data_events(:,1)<=50 ;
events = data_events(eventsInd,:);


%create a dataset where all of your events are shifted forward by 10 seconds
data_events_shifted = [ ( data_events(: , [ 1 2 ]) +10)  data_events(:,3)];


