% Shuffle data
%
% Usage: shuffled = shuffle(Data)
% 
% - Data - A single column of data points
%
% RM-course Advanced Data Analysis
% Module Dynamical and Nonlinear Data analysis and Modeling 
% 
% May 2008
% Fred Hasselman & Ralf Cox

function [shuffled] = shuffle(Data)

[rows,column]=size(Data);

if column > 1 
    disp('This script shuffles one column of data, there are more columns in the Data variable.)');
    pause;
    return
end

rindex = randperm(length(Data(:,column)));
rindex = rindex';
ori_stream = Data(:,column);
rand_stream = zeros(length(ori_stream),1);
for i=1:length(ori_stream)
    num = ori_stream(rindex(i));
    rand_stream(i) = num;
end
shuffled(:,column) = rand_stream(:);