function plotE4_simple

%this script takes mobile sensor data (from the empatica e4 device) and plots it with events. it manages unix timeformats which are very 
%commonly used and very useful for working with intensive longitudinal data (see %https://en.wikipedia.org/wiki/Unix_time) , it uses subplots to plot three
%different physiological markers (heart rate, electrodermal activity (EDA)
%and motion (ACC), and it uses link axes to connect the subplots when zooming or panning. 

dataDir ='C:\Users\kdeba\Dropbox\Libraries\Documents\presentations\2018 ICIS\workshop\final materials\Kaya materials\data\';
saveDir = 'C:\Users\kdeba\Dropbox\Libraries\Documents\presentations\2018 ICIS\workshop\final materials\Kaya materials\data\outputs\';

savePlots =1;
for pNum=   [ 1 ] %  [1015 1025 1035 1045 1055 1065 1075 1095 ...
    % 1105 1125 1145 1155 1165 1175 1185 1195  1205 1215 1235]  % use this longer array to cycle through
    % each particpant to automatically make a figure for each one
    
    % load E4/ sensor data
    
    data_HR =[];
    time_HR =[];
    
    data_ACC =[];
    time_ACC =[];
    
    data_EDA =[];
    time_EDA =[];
    
    anyE4= 0;
       
    fnameE4HR=strcat(dataDir,'E4_P', num2str(pNum),'\HR.csv');
    fnameE4EDA=strcat(dataDir,'E4_P', num2str(pNum), '\EDA.csv');
    fnameE4ACC=strcat(dataDir,'E4_P', num2str(pNum), '\ACC.csv');
    
    try
        [~,~,time_HR,data_HR] = E4_parse_physio(fnameE4HR); 
        time_HR = time_HR + (60*60*2); %add two hours (in minutes) to adjust for timezone
        anyE4 =1;
    catch
        warning(strcat('No HR data for P', num2str(pNum)));
    end
    
    try
        [~,time_ACC,data_ACC] = E4_parse_acc(fnameE4ACC);

        time_ACC = time_ACC + (60*60*2); %add or subtract hours (in minutes) to adjust for timezone (hardcoded for central)
        anyE4=1;
    catch
        warning(strcat('No ACC data for P',num2str(pNum)));
    end
    
    try
        [~,~,time_EDA,data_EDA] = E4_parse(fnameE4EDA);
        time_EDA = time_EDA + (60*60*2);  %add or subtract hours (in minutes) to adjust for timezone (hardcoded for central)
      %  data_EDA = data_EDA*10; % if you want to rescale this data
        anyE4=1;
    catch
        warning(strcat('No EDA data for ', num2str(pNum)));
    end
    
    %make the plots
    figure(pNum)
    
    hold on
    
    if anyE4 ==1
        
        %  in our plot commands below we will translate the time vector from unix time to matlab time, this
        %will make the xaxis time labels easier to work with /make nice (ie
        %providing day and hour labels)
        
        ax(1)= subplot(3,1,3);
        plot(unixtime2mat(time_ACC), data_ACC, 'Color', [0 0 .64])
        datetick('x', 'ddd HHPM') % here is where we are setting the xaxis labels for the time data - lots of display options if you search the datetick function
        ylabel('Acc')
        ylim([0 8])
  
        ax(2)= subplot(3,1, 2);
        plot(unixtime2mat(time_HR), data_HR, 'Color', [0 0 .64])
        datetick('x', 'ddd HHPM') % here is where we are setting the xaxis labels for the time data - lots of display options if you search the datetick function
        ylabel('HR')
        ylim([40 190])
        
        ax(3)= subplot(3,1, 1);
        plot(unixtime2mat(time_EDA), data_EDA, 'Color', [0 0 .64])
        ylabel('EDA')
        ylim([0 7])
        datetick('x', 'ddd HHPM')
        
        linkaxes(ax,'x');
        
        title(strcat('E4 EDA, HR, ACC: P', num2str(pNum), ', talk at noon'))
        
       
        
    end
    
    
    %save figs
    if savePlots ==1
        figure(pNum)
        savename=strcat(saveDir, strcat('E4 data_ P', num2str(pNum)));
        %  print('-depsc','-tiff','-r300',strcat(savename, '.eps')) %high quality
        saveas( gcf, char(strcat(savename,'.fig')));  %saves a matlab file
        saveas( gcf, char(strcat(savename,'.jpg')));  %saves a jpg
        
    end
end



end


