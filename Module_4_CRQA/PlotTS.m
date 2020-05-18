function PlotTS( PP1 , PP2 )

% PlotTS plots time series PP1 and PP2 separately in a single figure window.
% 
% 
% 

y_range = [min(unique([PP1(:,2), PP2(:,2)])) max(unique([PP1(:,2), PP2(:,2)]))];
x_range = [min(unique([PP1(:,1), PP2(:,1)])) max(unique([PP1(:,1), PP2(:,1)]))];

figure('Name','PlotTS','NumberTitle','off')
pp1 = subplot(2,1,1);
pp2 = subplot(2,1,2);

plot(pp1,PP1(:,1),PP1(:,2),'k','LineWidth',3)
title(pp1,'Time Series of PP1','FontSize',18,'FontName','Times New Roman')
xlabel(pp1,'Time Steps','FontSize',16,'FontName','Times New Roman');
ylabel(pp1,{['Behavioral Categories'];['( ' num2str(y_range(1)) ' - ' num2str(y_range(2)) ' )']},'FontSize',16,'FontName','Times New Roman');
axis(pp1,[x_range(1) x_range(2) y_range(1) y_range(2)]);
%pp1.YTick = [y_range(1):1:y_range(2)];

plot(pp2,PP2(:,1),PP2(:,2),'k','LineWidth',3)
title(pp2,'Time Series of PP2','FontSize',18,'FontName','Times New Roman')
xlabel(pp2,'Time Steps','FontSize',16,'FontName','Times New Roman');
ylabel(pp2,{['Behavioral Categories'];['( ' num2str(y_range(1)) ' - ' num2str(y_range(2)) ' )']},'FontSize',16,'FontName','Times New Roman');
axis(pp2,[x_range(1) x_range(2) y_range(1) y_range(2)]);
%pp2.YTick = [y_range(1):1:y_range(2)];
