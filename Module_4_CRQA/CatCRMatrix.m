function [ rec ] = CatCRMatrix( PP1 , PP2 )

% CatCRMatrix calculates the cross-recurrence matrix rec based on nominal time series PP1 and PP2.
% Categories of PP1 and PP2 range from 1 to 5.
% Two types of matches are defined, every other combination is non-matching. (For details see text.)
% 

for col=1:length(PP2)
    
    for row=1:length(PP1)
        
        if PP1(row,2)==4 && PP2(col,2)==4 rec(row,col)=1; %matching type 1 (DDI)
        elseif PP1(row,2)==5 && PP2(col,2)==5 rec(row,col)=1;
        elseif PP1(row,2)==4 && PP2(col,2)==1 rec(row,col)=-1; %matching type 2 (UDI)
        elseif PP1(row,2)==4 && PP2(col,2)==2 rec(row,col)=-1;
        elseif PP1(row,2)==4 && PP2(col,2)==3 rec(row,col)=-1;
        elseif PP1(row,2)==1 && PP2(col,2)==4 rec(row,col)=-1;
        elseif PP1(row,2)==2 && PP2(col,2)==4 rec(row,col)=-1;
        elseif PP1(row,2)==3 && PP2(col,2)==4 rec(row,col)=-1;
        else rec(row,col)=0; %non-matching (NDI)
        end
        
    end
    
end
