function [ output ] = CRQA_out( rec )

% CRQA_out calculates recurrence measures for the non-diagonal line structures.
% Performs Anisotropic CRQA.
% 

addpath('lib');

minLine=2;

for transp=1:2
    
    if transp==1 rec=rec;
    else rec=rec';
    end
    
    rec=abs(rec); %Ignoring the different types of behavioral matched for now.
        
    [TTnot dist_L] = tt(rec); %Using 'tt' from the CRP-toolbox to calculate all vertical lines.
    freq_L = tabulate(dist_L);
    minL=find(freq_L(:,1)>=minLine,1,'first');
    TT = (sum(freq_L(minL:end,2).*freq_L(minL:end,1)))/sum(freq_L(minL:end,2));
    Max_L = freq_L(end,1);
    LAM = (sum(freq_L(minL:end,2).*freq_L(minL:end,1)))/nnz(rec);
    P_L = nonzeros(freq_L(minL:end,2)./sum(freq_L(minL:end,2))); Ent_L = -1*sum(P_L.*log(P_L));

    %% Make outputfile
    output(transp,1:4) = [LAM TT Max_L Ent_L];

end
