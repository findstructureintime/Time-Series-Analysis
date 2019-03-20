function simpleTimeseriesPlot_MESA

dataDir ='C:\Users\kdeba\Dropbox\Libraries\Documents\presentations\2018 ICIS\workshop\';
saveDir='C:\Users\kdeba\Dropbox\Libraries\Documents\presentations\2018 ICIS\workshop\';

% use string concatenation function strcat to specify exact data files
fnameG=strcat(dataDir,'InfGaze_P6_4mo.csv');
fnameH=strcat(dataDir,'InfHands_P6_4mo.csv');
  
%read face and hand data using csvread command
gazeData=csvread(fnameG);
handsData=csvread(fnameH);


%plot gaze to first object
figure(1)
plot (gazeData(1,:))    % plot(yvals)  % if time is regular across your datastreams you dont need to indicate timestamps/ xvals
title('Infant gaze: Object 1')

axis ([0 size(gazeData,2) 0 1.5 ])                     % axis([XMIN XMAX YMIN YMAX])
axis ([0 size(gazeData,2)+100 0 1.5 ])  


% plot gaze to all objects on one plot 
figure (2)
plot (gazeData(1,:), 'r') 
hold on
plot (gazeData(2,:),'g') 
plot (gazeData(3,:), 'c')    
title('Infant Gaze: three objects')
axis ([0 size(gazeData,2)+100 0 1.5 ])

%You have lots of options for colors and shapes- e.g. 
plot(gazeData(1,:), 'r--')
plot(gazeData(1,:), 'r+')
plot(gazeData(1,:), 'rs') 

% or if you want to get really wild.. 
t = 0:pi/20:2*pi;
figure (3)
plot(t,sin(2*t),'-mo',...
    'LineWidth',2,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',[.49 1 .63],...
    'MarkerSize',10)


% ------> for more line specification options see
%https://www.mathworks.com/help/matlab/ref/linespec.html

% same data as plot 2, new look 
figure (4)
plot (gazeData(1,:), 'rs', 'MarkerFaceColor', 'r') 
hold on
plot (gazeData(2,:),'gs','MarkerFaceColor', 'g') 
plot (gazeData(3,:), 'cs', 'MarkerFaceColor', 'c')    
title('Infant Gaze: three objects')
axis ([0 size(gazeData,2)+100 0 1.5 ])

axis ([0 size(gazeData,2)+100 0.2 1.5 ])


% plot the data together using two linked subplots
figure (5)
ax1= subplot(2,1,1);    % syntax is subplot(total rows of plots, total columns of plots, position of current plot)
plot(gazeData(1,:),'r')
axis ([0 size(gazeData,2)+100 0 1.5 ])
title('Looking at red toy')

ax2= subplot(2,1,2);
plot(handsData(1,:),'r')
axis ([0 size(gazeData,2)+100 0 1.5 ])
title('Touching red toy')    %-----> try zooming in on one

linkaxes([ax1,ax2],'x')  %----> now try zooming in again 


% generate and plot gaze sums
figure(6)
gazeSum = gazeData(1,:)+ gazeData(2,:)+ gazeData(3,:); 
%or for same result, try 
gazeSum2 = sum(gazeData,1); % if you are summarizing data in a single array
                            % syntax is sum (array, dimension) where
                            % dimension is 1 for row 2 for column

plot (gazeSum)
axis ([0 size(gazeData,2)+100 0 1.5 ])
title('Gaze Sum')



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





%save your plots 
savename=strcat(saveDir,'/whatever_name_you_want');
print('-depsc','-tiff','-r300',strcat(savename, '.eps')) %high quality
saveas( gcf, char(strcat(savename,'.fig')));  %saves a matlab file
saveas( gcf, char(strcat(savename,'.jpg')));  %saves a jpg
