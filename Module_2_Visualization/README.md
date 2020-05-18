# Module 2: Getting to Know Your Data: Visualization of High-Density Multi-Modal Interactions

With the four scripts associated with this module, users can begin creating visualizations of the most common types of behavioral data collected in psychology research. The scripts will allow you to make visualizations of various type of data, including event data from annotation of audio or video records, as well as timeseries data, whether from sensors or annotations. 
	 	
For novice users, we suggest working through the scripts in the order listed below. There are three total scripts, each described below in detail. 

Script 1: [multiParticipantEventPlotting.m](multiParticipantEventPlotting.m)

Script 2: [plotTimeseriesWithEvents.m](plotTimeseriesWithEvents.m)

Script 3: [plotSensorData.m](plotSensorData.m])


For all scripts below you will want to start MATLAB or Octave and navigate to the folder where the provided material (.M-functions and the data files) are located. That is, making MATLAB’s current folder equal to the folder to which you downloaded this module (e.g. ‘C:\\...\My Documents’). After this you can call these functions via the command line or the Matlab/Octave GUI.

**Script 1: *multiParticipantEventPlotting.m***

1. This script builds upon the basic event plots from the *simpleEventDataPlotting* script. We will use it to plot a new dataset: moment-by-moment affect data from three mother-infant dyads engaging in free play (contributed by Dr. Sherryl Goodman from Emory University). All mothers in the study have a history of depression. Three states of infant affect are annotated– positive, neutral, and negative (+ 1 to -1) and mother affect is annotated on a 7-point scale, from highly positive to highly negative (+3 to -3). For the purposes of the visualization, we will collapse maternal affect into three states: positive (encompassing +3, +2 and +1) neutral (0) and negative (-1, -2 and -3) to match the infant states. We will use both color and vertical positioning to differentiate each participants’ states of affect. 

