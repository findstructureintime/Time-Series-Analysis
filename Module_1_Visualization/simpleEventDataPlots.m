function simpleEventDataPlots
% kaya de barbaro june 2018

%this script provide basics for visualizing simple event data 
% as well as common modifications . it has been designed to be run one line
% at a time so users can experience building and modifying plots.

clear all

%use the simple plot function to plot a single line representing an event
figure (1)
plot([ 1 3], [ 2 2], 'c', 'LineWidth',10)

%resize axis
axis([0 10 0 4])

%add some more "events" to your plot, including some at different vertical positions
hold on
plot([ 5 6], [ 2 2] , 'c', 'LineWidth',10)
plot([ 2 6], [ 1 1], 'c', 'LineWidth',10 )

%add some more "events" to your plot in another color
plot([ 3.1 4.9], [ 2 2] , 'g', 'LineWidth',10)
plot([ 6.1 9.1], [ 2 2] , 'g', 'LineWidth',10)
plot([ 6.2 9.1 ], [ 1 1], 'g', 'LineWidth',10 )

%save your figure!
dataDir =(strcat (cd, '\data\'));
savename=strcat(dataDir,'simpleEventPlot');
saveas( gcf, char(strcat(',', '.fig')));  %saves a matlab file
saveas( gcf, char(strcat(savename,'.jpg')));  %saves a jpg


% now lets plot data from an simple array that looks more similar to an event array.
%create a gaze event array
gazeEvents  = [
    5,    6,    1 ;
    3.1 , 4.9 , 2 ;
    6.1 , 9.1 , 2 ];

%we can plot all the events in the array using a for loop
figure (2)
hold on
countRows = size(gazeEvents,1)

for row = 1: 1: countRows
    plot(gazeEvents(row,[1 2]), [2 2], 'c', 'LineWidth',10)
end

%resize axis
axis([0 15 0 10])

%lets try some simple variations!

clf(3) % clear figure 3
figure (3)
axis([0 15 0 10])
hold on
countRows = size(gazeEvents,1);

for row = 1: 1: countRows
    
    % this shifts the events vertically up (y axis)
    % plot(gazeEvents(row,[1 2]), [ 7 7] , 'c', 'LineWidth',10)
    
    % this shift events forward in time by five seconds
     plot(gazeEvents(row,[1 2])+5, [ 2 2], 'c', 'LineWidth',10)
    
    % this puts the x axis in minutes rather than seconds
    % you will need to zoom in to see the event!
    % plot(gazeEvents(row,[1 2])/60, [ 2 2], 'c', 'LineWidth',10)
    
    % this plots events in different horizontal positions on the y axis depending on their event type
    % gazes to object 1 are plotted on the y=1 axis, gazes to object 2 are plotted on the y=2 axis,
    % plot(gazeEvents(row,[1 2]), gazeEvents(row,[3 3]) , 'c', 'LineWidth',10)
    
end








