function plotHRnTasks
%this script plots participants' HR data (irregular timeseries data) (one
%data point / beat) along with events corresponding to tasks occuring over
%the course of the session into a single figure. it also introduces how to
%add text labels to plots 

nameString = '_HR and Tasks';

dataDir='C:\Users\kdeba\Dropbox\Libraries\Documents\presentations\2018 ICIS\workshop\final materials\Kaya materials\data';
SaveDir='C:\Users\kdeba\Dropbox\Libraries\Documents\presentations\2018 ICIS\workshop\final materials\Kaya materials\data\outputs';

%want each task to have its own color on the plot, setting up an array of colors (RGB
%values) here to draw from later



for SubNo=   [ 1071 ] %  [1015 1025 1035 1045 1055 1065 1075 1095 ...
    % 1105 1125 1145 1155 1165 1175 1185 1195  1205 1215 1235]  % use this longer array to cycle through
    % each particpant to automatically make a figure for each one
    
    
    % load HR data
    fname=strcat(dataDir,'/',num2str(SubNo),'_HR.mat');
    try
        tempvar=load(fname); %here you can use the load function to open the data because it is a .mat file
        HRfile=tempvar.r2rdata;
        
        existsHR=1;
    catch
        existsHR=0;  %this try-catch loop is a fancy if- then loop that breaks if the lines in "try" dont work - and "catches" you with the lines below
        % it allows us to set this exists variable to 0 to
        % indicate that there is no heart rate data if the
        % loading function doesn't work
    end
    
    
    % load event/task data
    
    eventfname=strcat(dataDir,'\',num2str(SubNo),'_CleanEvents.csv');
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
        
        % eventTypesCell is a data frame ( a cell array, which are generally annoying to work with but allow for all types of data into a single dataframe)
        %that indicates which event values in the event file correspond to which tasks in the sesssion .
        % and associates them with an RGB value (color) for plotting so
        % each task is labelled and colored systematically
        
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
        
        if eventsExist==1
            
            for curEvent= 1: size(eventFile, 1) %looping through all events, will plot each one at a time
                
                curType=eventFile(curEvent,2); % get event details from array
                startTime=eventFile(curEvent,3);
                endTime=eventFile(curEvent,4);
                
                eventIndex = curType == eventTypesArray; %identify event type
                eventName = eventTypesCell (eventIndex, 2); %
                eventColor = rdivide(eventTypesCell{eventIndex,3},255); % transform RGB values into matlab color space by dividing each RGB value by 255
                
                figure(SubNo)
                hold on
                
                % next is the actual line where we plot the event data: one line from the start time  to the
                %end time, at the (more or less arbitrary y axis position  of 180 (which is generally just above where most infants
                %HR data so the two datastreams to be plotted wont overlap)
                
                plot( [startTime/1000 endTime/1000], [180 180] , 'Color', eventColor, 'LineWidth',3) %divide start time by 1000 to transform from msec to sec
                text( startTime/1000, 185, eventName, 'Rotation', 45) % label each event type at a rotation of 45* using the text function , syntax (xaxis position, y axis position, text, and rotation parameter)
                
                
            end
        end
        
        if existsHR ==1 % plot the HR data 
            
            clear goodfile
            goodfile = HRfile (~HRfile(:,3)==1 & ~HRfile(:,5)==1, [ 1 8 ]); % get rid of rows that have been previously marked as bad data
            
            figure(SubNo)
            hold on 
            scatter((goodfile(:,1)/1000), abs(goodfile(:,2)) ,20,[0 0 0],'Marker','+');  %scatter is another plot command that works with x-y pairs (in our case, time-value pairs)
            
            
            
        end
        
        % % uncomment these to add a few hand-annotated "events" to the image
        %         figure(1071)
        %         hold on
        %
        %         plot([664 664] , [ 140 180] , 'k-')
        %         text([ 662 ], 170 , 'start breastfeeding ' )
        %
        %         plot([882 882] , [ 150 110] , 'k-')
        %         text([ 884], 110 , 'finishing feeding' )
        %


        figure(SubNo)
        
        title(strcat(num2str(SubNo)));
        
        xlabel('Seconds');
        ylim([ 81 215]) % where to cut off y axis, selected to fit common HR values for infants
        
        %save plots!
        savename=strcat(SaveDir,'/',num2str(SubNo), nameString, '.eps');
        print('-depsc','-tiff','-r300',char(savename)) % save eps file (high quality)
        saveas( gcf, char(strcat(SaveDir,'/',num2str(SubNo), nameString,'.fig')));  %saves a matlab file
        
        
    end
    
    
end

