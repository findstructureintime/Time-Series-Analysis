function [a_out, b_out, c_out]=tt(x)
% TT   Mean trapping time and its distribution.
%    A=TT(X) computes the mean of the length of the vertical line structures in a recurrence plot, so called trapping time TT.
%
%    [A B]=TT(X) computes the TT and the lengths of the found vertical lines, stored in B. In order to get the histogramme of the line lengths, simply call HIST(B,[1 MAX(B)]).
%
%    Examples: X = crp(rand(200,1),1,1,.3,'fan','silent');
%              [v v_dist] = tt(X);
%              hist(v_dist,200)
%

error(nargchk(1,1,nargin));
if nargout>3, error('Too many output arguments'), end
    
%a_out = NaN; b_out = NaN; c_out = NaN;

warning off
try

    if any(x(:))


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % for black vertical lines
        xb=double(x); 
        xb(end+1,:)=0;xb=double(xb(:));
        z=diff(xb);
        z0=find(z==1); % begin of black sequence
        z1=find(z==-1); % end of black sequence


        % measure the length of black lines
        if z0(1)>z1(1)
          z0(2:end+1,1)=z0(1:end);z0(1,1)=0;
          if length(z0)>length(z1) 
             z0(end)=[];
          end
        end

        t=sort(z1-z0);
        t1=t(find(t-1));


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % for white vertical lines
        for i = 1:size(x,2)
            i_ = find(x(:,i));
            i1 = min(i_); i2 = max(i_);
            x(1:i1,i) = 1;
            x(i2:end,i) = 1;
        end

        xw=double(x); xw(end+1,:)=1;
        zw=diff(xw(:));
        z0w=find(zw==-1); % begin of white sequence
        z1w=find(zw==1); % end of white sequence


        % measure the length of white lines
        if z0w(1)>z1w(1)
          z0w(1)=[]; 
          if length(z1w)>length(z0w) 
             z1w(end)=[];
          end
        end
        if length(z1w)>length(z0w) 
             z0w=[1;z0w];
        end

        tw=sort(z1w-z0w);
        t1w=tw(find(tw-1));

        if nargout==3
           c_out=zeros(length(tw),1);
           c_out=tw;
        end

        if nargout>=2
           b_out=zeros(length(t),1);
           b_out=t;
        end

        if nargout>0
           if isempty(t1), a_out=0;
           else, a_out=mean(t1); 
           end
        else
           mean(t1)
        end

    else

        if nargout==3
           c_out=NaN;
        end

        if nargout>=2
           b_out=NaN;
        end

        if nargout>0
           a_out=NaN;
        else
           NaN
        end

    end

    warning on

catch
    if nargout==3
        c_out=NaN;
    end

    if nargout>=2
        b_out=NaN;
    end

    if nargout>0
        a_out=NaN;
    else
        NaN
    end
end