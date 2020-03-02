function multiParticipantEventPlotting

%this script plots event data from multiple participants. Specifically it
%plots moment-by-moment affect data from three mother-infant dyads engaging in 
%free play (contributed by Dr. Sherryl Goodman from Emory University as cited in the main text)

%notes on sample data
%Three states of infant affect are annotated– positive, neutral, and negative (+ 1 to -1). 
%Mother affect is annotated on a 7-point scale, from highly positive to highly negative (+3 to -3). 
%For the purposes of the visualization, we will collapse maternal affect into three states: positive 
%(encompassing +3, +2 and +1) neutral (0) and negative (-1, -2 and -3) to match the infant states. 
%We will use both color and vertical positioning to differentiate each participants’ states of affect. 

%first we make a color array, assigning a color and position to each state of mother and infant affect
infAffectColor= {
    1 ,  'b', .1 ; % +1 -  approach (positive) ; blue
    0 , 'k', 0 ; %    0 - neutral; black
    -1, 'r' , -.1}; % -1  - withdrawal (negative); red

momAffectColor= {
    3 ,  'b' , .5 ; % positive - blue
    2 ,  'b'  , .5 ; % positive - blue
    1 ,  'b' , .5 ; % positive - blue
    0 , 'k', .4 ; %  neutral - black
    -1, 'r'  , .3; % negative - red
    -2, 'r'  , .3; % negative - red
    -3, 'r' ,  .3}; % negative - red


for pID =  [3414  3367 3532 ] % you can add more PIDs to this to loop through all your participants
    
    % use string concatenation function strcat to specify exact data files
    fname=strcat(cd,'\data\MoInfAffectArray_', num2str(pID), '.csv');
    
    %read data using csvread command
    pData=csvread(fname);
    
    %store infant affect annotations and mom affect annotations in separate
    %variables
    
    infIndices= ~isnan(pData(:,4)); 
    infantData = pData(infIndices,:); %inf data located in column 4
    
    momData = pData(~(isnan(pData(:,3))),:); %mat data located in column 3
    
    figure (pID) %make a new figure for each participant
    
    %add "kebab lines" at the positions we will show each dimension of
    %mother and infant affect
    hold on
    plot([pData(1,1) pData(size(pData,1),2)], [.1 .1  ], 'k');
    plot([pData(1,1) pData(size(pData,1),2)], [ 0 0  ], 'k');
    plot([pData(1,1) pData(size(pData,1),2)], [-.1 -.1  ], 'k');
    
    plot([pData(1,1) pData(size(pData,1),2)], [.5 .5  ], 'k');
    plot([pData(1,1) pData(size(pData,1),2)], [.4 .4  ], 'k');
    plot([pData(1,1) pData(size(pData,1),2)], [.3 .3  ], 'k');
    
    %plot infant affect states
    for curAffectState= [ 1:3 ]   %looping through each infant affect state (i.e. positive, negative neutral)
        %get label and color + position info for this state of infant affect
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
    
    %plot mom affect states
    for curAffectState = [ 1:7] % looping through each mat affect state (i.e. seven values between +3 to -3)
        %get label, color and position info for the current maternal affect state
        curAffColor = momAffectColor{curAffectState,2};
        curAffValue = momAffectColor{curAffectState,1};
        curAxisPos = momAffectColor{curAffectState,3};
        
        %plot maternal affect for this state
        %grab all the event rows for this state of maternal affect
        indices = find(momData(:, 3)== curAffValue);
        dataRows = momData(indices,:);
        
        %count the number of affect events
        countRows = size(dataRows ,1);
        
        %for loop to plot all infant affect events of the current state
        for row = 1: countRows
            hold on
            plot(dataRows(row,[1 2]), [ curAxisPos curAxisPos], 'Color',curAffColor, 'LineWidth',10 )
        end
    end
    
    %make it pretty and save it
    axis([pData(1,1) pData(size(pData,1),2) -.4 .8])
    title(strcat('Mother-Infant Affect:', (num2str(pID))));
    
       
    savename=strcat(cd, '/data/P', num2str(pID), '_InfAffect');
    %  print('-depsc','-tiff','-r300',strcat(savename, '.eps')) %high quality
    saveas( gcf, char(strcat(savename,'.fig')));  %saves a matlab file
    saveas( gcf, char(strcat(savename,'.jpg')));  %saves a jpg
    
end
