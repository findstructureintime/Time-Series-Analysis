function plotSensorData

%this script plots data files from common mobile sensor outputs, in this example, from the empatica e4 device. 
%it can plot multiple Partipants of data. it translates a common format of time data for sensors, unix time format 
%(see https://en.wikipedia.org/wiki/Unix_time) into easier to work with matlab time formats. it uses subplots
%to plot three different physiological markers (heart rate, electrodermal activity (EDA) and motion (ACC) 
%into a single plot, and it uses link axes to connect the subplots when zooming or panning.

clearvars;
dataDir = fullfile('.', 'data');
subfolder = fullfile('.', 'libs');
addpath(subfolder);

savePlots =1;

for pNum=   [ 1 ] %  [ 2 3 4 5 7 ]  % % could add more participants to this array to loop through all ps in study 
    
    % load E4/ sensor data
    %initialize these variables
    data_HR =[];
    time_HR =[];
    
    data_ACC =[];
    time_ACC =[];
    
    data_EDA =[];
    time_EDA =[];
    
    anyE4= 0;
       
    fnameE4HR = fullfile(dataDir, ['E4_P', num2str(pNum)],'HR.csv');
    fnameE4EDA = fullfile(dataDir, ['E4_P', num2str(pNum)], 'EDA.csv');
    fnameE4ACC = fullfile(dataDir, ['E4_P', num2str(pNum)], 'ACC.csv');
    
    try
        [~,~,time_HR,data_HR] = E4_parse_physio(fnameE4HR); 
        time_HR = time_HR + (60*60*2); %add or subtract hours (in minutes) to adjust for timezone (hardcoded for central)
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
        [~,~,time_EDA,data_EDA] = E4_parse_physio(fnameE4EDA);
        time_EDA = time_EDA + (60*60*2);  %add or subtract hours (in minutes) to adjust for timezone (hardcoded for central)
        anyE4=1;
        
    catch
        warning(strcat('No EDA data for ', num2str(pNum)));
    end
    
    %make the plots
    figure(pNum)
    
    hold on
    
    if anyE4 ==1
        
        %plot the sensor data
        
        %  note that the sensor time arrays are all in unix time. 
        %we use the fuction unixtime2mat to transform the time vector from unix time to matlab time, this
        %will make the xaxis time labels easier to work with in matlab
        
        ax(1)= subplot(3,1,3);
        plot(unixtime2mat(time_ACC), data_ACC, 'Color', [0 0 .64])
        datetick('x', 'ddd HHPM') % here is where we are setting the xaxis labels for the time data - lots of display options if you search the datetick function
        ylabel('Acc')
        ylim([0 8])
  
        ax(2)= subplot(3,1, 2);
        plot(unixtime2mat(time_HR), data_HR, 'Color', [0 0 .64])
        datetick('x', 'ddd HHPM') 
        ylabel('HR')
        ylim([40 190])
        
        ax(3)= subplot(3,1, 1);
        plot(unixtime2mat(time_EDA), data_EDA, 'Color', [0 0 .64])
        ylabel('EDA')
        ylim([0 7])
        datetick('x', 'ddd HHPM')
        
        linkaxes(ax,'x'); 
        
        title(strcat('E4 EDA, HR, ACC: P', num2str(pNum)))
               
        
    end
    
    
    %save figs
    if savePlots ==1
        figure(pNum)
        savename = fullfile(dataDir, strcat('E4 data_ P', num2str(pNum)));
        %  print('-depsc','-tiff','-r300',strcat(savename, '.eps')) %high quality
        saveas( gcf, char(strcat(savename,'.fig')));  %saves a matlab file
        saveas( gcf, char(strcat(savename,'.jpg')));  %saves a jpg
        
    end
end



end


