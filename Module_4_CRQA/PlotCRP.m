function PlotCRP( rec )

% PlotCRP plots the chromatic cross-recurrence plot based on the cross-recurrence matrix rec.
% 
% 
% 

figure('Name','PlotCRP','NumberTitle','off')
colormap([1 0 0; 1 1 1; 0 0 1]);
pcolor(abs(rec-1));
shading flat; axis square;
title('Chromatic Cross-Recurrence Plot','FontSize',18,'FontName','Times New Roman')
xlabel('Time Series of PP1','FontSize',16,'FontName','Times New Roman');
ylabel('Time Series of PP2','FontSize',16,'FontName','Times New Roman');
