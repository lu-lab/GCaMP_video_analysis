function [ ] = AutoAnalysisAfterGUI(dir, DataSet, saveFolder)

addpath(dir);
path = fullfile(dir, 'data');
strPath=addpath(path);
% for saving to excel
temp = split(dir, '\');
sheetName = temp{end};
varNames = {'Time'};
for i = 1:length(DataSet)
    varNames{i+1} = num2str(DataSet(i));
end

NumOfData=size(DataSet,2);
Data_DEL_Raw = [];
 %% for analyzed.mat
for i = DataSet 
        
    IndexData=find(DataSet==i);
    load(['vid_' num2str(i) '.mat']);
    load(['vid_' num2str(i) 'ALM_data_plots.mat']);
%     dataRRatio=vRedRatio_MeanDEL'; % for RFP DeltaR/R0
        data=vRatio2_MeanDEL'; % for gentle touch (has both green and red signals)
%     dataRROI=vRedROI_Mean'; % for RFP (AQ4277)
%     data=vGreenSub_MeanDEL'; % only has green signal
%       dataGRatio=vGreenRatio_MeanDEL
%       dataGROI=vGreenROI_Mean'; % f

    NumOfFrame=size(data,1);
    
    % Get data
    Data_DEL_Raw(1:length(data),IndexData)=data;
    
    Time(1:length(vTimes),IndexData)=vTimes;
 
    %% Smooth
    iGoLayLength = 21; % Savitzky–Golay filter legnth
    iGoLayPower = 3; % Savitzky-Golay filter power
    vMedCubic = sgolayfilt(data,iGoLayPower,iGoLayLength);
    data_Smooth=vMedCubic;
    Data_Smooth(1:length(data_Smooth),IndexData)=data_Smooth;

end

TimeMean=nanmean(Time,2);

save([path '\Analyzed.mat'], 'strPath', 'DataSet',...
    'Data_DEL_Raw','Time','TimeMean','Data_Smooth');

%% for RedRatio.mat
for i = DataSet
        
    IndexData=find(DataSet==i);
    load(['vid_' num2str(i) '.mat']);
    load(['vid_' num2str(i) 'ALM_data_plots.mat']);
    data=vRedRatio_MeanDEL'; % for RFP DeltaR/R0
    NumOfFrame=size(data,1);
        Data_DEL_Raw(1:length(data),IndexData)=data;

    Time(1:length(vTimes),IndexData)=vTimes;
 
    %% Smooth
    iGoLayLength = 21; % Savitzky–Golay filter legnth
    iGoLayPower = 3; % Savitzky-Golay filter power
    vMedCubic = sgolayfilt(data,iGoLayPower,iGoLayLength);
    data_Smooth=vMedCubic;
    Data_Smooth(1:length(data_Smooth),IndexData)=data_Smooth;
end

TimeMean=nanmean(Time,2);

% % % 
save([path '\Analyzed_RedRatio.mat'], 'strPath', 'DataSet',...
    'Data_DEL_Raw','Time','TimeMean','Data_Smooth');

filename = fullfile(saveFolder, 'RedRatio.xlsx');

saveStuff = array2table([TimeMean,Data_DEL_Raw(1:length(TimeMean),:)], 'VariableNames', varNames);
writetable(saveStuff,filename, 'Sheet', sheetName)

%% for GreenRatio
for i = DataSet
        
    IndexData=find(DataSet==i);
    load(['vid_' num2str(i) '.mat']);
    load(['vid_' num2str(i) 'ALM_data_plots.mat']);
%     data=vRedRatio_MeanDEL'; % for RFP DeltaR/R0
%         data=vRatio2_MeanDEL'; % for gentle touch (has both green and red signals)
%     data=vRedROI_Mean'; % for RFP (AQ4277)
%     data=vGreenSub_MeanDEL'; % only has green signal
      data=vGreenRatio_MeanDEL; % del F/F0
    NumOfFrame=size(data,1);
        Data_DEL_Raw(1:length(data),IndexData)=data;

    Time(1:length(vTimes),IndexData)=vTimes;
 
    %% Smooth
    iGoLayLength = 21; % Savitzky–Golay filter legnth
    iGoLayPower = 3; % Savitzky-Golay filter power
    vMedCubic = sgolayfilt(data,iGoLayPower,iGoLayLength);
    data_Smooth=vMedCubic;
    Data_Smooth(1:length(data_Smooth),IndexData)=data_Smooth;
end

TimeMean=nanmean(Time,2);

% % % 
save([path '\Analyzed_GreenRatio.mat'], 'strPath', 'DataSet',...
    'Data_DEL_Raw','Time','TimeMean','Data_Smooth');

filename = fullfile(saveFolder, 'GreenRatio.xlsx');
saveStuff = array2table([TimeMean,Data_DEL_Raw(1:length(TimeMean),:)], 'VariableNames', varNames);
writetable(saveStuff,filename, 'Sheet', sheetName)

%% for RedROI
for i = DataSet
        
    IndexData=find(DataSet==i);
    load(['vid_' num2str(i) '.mat']);
    load(['vid_' num2str(i) 'ALM_data_plots.mat']);
%     data=vRedRatio_MeanDEL'; % for RFP DeltaR/R0
%         data=vRatio2_MeanDEL'; % for gentle touch (has both green and red signals)
    data=vRedROI_Mean'; % for RFP (AQ4277)
%     data=vGreenSub_MeanDEL'; % only has green signal
    %   data=vGreenRatio_MeanDEL
    NumOfFrame=size(data,1);
        Data_DEL_Raw(1:length(data),IndexData)=data;

    Time(1:length(vTimes),IndexData)=vTimes;
 
    %% Smooth
    iGoLayLength = 21; % Savitzky–Golay filter legnth
    iGoLayPower = 3; % Savitzky-Golay filter power
    vMedCubic = sgolayfilt(data,iGoLayPower,iGoLayLength);
    data_Smooth=vMedCubic;
    Data_Smooth(1:length(data_Smooth),IndexData)=data_Smooth;
end

TimeMean=nanmean(Time,2);

% % % 
save([path '\Analyzed_RedROI.mat'], 'strPath', 'DataSet',...
    'Data_DEL_Raw','Time','TimeMean','Data_Smooth');

filename = fullfile(saveFolder, 'RedROI.xlsx');
saveStuff = array2table([TimeMean,Data_DEL_Raw(1:length(TimeMean),:)], 'VariableNames', varNames);
writetable(saveStuff,filename, 'Sheet', sheetName)


%% for GreenROI
for i = DataSet
        
    IndexData=find(DataSet==i);
    load(['vid_' num2str(i) '.mat']);
    load(['vid_' num2str(i) 'ALM_data_plots.mat']);
%     data=vRedRatio_MeanDEL'; % for RFP DeltaR/R0
%         data=vRatio2_MeanDEL'; % for gentle touch (has both green and red signals)
%     data=vRedROI_Mean'; % for RFP (AQ4277)
%     data=vGreenSub_MeanDEL'; % only has green signal
    %   data=vGreenRatio_MeanDEL
      data=vGreenROI_Mean'; % for RFP (AQ4277)

    NumOfFrame=size(data,1);
        Data_DEL_Raw(1:length(data),IndexData)=data;

    Time(1:length(vTimes),IndexData)=vTimes;
 
    %% Smooth
    iGoLayLength = 21; % Savitzky–Golay filter legnth
    iGoLayPower = 3; % Savitzky-Golay filter power
    vMedCubic = sgolayfilt(data,iGoLayPower,iGoLayLength);
    data_Smooth=vMedCubic;
    Data_Smooth(1:length(data_Smooth),IndexData)=data_Smooth;
end

TimeMean=nanmean(Time,2);

% % % 
save([path '\Analyzed_GreenROI.mat'], 'strPath', 'DataSet',...
    'Data_DEL_Raw','Time','TimeMean','Data_Smooth');

filename = fullfile(saveFolder, 'GreenROI.xlsx');
saveStuff = array2table([TimeMean,Data_DEL_Raw(1:length(TimeMean),:)], 'VariableNames', varNames);
writetable(saveStuff,filename, 'Sheet', sheetName)








