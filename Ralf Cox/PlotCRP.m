function PlotCRP( rec )

% PlotCRP plots the cross-recurrence plot based on the cross-recurrence matrix rec.
% Performs Chromatic CRQA.
% 

figure('Name','PlotCRP','NumberTitle','off')
colormap([1 0 0; 1 1 1; 0 0 1]);
pcolor(abs(rec-1));
shading flat; axis square;
title('Chromatic CRP of PP1 and PP2','FontSize',20,'FontName','Times New Roman')
xlabel('PP1','FontSize',16,'FontName','Times New Roman');
ylabel('PP2','FontSize',16,'FontName','Times New Roman');
