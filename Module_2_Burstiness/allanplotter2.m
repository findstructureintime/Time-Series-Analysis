function [actual, abcis] = allanplotter(fin, binwidth)
% calculates allan factor over a range of window sizes, given by powers.
% takes a binary input train, fin. Also takes binwidth of the data, in seconds Ex: 0.004 (= 4ms)
% checks actual allan factor against shuffled data, which should have no long-term correlations.
% uses allanfactor (which see)
% to create fin from actual raster data, see the first few lines of IEIplotter
% Ex: [actual, shuf, abcis] = allanplotter(TIMERASTER(32,:), 0.004)
% actual are the allan factors from actual data
% shuf are the allan factors from shuffled data
% abcis are the sizes of the counting windows (the x-axis is the abcissa), given in seconds
% JMB 03/19/02

powers = 10; %powers and base set the number of divisions in the recording time. base^powers = max number of divisions
base = 2;   %in the time period. Ex: length of fin = 3600 s; 2^16 = 65536 divisions; 1 division = 3600/65536 = 0.0549 sec 
start = 2;  %the minimum number of divisions should be at least 10. Otherwise, the Allan factor is invalid.
            %As the number of divisions increases, the AF should approach unity.  For fewer divisions, AF may 
            %exceed unity, in which case it suggests a fractal nature.  See papers by Teich. 
            %CONSTRAINTS: base^start >= 10; base^powers < length(fin)
            
Allan1 = zeros(1, length(start:powers));
count = 1;
for i=start:powers
    abcissa(count) = base^(i);
    Allan1(count) = allanfactor(fin, base^(i));
    count = count + 1;
end;

%figure;
%plot([powers:-1:start], Allan1, 'r');

len = length(abcissa);
for i=1:len
    actual(i) = Allan1(len + 1 - i);
    abcis(i) = (length(fin)*binwidth)/abcissa(len + 1 - i);
end;

%plot data on log-log scales
%figure;
%loglog(abcis, actual, 'r');

%1/sample rate will give you the units of your sample rate