Open the script and check it out. The sections of the script that plot data (i.e. the for loops beginning with `%plot infant affect states` and `%plot mom affect states` should remind you of the for loop in which you ploted from the *gazeEvents* array in the *simpleEventDataPlotting* script . In this script, we embed this plotting code in a for loop that cycles through multiple participants. Let’s look at some of the details of what happens in the first for loop, which begins as follows: 
```matlab
for pID =  [3414  3367 3532 ] 
	
% use string concatenation function strcat to specify exact data % files
fname=strcat(cd,'\data\MoInfAffectArray_', num2str(pID), '.csv');
    
%read data using csvread command
pData=csvread(fname);
```

These lines open a data file, similar to what we’ve seen before in earlier scripts. Note however that in this script, the fname variable is now created using the dynamic value *pID* which changes its value within each of iteration of the top for loops -  rather than hard-coding these values as in our prior scripts. 

7.	To plot mother and infant affect states in different colors and on different axis positions we need to do one more thing. Let’s go back to the top of the script to look at the following lines:
```matlab
% first we make a color array, assigning a color and position to each state of mother and infant affect

infAffectColor= {
   		 1 ,  'b', .1 ; % +1 -  approach (positive) ; blue
   		 0 , 'k', 0 ; %    0 - neutral; black
   		 -1, 'r' , -.1}; % -1  - withdrawal (negative); red
```

In this code we specify a color array, assigning a color and position for each of the three infant affect states. Note the curly brackets used in initializing this array. Because this array contains letters (i.e.  “strings” in matlab) it needs to be initialized as a special type of array, called a “cell array”.  

8. Now let’s take a look at the for loop where we will plot infant affect states. The code in this section is as follows: 
```matlab
% plot infant affect states
for curAffectState = [ 1:3 ] 
	%get label, color and position info for the current infant affect state
	curAffColor = infAffectColor{curAffectState,2};
	curAffValue = infAffectColor{curAffectState,1};
	curAxisPos = infAffectColor{curAffectState,3};

	%plot infant affect for this state
	%grab all the event rows for this state of infant affect
	indices = find(infantData(:, 4)== curAffValue);
	dataRows = infantData(indices,:);

	%count the number of affect events
	countRows = size(dataRows,1);
        
   	%for loop to plot all infant affect events of the current state
	for row = 1: countRows
		hold on
		plot(dataRows (row,[1 2]), [ curAxisPos curAxisPos], 'Color',curAffColor, 'LineWidth',10 )
	end
end
```

This code contains a nested for loop structure. The main for loop cycles through the three affect states. For each type affect state (positive, negative, and neutral) there is a for loop to plot all the events that match the current affect state. The line: 
```matlab
curAffColor = infAffectColor{curAffectState,2};
```
grabs the color information for the associated infant affect state and saves it in the 	variable *curAffColor*. To see what color it will set for *curAffectState = 1*, run the line: *infAffectColor{1,2}* from the command window. You should get ‘b’ for black, the value in the first row, second column of the *curAffColor* variable. 

9. Now let’s take look at the plot code itself within one of the for loops 
```matlab
plot(dataRows (row,[1 2]), [ curAxisPos curAxisPos], 'Color',curAffColor, 'LineWidth', 10)
```

Note: The plotting function now uses the dynamic value curAffColor – which changes its value within each loop – rather than hard-coding a single color as in figure 5. Similarly, curAxisPosition will change with each loop through the three affect states. 


10.	Now lets return to the top of the for loop looping through each participants data. Check out the following lines
```matlab
infantData = pData(~(isnan(pData(:,4))),:); %inf data located in col 4
momData = pData(~(isnan(pData(:,3))),:); %mat data located in column 3
```
    
Lots of data coming out of common annotation software has multiple types of  annotations in the same file. These are often stored in separate columns of the data. If we want to access some of this data (e.g. infant vs. mom affect annotations) but not all of it (e.g. infant and mom problem data) we can find and store those data in a new variable. 

There are multiple functions in the first line – lets break them down. *isnan(pData(:,4))* gives you the row numbers of all rows that have no values in the fourth column. The ~ symbol means “not”, so ~ *isnan(pData(:,4))* – gives you the row numbers of all rows that have values in the fourth column: ie those rows that have any infant affect data, and stores them in the variable *infIndices*. Finally, the next line creates a new variable that takes the stored Row numbers (indices) and provides the actual values in those rows (i.e. the infant affect events themselves). The line finding maternal affect data combines these two lines into a single line, but the outcome is the same. 

To see these in action, you can set a “breakpoint” in your file. That is, point your mouse to the left of the line you are interested in, just to the right of the line number. If you right click your mouse here, you will see a dot appear –a breakpoint. When we run the script in the next step this breakpoint will “stop” the script at this location, allowing you to observe all variables present in the workspace and their values. 

11.	Now we are ready to run the full script. This is a complete file so you can run it by either pressing the run button in the GUI, or copy-pasting the script title into the command window and hitting return. 

If you set breakpoints, you will see a green arrow stopped at your first breakpoint. This indicates how much of the script has already been run. In this “debugging” mode you can advance (step) through the script one line at a time by pressing the *Step* button in the GUI. The workspace shows only those variables that have already been created in the script up to that point, and the variables will dynamically update as you step through the function. You can advance to the next breakpoint by pressing the *Continue* button. Or you can remove any individual breakpoint by clicking the red dots and hitting ‘run” again to take you to the end of the script. 
	
If you haven’t set any breakpoints, you will get three plots showing mother and infant affect for three different participants. The x-axis shows time (in seconds) and the y axis distinguishes different dimensions of affect. Maternal affect is represented in three rows at the top, infant affect is represented in three lower rows. For both mothers and infants, the highest of the three rows (in blue) represent positive affect, the middle row (in black) represents neutral affect, and the bottom row (in red) represents negative affect. We discuss these figures in the main manuscript text.

Hint: Note that these colors and horizontal positions are set in *infAffectColor* and *momAffectColor*. These parameters are arbitrary in that one could change them to any other color or positioning- however, setting these values in an intuitive way (higher affect higher, red = distress, same colors for same states across mother and infant) can greatly facilitate the comprehension of your plots. Additionally the simple black lines (“kebab lines”) plotted before the main mother and infant plot loops help to orient the observer to where data will be present. Try removing them (or changing their positioning) to see how it affects the overall plot. Also, try adjusting the height and width of these plots and see how that affects the spacing between the dimensions of affect. The plots shown in the manuscript text were adjusted to be long and thin (hotdog shape) such that each dimension of mother and infant affect was touching as this highlights the patterns of contingency within and between mother and infant affect.

**Script 2: *plotTimeseriesWithEvents.m***

1. Take a look at the script. This script plots infant participants’ heart rate data (in timeseries format) as it changes over the course of a session that includes various types of tasks (in event-data format), including a habituation task (visual paired comparison; VPC) and watching various video clips (smiling baby, crying baby, channel hopping; chan hop) task. It plots multiple participants’ data at once. It also introduces how to add text labels to plots.

2. See if you can figure out how the script works. If you have gone through the earlier scripts in this module, you will be familiar with most of the code here. Add some breakpoints if you are unsure of what a line or part of a line does. 

3. You haven’t yet seen the text function before. It allows you to insert a label into your plot. The syntax is, text(x_axis_position_for_start_of_text, y_axis_position_for_start_of_text, the_text_itself, 'Rotation', degrees_to_rotate). In this script it is in the loop that plots event data, as follows: 
```matlab
text( startTime/1000, 185, eventName, 'Rotation', 45)
```

In this case, the text itself is stored in the variable eventName, which changes dynamically on each loop through the list of events to match the task name, as specified in the *eventTypesCell*.

4.	Run the script by either pressing the run button in the gui, or copy-pasting script title into the command window and hitting return. You should get two new plots, one each from two different participants. We discuss these figures in the main manuscript text. 


**Script 3: *plotSensorData.m***

1. This script plots data files from common mobile sensor outputs, in this example, from 	the Empatica E4 device. It can plot multiple participants of data. It translates a common 	format of time data for sensors (unix time format; see https://en.wikipedia.org/wiki/Unix_time) into easier to work with matlab time formats. 	It uses subplots to plot three different physiological markers (heart rate, electrodermal 	activity (EDA) and motion (ACC) into a single plot, and it 	uses link axes to connect 	the subplots when zooming or panning.

2. Run the script by either pressing the run button in the gui, or copy-pasting script the title *plotSensorData* into the command window and hitting return. You should get a new plot!

This code module is written by [Dr. Kaya de Barbaro](https://liberalarts.utexas.edu/psychology/faculty/kd26254), if you have any question please contact *kaya at austin.utexas.edu*.