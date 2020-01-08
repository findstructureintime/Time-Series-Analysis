function [Allan] = allanfactor(fin, numint) 
%Calculates and plots allan factor for input train fin. For a poisson train, the AF should be 
%close to one as counting time is increased.  For real spike trains, however, it has been found
%that the AF increases as sqrt(i) in a linear manner, giving evidence of the fractal nature of
%the spike train (see chapter by Gabbiani and Koch, as well as papers by Teich).
%The allan factor is valid over a wider range of power law exponents than the fanno factor.
%FF is valid for 0< exp <1, while the AF is valid over 0< exp <3 (Teich et al, 1997, J Opt Soc Am A)
%data from our cultures appears to require an exponent greater than one, thus saturating the FF, but not
%the AF (personal communication with Ronen Segev, later confirmed by our experience).
%see also allanplotter
%JMB 03/18/02


%First approximation approach to getting FF (no sliding window)

%I. get mean spike count
 %numint = 100000;    %note that the ultimate value of FF depends on the interval size:
 af = zeros(1, numint);    %very small intervals lead to FF = 1, large intervals can lead to FF > 1
 mean = sum(fin)/numint;

%II. get Allan variance of spike count
 %get length of each interval
 int = floor(length(fin)/numint);

 %get variance
 tot = 0;
 for i=1:numint-1
     (i-1);
     tot = tot + ( sum(fin((i*int):((i+1)*int)))  -  sum(fin((((i-1)*int) + 1):(i*int))) )^2;
     af(i) = (tot/i)/(2*mean);
 end;
 
%III. calculate final Allan factor and plot Allan factor evolution over time
 Allan = af(numint-1);
 %figure
 %plot(af(1:numint-1));   
