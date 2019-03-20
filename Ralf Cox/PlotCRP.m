function PlotCRP( rec )

% PlotCRP plots the cross-recurrence plot based on the cross-recurrence matrix rec.
% Performs Chromatic CRQA.
%

figure(2)
colormap([1 0 0; 1 1 1; 0 0 1]);
pcolor(abs(rec-1));
shading flat; axis square;
xlabel('PP1','FontSize',14,'FontName','Times New Roman');
ylabel('PP2','FontSize',14,'FontName','Times New Roman');
