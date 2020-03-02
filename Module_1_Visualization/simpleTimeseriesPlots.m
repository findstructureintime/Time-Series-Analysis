function simpleTimeseriesPlots
% kaya de barbaro june 2018

%this script provide basics for visualizing simple timeseries data 
% as well as common modifications . it has been designed to be run one line
% at a time so users can experience building and modifying plots. it also contains practice problems at the end of the script as well as answers. 
% for step by step instructions to run this script, see the README doc

clear all 

%get to know the simple plot fuction
figure(1)
plot (1,1) 
plot (1,1, 'rs','MarkerSize',10)

%plot your first timeseries using the syntax plot(xvals, yvals)!
figure (1)
plot([1 2 3 4 5], [1 2 3 2 1])

% add each datapoint as a red box
hold on
plot([1 2 3 4 5], [1 2 3 2 1], 'rs','MarkerSize',10)

% try the syntax plot(yvals)
% note: if time is regular across your datastreams you dont need to indicate timestamps/ xvals
figure (2)
plot([1 2 3 2 1], 'bs','MarkerSize',10)

%now, lets open up some actual data to plot
% use the string concatenation function strcat to specify exact location and name of the data files
dataDir =(strcat (cd, '\data\'));

fnameG=strcat(dataDir,'InfGaze_P6_4mo.csv');
fnameH=strcat(dataDir,'InfHands_P6_4mo.csv');
  
%read face and hand data using csvread command
gazeData=csvread(fnameG);
handsData=csvread(fnameH);

%plot gaze to first object
figure(1)
plot (gazeData(1,:))   
title('Infant gaze: Object 1')

axis ([0 1864 0 1.5 ])                    
% axis([XMIN XMAX YMIN YMAX])
axis ([0 size(gazeData,2)+100 0 1.5 ])  


% plot gaze to all objects on one plot 
figure (2)
plot (gazeData(1,:), 'g') 
hold on
plot (gazeData(2,:),'r') 
plot (gazeData(3,:), 'c')    
title('Infant Gaze: three objects')
axis ([0 size(gazeData,2)+100 0 1.5 ])

%You have lots of options for colors and shapes- e.g. 
figure (21)
plot(gazeData(1,:), 'g--')
figure (22)
plot(gazeData(1,:), 'g+')
figure (23)
plot(gazeData(1,:), 'gs') 

% or if you want to get really wild.. 
figure (3)
plot(gazeData(1,:),'-mo',...
    'LineWidth',2,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',[.49 1 .63],...
    'MarkerSize',10)


% ------> for more line specification options see
%https://www.mathworks.com/help/matlab/ref/linespec.html

% same data as plot 2, new look 
figure (4)
plot (gazeData(1,:), 'gs', 'MarkerFaceColor', 'g') 
hold on
plot (gazeData(2,:),'rs','MarkerFaceColor', 'r') 
plot (gazeData(3,:), 'cs', 'MarkerFaceColor', 'c')    
axis ([0 size(gazeData,2)+100 .4 1.5 ])
title('Infant Gaze: three objects')

% plot gaze and hands data together using two linked subplots
figure (5)
ax1= subplot(2,1,1);    % syntax is subplot(total rows of plots, total columns of plots, position of current plot)
plot(gazeData(1,:),'g')
axis ([0 size(gazeData,2)+100 0 1.5 ])
title('Looking at toy 1')

ax2= subplot(2,1,2);
plot(handsData(1,:),'g')
axis ([0 size(gazeData,2)+100 0 1.5 ])
title('Touching toy 1')    %-----> try zooming in on one

linkaxes([ax1,ax2],'x')  %----> now try zooming in again 

% generate and plot summed gaze and hands data
% sum gaze and hands directed to each object
sumObj1= handsData(1,:)+ gazeData(1,:); 
sumObj2 = handsData(2,:)+ gazeData(2,:); 
sumObj3 = handsData(3,:)+ gazeData(3,:); 

figure(6)
hold on
plot (sumObj1, 'g')
plot (sumObj2, 'r')
plot (sumObj3, 'c')

axis ([0 size(gazeData,2)+100 0 3 ])
title('Gaze and Hands Sums')


%or sum gaze across all three objects 
% syntax is sum (array_name, dimension) where dimension is 1 for row 2 for column

gazeSum = sum(gazeData,1);  
figure(7)
plot (gazeSum, 'k')
axis ([0 size(gazeData,2)+100 0 1.5 ])
title('Gaze Sum')

%save your plots - this will save the most recently accessed plot
savename=strcat(dataDir,'/simpleTimeseriesPlot');
print('-depsc','-tiff','-r300',strcat(savename, '.eps')) %high quality
saveas( gcf, char(strcat(savename,'.fig')));  %saves a matlab file
saveas( gcf, char(strcat(savename,'.jpg')));  %saves a jpg


% Exercises
% create an "object contact" timeseries for each of the three objects
% summing looking and touching activity at each timepoint (i.e. the values should range from 0-2 )
% plot 7: plot the three timeseries on the same plot using a different
% color for each toy 
% plot 8: plot each of the three timeseries in its own subplot (ie three
% subplots in one plot)
% plot 9: Adjust your figure 4 plot  two so that you can observe
% if infants are looking to two toys at the same time
%plot 10: Add touching behavior to plot 9



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






% Exercise answers 
% create an "object contact" timeseries for each of the three objects
% summing looking and touching activity at each timepoint (i.e. the values should range from 0-2 )

redSum= gazeData(1,:)+ handsData(1,:);
greenSum= gazeData(2,:)+ handsData(2,:);
blueSum= gazeData(3,:)+ handsData(3,:);

% plot 7: plot the three timeseries on the same plot using a different
% color for each toy 

figure (7)
plot (redSum, 'r') 
hold on
plot (greenSum,'g') 
plot (blueSum, 'c')    
title('Infant Gaze: three objects')
axis ([0 size(gazeData,2)+100 0.2 2.5 ])

% plot 8: plot each of the three timeseries in its own subplot (ie three
% subplots in one plot)

figure(8)
ax1= subplot(3,1,1);    
plot(redSum,'r')
axis ([0 size(gazeData,2)+100 0.2 2.5 ])
title('Red toy contact')

ax2= subplot(3,1,2);
plot(greenSum,'g')
axis ([0 size(gazeData,2)+100 0.2 2.5 ])
title('Green toy contact')

ax3= subplot(3,1,3);
plot(blueSum,'c')
axis ([0 size(gazeData,2)+100 0.2 2.5 ])
title('blue toy contact')

linkaxes([ax1,ax2, ax3],'x')  


% plot 9: Adjust your figure 4 plot  two so that you can observe
% if infants are looking to two toys at the same time

figure (9)
plot (gazeData(1,:)+.02, 'rs', 'MarkerFaceColor', 'r') 
hold on
plot (gazeData(2,:),'gs','MarkerFaceColor', 'g') 
plot (gazeData(3,:)-.02, 'cs', 'MarkerFaceColor', 'c')    
title('Infant Gaze: three objects')
axis ([0 size(gazeData,2)+100 0.2 1.5 ])

%plot 10: Add touching behavior to plot 9

hold on 
plot (handsData(1,:)+.02-.5, 'rs', 'MarkerFaceColor', 'r') 
hold on
plot (handsData(2,:)-.5,'gs','MarkerFaceColor', 'g') 
plot (handsData(3,:)-.02-.5, 'cs', 'MarkerFaceColor', 'c')    
title('Infant Object attention')
axis ([0 size(gazeData,2)+100 0.2 1.5 ])



