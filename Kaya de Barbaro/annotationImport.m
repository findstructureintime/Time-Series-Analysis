function annotationImport
% kaya de barbaro june 2018
% video annotation data should include column headers . each row is an
% annotation. the order of the columns does not matter but you may need to edit the code to
% grab the correct columns. 

dataDir ='C:\Users\kdeba\Dropbox\Libraries\Documents\UT Austin\projects\Meeka Emory\Interact_files\';
saveDir='C:\Users\kdeba\Dropbox\Libraries\Documents\presentations\2018 ICIS\workshop';

for pID = [ 3011 ] % [ 3011 3029 ] 
    % listing all your pIDs here will loop through all the code below 
    %(until the "end" marker below ) for each participant 
    
    %for loop syntax
    
    % for x = [1 : 3]
    %      %  do WHATEVER; 
    % end
    
    
fname=strcat(dataDir, num2str(pID), 'goodman.csv');

%this time we will use the import function "readtable" because we need to
%import data that has both numbers and strings (ie letters and words)

pDataTable = readtable(fname,'Delimiter',',');  % change delimeter if you have tab separated data, e.g.


    % After data is imported in the table format, now we will store it in a
    % more generic array format. 
    % Below, we call the function table2array to make this conversion 

    %If relevant data columns will always be in the same order (e.g. across participants)
    %you can grab them simply by refering to their order. In our sample dataset, onset times
    % are always in column 5 and offset times in column 7, so we'll grab
    % all rows in those two columns 
    
        pData =[];
        pData = table2array(pDataTable(:,[5,7])); 

        %add four empty (NaN) columns to pData using matrix concatenation and the NaN function
        %matrix concatenation syntax is newstructure = [ piece one, piece two]
        %(and dimensions of the two pieces to be combined must match)
        %the NaN function syntax is: NaN(number of rows you want , number of columns you want)
        pData = [ pData , NaN(size(pData,1), 4)];
    
        
    %If relevant data columns are not always in the same order, tables allow you to grab them
    %by referring to them by name. We want to do this for maternal and
    %infant affect. 
    
        %this syntax says to put maternal affect into the third column of pData
        pData(:,3) = pDataTable.MaternalAffect;

        %You could use this same syntax for the onset and offset columns as
        %well, or any other numeric data. you cant use this syntax for
        %data columns that contain any strings - we'll deal with that next
    
    
    %our maternal Affect data is already numeric (+2 to -2) so we can just put it into
    %the pData array. 
    % but infant affect data is strings (ie letters) - which we need to
    % translate into numbers before putting them into pData
    
        %this code defines a new function we can use manipulate the cells in the table. 
        % you don't need to change this code
        cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));

        % 'A' is the annotation for infant positive affect
        % 'W' is the annotation for infant negative affect
        % 'N' is the annotation for infant neutral affect 

        %this code searches for the positive affect anntoations in the infant affect column of
        %pDataTable and returns the indices for the rows in which 'A' is found
        %(ie the Postitive affect indices)
        indicesPA  = find(cellfun(cellfind('A'),pDataTable.InfantAffect));

        % this code puts a numeric value (1) into those rows of pData where positive affect
        % was found. we will put them into column FOUR since that's the next
        % empty column. 
        pData(indicesPA, 4)=1;

        % this next line does the same thing as the previous two but is
        % combined into one statement
        % pData(find(cellfun(cellfind('A'),pDataTable.InfantAffect)), 7)= 1;

        %we'll use the shorthand version for neutral and negative affect but
        %you can always write out the long form as above
        pData(find(cellfun(cellfind('W'),pDataTable.InfantAffect)), 4)= -1;
        pData(find(cellfun(cellfind('N'),pDataTable.InfantAffect)), 4)= 0;

        % see also other possible variations, next data going into columns 5 and 6
        pData(find(cellfun(cellfind('XX'),pDataTable.MaternalProblemData)), 5)= 0;
        pData(find(cellfun(cellfind('U'),pDataTable.InfantProblemData)), 6)= 0;
       
        csvwrite(strcat(saveDir, '\MoInfAffectArray_',num2str(pID), '.csv'),pData);


end
        

    

    