function simpleAnnotationPlots_byColor

% this script plots a single dimension of event-type data (i.e. annotations with onset and offset),
%with annotations disginguished by color. using the sample data the user will plot infant affect using 
% color to distinguish approach withdrawal and neutral annotations

%data dir should point the folder with your ready-for-matlab annotation files (outputs similar to those created by AnnotationImport.m)
dataDir ='C:\Users\kdeba\Dropbox\Libraries\Documents\presentations\2018 ICIS\workshop\final materials\Kaya materials\data\';
saveDir='C:\Users\kdeba\Dropbox\Libraries\Documents\presentations\2018 ICIS\workshop\final materials\Kaya materials\data\outputs\';

for pID = [ 3011 ] % [ 3011 3029 3292 3466 3569] list all your pIDs here to loop through the code below for each
    
    % use string concatenation function strcat to specify exact data files
    fname=strcat(dataDir,'MoInfAffectArray_', num2str(pID), '.csv');
    
    %read data using csvread command
    pData=csvread(fname);
    
    %grab all infant affect annotations
    % all rows in column 4 of pData that have some non-Nan values
    % using isnan and the ~ logical operator which means "NOT"
    
    dataRows = pData(~(isnan(pData(:,4))),:);
    
    figure (pID) %foreground the figure associated with current participant
    hold on    % don't overwrite what was previously there
    
    
    %define a cell array that specifies a color for each event type, using the value corresponding to each
    % annotation in the column for that coding scheme (in this case, infant affect is in column
    % 4 and is indicated by three values - 1, 0 and -1, where:
    % 1 -> approach, 0 -> neutral , -1 ->  withdrawal (negative)
    
    %first column indicates cell type, second column indicates the RGB
    %values for the colors you want to use for this annotation
    
    infAffect = { 1 ,  [0 102 204]; % typeindex 1 -  approach; dark blue
        0 , [204 229 255]; %typeindex 2 - neutral; light blue
        -1, [251 128 114] }; %typeindex 3 - withdrawal (negative); red
    
    
    %next use a for loop to go row by row through each TYPE of infant affect event
    %and plot each event as a line
    %there are three types 
    
    for typeIndex = 1:3 
        %get type info
        type = infAffect {typeIndex,1}; % curly brackets to get cell contents now because infAffect is a cell array, type will be 1 0 or -1
        typeColor = rdivide(infAffect{typeIndex,2},255); % this grabs the correct color for each type
        
        %store infant affect events that correspond to this type in dataRows array. % on the first loop through, dataRows will contain all approach events (typeIndex =1, type =1),
        %on loop two (typeIndex =2, type =0), it will contain all neutral
        %events, loop 3 - all negative (typeIndex =3, type =-1)
        indices = find(pData(:, 4)== type); 
        dataRows = pData(indices,:); 
        
        %next we want to go row by row and plot the annotations for each
        %type
        %first we count how many rows we have
        countdataRows = size(dataRows,1);
        
        for row = 1: countdataRows  %this sets up an index "row" which will cycle through a series of values, starting from 1 and going until the last row in increments of 1
            % this time we will plot all infant affect at the same vertical position (at y=0) so yvals
            % will always be [ 0 0 ] rather than changing by type of event as in
            % simpleAnnotationPlots.m
            plot(dataRows(row,[1 2]), [ 0 0  ], 'Color',typeColor, 'LineWidth',25 ) % plot the annotation from the current row
            
        end
        
    end
    
    %make it pretty and save it!
    axis([pData(1,1) pData(size(pData,1),2) -2 2])
    
    title(strcat('Infant Affect:', (num2str(pID))));
    
    savename=strcat(saveDir,'P', num2str(pID), '_InfAffect');
    %  print('-depsc','-tiff','-r300',strcat(savename, '.eps')) %high quality
    saveas( gcf, char(strcat(savename,'.fig')));  %saves a matlab file
    saveas( gcf, char(strcat(savename,'.jpg')));  %saves a jpg
    
end




