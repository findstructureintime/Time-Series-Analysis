function [ output1 , output2 ] = CRQA_out( rec )

% CRQA_out calculates recurrence measures for the non-diagonal line structures.
% Performs Chromatic CRQA.
% Performs Anisotropic CRQA. (Ignoring the different types of behavioral matches.)
% 

addpath('lib');

minLine=2;
Size=size(rec,1);

%% Anisotropic CRQA

[rp,cp,vp]=find(rec==+1); RR(1)=length(vp)/(Size*Size);
[rn,cn,vn]=find(rec==-1); RR(2)=length(vn)/(Size*Size);

output1 = [RR' RR'./sum(RR)];

%% Anisotropic CRQA

for transp=1:2 %For calculations on horizontal and vertical patterns
    
    if transp==1 rec=rec;
    else rec=rec';
    end
    
    rec=abs(rec); %Treating behavioral matches as equal.
        
    [TTnot dist_L] = tt(rec); %Using 'tt' from the crp toolbox to calculate all vertical lines.
    freq_L = tabulate(dist_L);
    minL=find(freq_L(:,1)>=minLine,1,'first');
    TT = (sum(freq_L(minL:end,2).*freq_L(minL:end,1)))/sum(freq_L(minL:end,2));
    Max_L = freq_L(end,1);
    LAM = (sum(freq_L(minL:end,2).*freq_L(minL:end,1)))/nnz(rec);
    P_L = nonzeros(freq_L(minL:end,2)./sum(freq_L(minL:end,2))); Ent_L = -1*sum(P_L.*log(P_L));

    %% Make outputfile
    output2(transp,1:4) = [LAM TT Max_L Ent_L];

end
