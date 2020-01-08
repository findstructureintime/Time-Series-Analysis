function [ output ] = CRQA_demo( rec )

% CRQA_demo calculates recurrence measures for the non-diagonal line structures.
% Performs Anisotropic CRQA.
% 

minLine=2;

for transp=1:2
    
    if transp==1 rec=rec;
    else rec=rec';
    end
    
    rec=abs(rec);
        
    [TTnot dist_L] = tt(rec); %Using 'tt' from the CRP-toolbox to calculate all vertical lines.
    freq_L = tabulate(dist_L);
    minL=find(freq_L(:,1)>=minLine,1,'first');
    TT = (sum(freq_L(minL:end,2).*freq_L(minL:end,1)))/sum(freq_L(minL:end,2));
    MaxL = freq_L(end,1);
    LAM = (sum(freq_L(minL:end,2).*freq_L(minL:end,1)))/nnz(rec);
    P_L = nonzeros(freq_L(minL:end,2)./sum(freq_L(minL:end,2))); ENT_L = -1*sum(P_L.*log(P_L));

    %% Make outputfile
    output(transp,1:4) = [LAM TT MaxL ENT_L];

end
