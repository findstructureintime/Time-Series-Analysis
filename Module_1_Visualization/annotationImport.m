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
% 1- event onset 2- event offset
%3 - maternal affect data (-3 to +3) 
% 4- infant affect data (-1 to +1)
% 5- mat problem data (0/1) 6- infant problem data (0/1)

%set data directory
dataDir =(strcat (cd, '\data\'));

for pID = [3414  3367 3532 ] % [ 3011 3029 3292 3466 3569] % etc
    
    fname=strcat(dataDir, num2str(pID), 'goodman.csv');
    
    %use the import function "readtable" to import csvs with both numbers and strings (ie letters and words)
    pDataTable = readtable(fname,'Delimiter',',');  % change delimeter if you have tab separated data,  or otherwise
      
    % now lets translate the table data into a more generic array format
    % that is much easier to work with
    
    %initialize a new array where we will store this P data
    pData =[];
    
    % onset and offset will always be in rows 4 & 5 
    % use table2array to directly transfer them
    pData = table2array(pDataTable(:,[4,5]));
    
    %add four empty (NaN) columns to pData using matrix concatenation and the NaN function
    pData = [ pData , NaN(size(pData,1), 4)];
    
    % numerical data can be directly imported into a table
    % here we refer to the column via column header rather than relative
    % position
    pData(:,3) = pDataTable.MaternalAffect;
    
    
    % next, we will translate text-based annotations (such as those in the InfantAffect column)
    % into  numerical data. Specifically we will convert these as follows:      

    % 'A' (infant approach/ positive affect) -> +1
    % 'N' (infant neutral affect) -> 0 
    % 'W' ( infant withdrawal/ negative affect)  -> -1

    % define a function to search for annotations
    cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));
        
    %find indices of positive affect anntoations in the infant affect column
    indicesPA  = find(cellfun(cellfind('A'),pDataTable.InfantAffect));  % 'A' is the annotation for infant positive affect
    
    % place our chosen value into to the corresponding rows of fourth column of pData!
    pData(indicesPA, 4)=1;
    
    % here we do the same for the other two annotations, but more efficiently in one line
    pData(find(cellfun(cellfind('W'),pDataTable.InfantAffect)), 4)= -1;
    pData(find(cellfun(cellfind('N'),pDataTable.InfantAffect)), 4)= 0;
    
    % here we tranfer over the data from the Problem Data columns 
    pData(find(cellfun(cellfind('XX'),pDataTable.MaternalProblemData)), 5)= 1;
    pData(find(cellfun(cellfind('U'),pDataTable.InfantProblemData)), 6)= 1;
    
    
    %the pData array is complete!
    % save it in a csv file 
    csvwrite(strcat(dataDir, '\MoInfAffectArray_',num2str(pID), '.csv'),pData);
    
    
end


    


