%READ ME
% 
% % The seven main scripts associated with this module will allow psychologists with little to no programming experience 
% to begin creating visualizations of the most common types of behavioral data collected in psychology research, including 
% event data from annotation of audio or video records or outputs of intensive longitudinal surveys, as well as timeseries data 
% from annotated data or sensors. The provided materials are designed to educate users to combine and modify scripts to provide 
% insight into their own unique datasets. 

% Users working through the all scripts in order will create a number of appealing plots of common behavioral data as well as gain
% skills and confidence to combine and create variations of these plots to accommodate their own data and research questions. 

% We suggest working through the scripts in the order listed below. 
%for the first 2-4 scripts we recommend running each script one line one at a time 
%and checking the results on the variables by double clicking the variable names in the workspace. 
%lines can be run one at a time by highlighting the line and pressing F9 (keyboard) or "run selection" on the GUI


'SIMPLEST PLOTTING SCRIPTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

programmingBasics.m
% provides basics for importing accessing and manipulating numeric (number only) arrays 
% see also programmingBasics_ans.m for answers to challenges at the bottom


simpleTimeseriesPlots.m

%this script provide basics for visualizing simple timeseries data 
% as well as common modifications . it has been designed to be run one line
% at a time so users can experience building and modifying plots
% see also simpleTimeseriesPlots_ans.m for answers to challenges at the bottom


annotationImport.m
% kaya de barbaro june 2018

%this script imports outputs of annotation software commonly used in psychology, such as Elan, DataVyu, Noldus, or Mangold Interact. 
% working with annotation files in matlab is more difficult than working with simple numeric arrays because matlab is not very good at dealing
%with datafiles that have both numbers and letters in them (it prefers %numbers only). This script walks the user through more specialized
%importing required for these more complex behavioral data formats.

>>  NOTE 1: % this and all subsequent scripts in this module incorporate extensive loops so it is useful to use breakpoints to explore what the 
%code is doing. This is a great introductory  video on this topic: https://www.youtube.com/watch?v=PdNY9n8lV1Y

>>  NOTE 2: % you can also use timeseries plotting and analysis techniques on data imported by annotation import if you convert the
% outputs of annotationImport.m script into timeseries format (using events2Timeseries_fromAnnotationImportScript.m)

simpleAnnotationPlots.m
%this script plots a single dimension of event-type data (i.e. annotations with onset and offset), with annotations differentiated by their 
% vertical positions on a plot. It uses the outputs from annotationImport.m. See many possible modifications to the basic plot in the
% comments 

'MORE OPTIONS FOR COMBINING DATASTREAMS AND MAKING FANCIER PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

simpleAnnotationPlots_byColor.m
% this script plots a single dimension of event-type data (i.e. annotations with onset and offset),
%with annotations disginguished by color. using the sample data the user will plot infant affect using 
% color to distinguish approach withdrawal and neutral annotations

plotHRnTasks.m
%this script plots participants' HR data (irregular timeseries data) (one data point / beat) along with events corresponding to tasks occuring over
%the course of the session into a single figure. it also introduces how to add text labels to plots 

plotE4_simple.m
%this script takes mobile sensor data (from the empatica e4 device) and plots it with events. it manages unix timeformats which are very 
%commonly used and very useful for working with intensive longitudinal data (see %https://en.wikipedia.org/wiki/Unix_time) , it uses 
%subplots to plot three different physiological markers (heart rate, electrodermal activity (EDA) and motion (ACC), and it uses link
%axes to connect the subplots when zooming or panning.

