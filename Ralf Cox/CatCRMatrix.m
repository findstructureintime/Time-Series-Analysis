function [ rec ] = CatCRMatrix( PP1 , PP2 )

% CatCRMatrix calculates the cross-recurrence matrix based on time series PP1 and PP2.
%
%

for col=1:length(PP2)
    
    for row=1:length(PP1)
        
        if PP1(row)==4 && PP2(col)==4 rec(row,col)=1; % matching type 1
        elseif PP1(row)==5 && PP2(col)==5 rec(row,col)=1;
        elseif PP1(row)==4 && PP2(col)==1 rec(row,col)=-1; % matching type 2
        elseif PP1(row)==4 && PP2(col)==2 rec(row,col)=-1;
        elseif PP1(row)==4 && PP2(col)==3 rec(row,col)=-1;
        elseif PP1(row)==1 && PP2(col)==4 rec(row,col)=-1;
        elseif PP1(row)==2 && PP2(col)==4 rec(row,col)=-1;
        elseif PP1(row)==3 && PP2(col)==4 rec(row,col)=-1;
        else rec(row,col)=0; % non-matching (every other combination)
        end
        
    end
    
end
