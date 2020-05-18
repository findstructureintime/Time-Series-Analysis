function annotationImport
% kaya de barbaro june 2018
% sample data courtesy of Dr.Sherryl Goodman at Emory University

% this script transforms the outputs of annotation software commonly used in psychology, such as Elan, DataVyu, Noldus, or Mangold Interact
% into a more usable format that can be easily worked with
% within Matlab. It saves the transformed data as a csv file that can be
% imported by other scripts in this module or otherwise.

%We will take as input sample data which contains all events for a single mother-infant pair
% it contains 10 columns, as follows: 
%Level, Description, Number,  % we will disregard the first three
%Onset_Time, Offset_Time, Duration_Time,  % col 4 & 5 are onsets and offsets
%Maternal Affect, Maternal Problem Data,  % col 7-10 correspond to 4 dimensions of annotations
% Infant Affect, Infant Problem Data 
% onset and offset data should be exported as seconds rather than hh:mm:ss
% format 

%we will store a numeric data array as a .csv file. it will contain six
%columns, as follows
% 1- event onset 
% 2- event offset
% 3 - maternal affect data (-3 to +3) 
% 4- infant affect data (-1 to +1)
% 5- mat problem data (0/1) 6- infant problem data (0/1)

%set data directory
dataDir = fullfile('.', 'data');

for pID = [3414  3367 3532 ] % [ 3011 3029 3292 3466 3569] % etc
    
    % construct the full file path
    fname = fullfile(dataDir, ['mangold_' num2str(pID), 'goodman.csv']);
    % using function fopen to open the data file
    fid = fopen(fname, 'r');
    
    %use the file read function textscan to import csvs with specified data types such as numbers and strings (ie letters and words)
    
    pDataTable = textscan(fid, '%d %s %d %f %f %f %f %s %s %s', 'delimiter',',', 'headerLines', 1);  % change delimeter if you have tab separated data,  or otherwise
      
    % now lets translate the table data into a event data format with
    % onsets as the first column, offsets as the second column and maternal
    % affect coding as the third column
    
    % onset and offset are in column 4 & 5 in the original Mangold data files
    pDataTime = cell2mat(pDataTable(:, 4:5));
    
    % maternal affect codes are in column 7
    pDataMaternalCodes = cell2mat(pDataTable(:, 7));
    
    % Combining onset and offst timestamps with maternal affect codes as
    % maternal affect events
    eventsMaternal = [pDataTime pDataMaternalCodes];
    
    
    % next, we will translate text-based annotations (such as those in the InfantAffect column)
    % into  numerical data. Specifically we will convert these as follows:      

    % 'A' (infant approach/ positive affect) -> +1
    % 'N' (infant neutral affect) -> 0 
    % 'W' ( infant withdrawal/ negative affect)  -> -1

    % Infant affect codes are in column 10
    pDataInfant = pDataTable{:, 10};
        
    % To do this, we use Matlab built-in function cellfun() to go through each 
    % cell in the infant affect code column and find cells with positive 
    % affect anntoations ('A') and convert them into numerical value 1.
    maskInfantPos = cellfun(@(code) strcmp(code, 'A'), pDataInfant, 'UniformOutput', false);
    maskInfantPos = vertcat(maskInfantPos{:});
    pDataInfantCodes = nan(size(pDataInfant));
    pDataInfantCodes(maskInfantPos) = 1;
    
    % using onset time, offset time and infant affect codes to create
    % infant affect event type data
    eventsInfant = [pDataTime pDataInfantCodes];
%     
    
    % Now we save maternal and infant affect events as csv files
    csvwrite(fullfile(dataDir, ['MaternalAffect_Events_',num2str(pID), '.csv']), eventsMaternal);
    
    csvwrite(fullfile(dataDir, ['InfantAffect_Events_',num2str(pID), '.csv']), eventsMaternal);
end


    


