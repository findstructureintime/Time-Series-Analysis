function demo_visualizations

%this demo will run through the scripts 4-8 associated with the. 
% Note that scripts 1-3 are not included in the demo as they need to be run
% one line at a time, as detailed in the readme.  

%the complete set of scripts provided with this module are as follows: 
% Script 1: multiParticipantEventPlotting.m
% Script 2: plotTimeseriesWithEvents.m
% Script 3: plotSensorData.m


multiParticipantEventPlotting
%this script plots event data from multiple participants. Specifically it
%plots moment-by-moment affect data from three mother-infant dyads engaging in 
%free play (contributed by Dr. Sherryl Goodman from Emory University as cited in the main text)

plotTimeseriesWithEvents
% this script plots infant participants’ heart rate data (timeseries) as it changes over the course of a session
% that includes various types of tasks (events), including a habituation task (visual paired comparison; VPC) 
% and watching various video clips (smiling baby, %crying baby, channel hopping; chan hop) task. 
% It data from mutliple participants. It also introduces how to add text labels to plots.

plotSensorData
% this script plots data files from common mobile sensor outputs. the sample data are from an empatica e4 device. 
% it can plot data from multiple partipants. it translates a common format of time data for sensors, unix time format 
% (see https://en.wikipedia.org/wiki/Unix_time) into easier to work with matlab time formats. it uses subplots
% to plot three different physiological markers (heart rate, electrodermal activity (EDA) and motion (ACC) 
% into a single plot, and it uses link axes to connect the subplots when zooming or panning.


