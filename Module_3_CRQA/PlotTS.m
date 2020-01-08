function PlotTS( PP1 , PP2 )

% PlotTS plots time series PP1 (in blue) and PP2 (in red) separately in a single figure window.
% 
% 

TSrange = [min(unique([PP1, PP2])) max(unique([PP1, PP2]))];

figure('Name','PlotTS','NumberTitle','off')
pp1 = subplot(2,1,1);
pp2 = subplot(2,1,2);

plot(pp1,PP1,'b','LineWidth',3)
title(pp1,'Time Series of PP1','FontSize',16,'FontName','Times New Roman')
xlabel(pp1,'Time Steps','FontSize',14,'FontName','Times New Roman');
ylabel(pp1,{['Behavioral Categories'];['( ' num2str(TSrange(1)) ' - ' num2str(TSrange(2)) ' )']},'FontSize',14,'FontName','Times New Roman');
axis(pp1,[1,length(PP1),TSrange(1),TSrange(2)]);
pp1.YTick = [TSrange(1):1:TSrange(2)];

plot(pp2,PP2,'r','LineWidth',3)
title(pp2,'Time Series of PP2','FontSize',16,'FontName','Times New Roman')
xlabel(pp2,'Time Steps','FontSize',14,'FontName','Times New Roman');
ylabel(pp2,{['Behavioral Categories'];['( ' num2str(TSrange(1)) ' - ' num2str(TSrange(2)) ' )']},'FontSize',14,'FontName','Times New Roman');
axis(pp2,[1,length(PP2),TSrange(1),TSrange(2)]);
pp2.YTick = [TSrange(1):1:TSrange(2)];
