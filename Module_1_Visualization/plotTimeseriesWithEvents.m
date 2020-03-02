function plotTimeseriesWithEvents

%This script plots infant participants’ heart rate data (timeseries) as it changes over the course of a session that includes various 
%types of tasks (events), including a habituation task (visual paired comparison; VPC) and watching various video clips (smiling baby, 
%crying baby, channel hopping; chan hop) task. it plots multiple participants data at once. It also introduces how to add text labels to plots.

clear all 

nameString = '_HR and Tasks';

dataDir =(strcat (cd, '\data\'));

% create "eventTypesCell" to matche event type (column one) with a name (col 2) and an RGB color value (col 3) for plotting so
% each task has its own label and color

eventTypesCell=   {
    10 , 'Calib check', [ 141 211 199];%  green
    30 , 'Smiling baby',  [255 255 179]; % yellow
    35 , 'Crying baby', [255 255 179]; % purple
    40 , 'Seq learning',  [251 128 114]; %  red
    50 , 'VPC', [128 177 211]; % blue
    71, 'chan hop',   [179 222 105]; %  spring green
    72 , 'chan hop',    [179 222 105]; %  spring green
    73 , 'chan hop' ,   [179 222 105]; %  spring green
    74 , 'chan hop' ,   [179 222 105]; %  spring green
    75 , 'chan hop',  [179 222 105]; %  spring green
    81, 'AAAAB', [252 205 229]}; % pink

eventTypesArray= [10; 30; 35; 40; 50; 71; 72; 73; 74; 75; 81];  %this will help us index which event type a given event is - as it is much easier for matlab to search in an array (just numbers) than a cell array

for PID=   [ 1045 1031 ] % could add more participants to this array to loop through all ps in study
    
    % load HR data
    fname=strcat(dataDir,num2str(PID),'_HR.mat');
    try
        tempvar=load(fname); %here you can use the load function to open the data because it is a .mat file
        HRfile=tempvar.r2rdata;
        existsHR=1;
    catch
        existsHR=0;  %a try-catch loop is a fancy if- then loop that breaks if the lines in "try" dont work
    end
    
    % load event/task data
    eventfname=strcat(dataDir,num2str(PID),'_CleanEvents.csv');
    try
        eventFile=csvread(eventfname);
        if ~isempty(eventFile)
            eventsExist=1;
        else
            eventsExist=0; % here, even if the events load the file may be empty, which also means there is no event data
        end
    catch
        eventsExist=0;
    end
    
    if eventsExist==1 && existsHR ==1
        
        if eventsExist==1
            
            %plot eventData
            %loop through all events, will plot each one at a time
            for curEvent= 1: size(eventFile, 1)
                
                % get event details from array
                curType=eventFile(curEvent,2);
                startTime=eventFile(curEvent,3);
                endTime=eventFile(curEvent,4);
                                
                eventIndex = curType == eventTypesArray; %identify event type
                eventName = eventTypesCell (eventIndex, 2); %
                eventColor = rdivide(eventTypesCell{eventIndex,3},255); % transform RGB values into matlab color space by dividing each RGB value by 255
                
                figure(PID) %plot this participants data in a figure whose number corresponds to their PID
                hold on
                
                %plot each event
                plot( [startTime/1000 endTime/1000], [180 180] , 'Color', eventColor, 'LineWidth',3) %divide start time by 1000 to transform from msec to sec

                % label each event with a description, at a rotation of 45* using the text function, syntax (x_axis_position, y_axis_position, text, 'Rotation', degrees_to_rotate)
                text( startTime/1000, 185, eventName, 'Rotation', 45)    
            
            end
        end
        
        % plot the HR data - we will use scatter(xvals, yvals) which functions similarly to plot(xvals, yvals) but plots individual
        % points rather than a line - which is nice for HR data that has
        % irregular rather than regular timing 
        
        if existsHR ==1
            
            clear goodfile
            goodfile = HRfile (~HRfile(:,3)==1 & ~HRfile(:,5)==1, [ 1 8 ]); % get rid of rows that have been previously marked as noisy HR data, where noisy data has a value of 1 in column 3 or 5
            
            figure(PID)
            hold on
            scatter((goodfile(:,1)/1000), abs(goodfile(:,2)) ,20,[0 0 0],'Marker','+');
            
        end
        
        %make it pretty!       
        figure(PID)
        title(strcat(num2str(PID), ': HR and tasks data'));
        xlabel('Seconds');
        ylim([ 81 215]) % sets y axis range, selected to fit common HR values for infants
        
        %save your plot
        savename=strcat(dataDir,'/',num2str(PID), nameString, '.eps');
        print('-depsc','-tiff','-r300',char(savename)) % save eps file (high quality)
        saveas( gcf, char(strcat(dataDir,'/',num2str(PID), nameString,'.fig')));  %saves a matlab file
          
    end %close plot loop for current participant
        
end %close loop for this participant

