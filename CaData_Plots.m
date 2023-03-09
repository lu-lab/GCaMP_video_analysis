function CaData_Plots(strPath,strVidName,strDescriptor)
% Description:             Finds the AWD neuron in images in a folder
% Inputs:                  None
% Outputs:                 None
% Author:                  Daniel A. Porto (dporto3@gatech.edu)
% Date Last modified:      April 5, 2014

%% Inputs and Parameters
if nargin<1 || isempty(strPath)
    [strFile, strPath] = uigetfile;
    strData = [strPath, strFile];
end


strData = [strPath 'data\' strVidName strDescriptor '_data.mat'];
strVidName2 = strVidName;
% strVidName2(4) = [];
strVid = [strPath strVidName2 '.mat'];
load(strData)
load(strVid)
%vTimes = linspace(0, 40, 318)';
iStartFrame = sum(vTimes<10);

% vTimes = [vTimes; NaN];

%% Raw I Vectors

pFig1 = figure(1);

subplot(4,2,1)
hold off
plot(vTimes,vGreenROI_Mean)
title('Green ROI (Mean)')
xlabel('Time (s)');
ylabel('Intensity (A.U.)');

subplot(4,2,2)
hold off
plot(vTimes,vRedROI_Mean)
title('Red ROI (Mean)')
xlabel('Time (s)');
ylabel('Intensity (A.U.)');

subplot(4,2,3)
hold off
plot(vTimes,vGreenBack_Mean)
title('Green Back (Mean)')
xlabel('Time (s)');
ylabel('Intensity (A.U.)');

subplot(4,2,4)
hold off
plot(vTimes,vRedBack_Mean)
title('Red Back (Mean)')
xlabel('Time (s)');
ylabel('Intensity (A.U.)');

subplot(4,2,5)
hold off
plot(vTimes,vGreenROI_Max)
title('Green ROI (Max)')
xlabel('Time (s)');
ylabel('Intensity (A.U.)');

subplot(4,2,6)
hold off
plot(vTimes,vRedROI_Max)
title('Red ROI (Max)')
xlabel('Time (s)');
ylabel('Intensity (A.U.)');

subplot(4,2,7)
hold off
plot(vTimes,vGreenBack_Max)
title('Green Back (Max)')
xlabel('Time (s)');
ylabel('Intensity (A.U.)');

subplot(4,2,8)
hold off
plot(vTimes,vRedBack_Max)
title('Red Back (Max)')
xlabel('Time (s)');
ylabel('Intensity (A.U.)');


% saveas(pFig1,[strData(1:end-4) '_I']);


%% F Vectors (Background Corrected)

%Ratio Vectors
vGreenRatio_Mean = vGreenROI_Mean./vGreenBack_Mean;
vGreenRatio_Max = vGreenROI_Max./vGreenBack_Max;
vRedRatio_Mean = vRedROI_Mean./vRedBack_Mean;
vRedRatio_Max = vRedROI_Max./vRedBack_Max;

%Sub Vectors
vGreenSub_Mean = vGreenROI_Mean-vGreenBack_Mean;
vGreenSub_Max = vGreenROI_Max-vGreenBack_Max;
vRedSub_Mean = vRedROI_Mean-vRedBack_Mean;
vRedSub_Max = vRedROI_Max-vRedBack_Max;

%Plot

pFig2 = figure(2);

subplot(4,2,1)
hold off
plot(vTimes,vGreenRatio_Mean)
title('Green F (Mean)')
xlabel('Time (s)');
ylabel('F (A.U.)');

subplot(4,2,2)
hold off
plot(vTimes,vRedRatio_Mean)
title('Red F (Mean)')
xlabel('Time (s)');
ylabel('F (A.U.)');

subplot(4,2,3)
hold off
plot(vTimes,vGreenSub_Mean)
title('Green F_sub (Mean)')
xlabel('Time (s)');
ylabel('F (A.U.)');

subplot(4,2,4)
hold off
plot(vTimes,vRedSub_Mean)
title('Red F_sub (Mean)')
xlabel('Time (s)');
ylabel('F (A.U.)');

subplot(4,2,5)
hold off
plot(vTimes,vGreenRatio_Max)
title('Green F (Max)')
xlabel('Time (s)');
ylabel('F (A.U.)');

subplot(4,2,6)
hold off
plot(vTimes,vRedRatio_Max)
title('Red F (Max)')
xlabel('Time (s)');
ylabel('F (A.U.)');

subplot(4,2,7)
hold off
plot(vTimes,vGreenSub_Max)
title('Green F_sub (Max)')
xlabel('Time (s)');
ylabel('F (A.U.)');

subplot(4,2,8)
hold off
plot(vTimes,vRedSub_Max)
title('Red F_sub (Max)')
xlabel('Time (s)');
ylabel('F (A.U.)');


% saveas(pFig2,[strData(1:end-4) '_F']);


%% R (Ratio Vectors)

vRatio1_Mean = vGreenROI_Mean - vRedROI_Mean;
vRatio1_Max = vGreenROI_Max - vRedROI_Max;

vRatio2_Mean = vGreenROI_Mean./vRedROI_Mean;
vRatio2_Max = vGreenROI_Max./vRedROI_Max;

vRatio3_Mean = (vGreenROI_Mean-vRedROI_Mean)-(vGreenBack_Mean-vRedBack_Mean);
vRatio3_Max = (vGreenROI_Max-vRedROI_Max)-(vGreenBack_Max-vRedBack_Max);

vRatio4_Mean = (vGreenROI_Mean-vGreenBack_Mean)./(vRedROI_Mean-vRedBack_Mean);
vRatio4_Max = (vGreenROI_Max-vGreenBack_Max)./(vRedROI_Max-vRedBack_Max);

vRatio5_Mean = (vGreenROI_Mean-vRedROI_Mean)./(vGreenBack_Mean-vRedBack_Mean);
vRatio5_Max = (vGreenROI_Max-vRedROI_Max)./(vGreenBack_Max-vRedBack_Max);

vRatio6_Mean = (vGreenROI_Mean./vGreenBack_Mean)./(vRedROI_Mean./vRedBack_Mean);
vRatio6_Max = (vGreenROI_Max./vGreenBack_Max)./(vRedROI_Max./vRedBack_Max);

% Plots

pFig3 = figure(3);
subplot(3,2,1)
hold off
plot(vTimes,vRatio1_Mean)
title('R = G_R_O_I - R_R_O_I')
xlabel('Time (s)');
ylabel('R (A.U.)');

subplot(3,2,2)
hold off
plot(vTimes,vRatio2_Mean)
title('R = G_R_O_I/R_R_O_I')
xlabel('Time (s)');
ylabel('R (A.U.)');

subplot(3,2,3)
hold off
plot(vTimes,vRatio3_Mean)
title('R = (G_R_O_I-G_B_a_c_k)-(R_R_O_I-R_B_a_c_k)')
xlabel('Time (s)');
ylabel('R (A.U.)');

subplot(3,2,4)
hold off
plot(vTimes,vRatio4_Mean)
title('R = (G_R_O_I-G_B_a_c_k)/(R_R_O_I-R_B_a_c_k)')
xlabel('Time (s)');
ylabel('R (A.U.)');

subplot(3,2,5)
hold off
plot(vTimes,vRatio5_Mean)
title('R = (G_R_O_I-R_R_O_I)/(G_B_a_c_k-R_B_a_c_k)')
xlabel('Time (s)');
ylabel('R (A.U.)');

subplot(3,2,6)
hold off
plot(vTimes,vRatio6_Mean)
title('(G_R_O_I/G_B_a_c_k)/(R_R_O_I/R_B_a_c_k)')
xlabel('Time (s)');
ylabel('R (A.U.)');

% saveas(pFig3,[strData(1:end-4) '_R_mean']);

pFig4 = figure(4);
title('Max')
subplot(3,2,1)
hold off
plot(vTimes,vRatio1_Max)
title('R = G_R_O_I - R_R_O_I')
xlabel('Time (s)');
ylabel('R (A.U.)');

subplot(3,2,2)
hold off
plot(vTimes,vRatio2_Max)
title('R = G_R_O_I/R_R_O_I')
xlabel('Time (s)');
ylabel('R (A.U.)');

subplot(3,2,3)
hold off
plot(vTimes,vRatio3_Max)
title('R = (G_R_O_I-G_B_a_c_k)-(R_R_O_I-R_B_a_c_k)')
xlabel('Time (s)');
ylabel('R (A.U.)');

subplot(3,2,4)
hold off
plot(vTimes,vRatio4_Max)
title('R = (G_R_O_I-G_B_a_c_k)/(R_R_O_I-R_B_a_c_k)')
xlabel('Time (s)');
ylabel('R (A.U.)');

subplot(3,2,5)
hold off
plot(vTimes,vRatio5_Max)
title('R = (G_R_O_I-R_R_O_I)/(G_B_a_c_k-R_B_a_c_k)')
xlabel('Time (s)');
ylabel('R (A.U.)');

subplot(3,2,6)
hold off
plot(vTimes,vRatio6_Max)
title('(G_R_O_I/G_B_a_c_k)/(R_R_O_I/R_B_a_c_k)')
xlabel('Time (s)');
ylabel('R (A.U.)');

% saveas(pFig4,[strData(1:end-4) '_R_max']);

%% Delta I/Io

% Baseline Values
iGreenROI_Mean_Base = nanmean(vGreenROI_Mean(1:iStartFrame));
iGreenBack_Mean_Base = nanmean(vGreenBack_Mean(1:iStartFrame));
iGreenROI_Max_Base = nanmean(vGreenROI_Max(1:iStartFrame));
iGreenBack_Max_Base = nanmean(vGreenBack_Max(1:iStartFrame));

iRedROI_Mean_Base = nanmean(vRedROI_Mean(1:iStartFrame));
iRedBack_Mean_Base = nanmean(vRedBack_Mean(1:iStartFrame));
iRedROI_Max_Base = nanmean(vRedROI_Max(1:iStartFrame));
iRedBack_Max_Base = nanmean(vRedBack_Max(1:iStartFrame));

% Divide by Base Value
vGreenROI_MeanDEL = (vGreenROI_Mean-iGreenROI_Mean_Base)./iGreenROI_Mean_Base;
vGreenBack_MeanDEL = (vGreenBack_Mean-iGreenBack_Mean_Base)./iGreenBack_Mean_Base;
vGreenROI_MaxDEL = (vGreenROI_Max-iGreenROI_Max_Base)./iGreenROI_Max_Base;
vGreenBack_MaxDEL = (vGreenBack_Max-iGreenBack_Max_Base)./iGreenBack_Max_Base;

vRedROI_MeanDEL = (vRedROI_Mean-iRedROI_Mean_Base)./iRedROI_Mean_Base;
vRedBack_MeanDEL = (vRedBack_Mean-iRedBack_Mean_Base)./iRedBack_Mean_Base;
vRedROI_MaxDEL = (vRedROI_Max-iRedROI_Max_Base)./iRedROI_Max_Base;
vRedBack_MaxDEL = (vRedBack_Max-iRedBack_Max_Base)./iRedBack_Max_Base;

% Plots

pFig5 = figure(5);

subplot(4,2,1)
hold off
plot(vTimes,vGreenROI_MeanDEL)
title('Green ROI (Mean)')
xlabel('Time (s)');
ylabel('\Delta I/I_0');

subplot(4,2,2)
hold off
plot(vTimes,vRedROI_MeanDEL)
title('Red ROI (Mean)')
xlabel('Time (s)');
ylabel('\Delta I/I_0');

subplot(4,2,3)
hold off
plot(vTimes,vGreenBack_MeanDEL)
title('Green Back (Mean)')
xlabel('Time (s)');
ylabel('\Delta I/I_0');

subplot(4,2,4)
hold off
plot(vTimes,vRedBack_MeanDEL)
title('Red Back (Mean)')
xlabel('Time (s)');
ylabel('\Delta I/I_0');

subplot(4,2,5)
hold off
plot(vTimes,vGreenROI_MaxDEL)
title('Green ROI (Max)')
xlabel('Time (s)');
ylabel('\Delta I/I_0');

subplot(4,2,6)
hold off
plot(vTimes,vRedROI_MaxDEL)
title('Red ROI (Max)')
xlabel('Time (s)');
ylabel('\Delta I/I_0');

subplot(4,2,7)
hold off
plot(vTimes,vGreenBack_MaxDEL)
title('Green Back (Max)')
xlabel('Time (s)');
ylabel('\Delta I/I_0');

subplot(4,2,8)
hold off
plot(vTimes,vRedBack_MaxDEL)
title('Red Back (Max)')
xlabel('Time (s)');
ylabel('\Delta I/I_0');

% saveas(pFig5,[strData(1:end-4) '_DelI_Io']);


%% Delta F/Fo

% Baseline Values
iGreenRatio_Mean_Base = nanmean(vGreenRatio_Mean(1:iStartFrame));
iGreenRatio_Max_Base = nanmean(vGreenRatio_Max(1:iStartFrame));
iRedRatio_Mean_Base = nanmean(vRedRatio_Mean(1:iStartFrame));
iRedRatio_Max_Base = nanmean(vRedRatio_Max(1:iStartFrame));

iGreenSub_Mean_Base = nanmean(vGreenSub_Mean(1:iStartFrame));
iGreenSub_Max_Base = nanmean(vGreenSub_Max(1:iStartFrame));
iRedSub_Mean_Base = nanmean(vRedSub_Mean(1:iStartFrame));
iRedSub_Max_Base = nanmean(vRedSub_Max(1:iStartFrame));

% Divide by Base Value
vGreenRatio_MeanDEL = (vGreenRatio_Mean - iGreenRatio_Mean_Base)./iGreenRatio_Mean_Base;
vGreenRatio_MaxDEL = (vGreenRatio_Max-iGreenRatio_Max_Base)./iGreenRatio_Max_Base;
vRedRatio_MeanDEL = (vRedRatio_Mean-iRedRatio_Mean_Base)./iRedRatio_Mean_Base;
vRedRatio_MaxDEL = (vRedRatio_Max-iRedRatio_Max_Base)./iRedRatio_Max_Base;

vGreenSub_MeanDEL = (vGreenSub_Mean - iGreenSub_Mean_Base)./iGreenSub_Mean_Base;
vGreenSub_MaxDEL = (vGreenSub_Max-iGreenSub_Max_Base)./iGreenSub_Max_Base;
vRedSub_MeanDEL = (vRedSub_Mean-iRedSub_Mean_Base)./iRedSub_Mean_Base;
vRedSub_MaxDEL = (vRedSub_Max-iRedSub_Max_Base)./iRedSub_Max_Base;

%Plot

pFig6 = figure(6);


subplot(4,2,1)
hold off
plot(vTimes,vGreenRatio_MeanDEL)
title('Green F (Mean)')
xlabel('Time (s)');
ylabel('\Delta F/F_0');

subplot(4,2,2)
hold off
plot(vTimes,vRedRatio_MeanDEL)
title('Red F (Mean)')
xlabel('Time (s)');
ylabel('\Delta F/F_0');

subplot(4,2,3)
hold off
plot(vTimes,vGreenSub_MeanDEL)
title('Green F_sub (Mean)')
xlabel('Time (s)');
ylabel('\Delta F/F_0');

subplot(4,2,4)
hold off
plot(vTimes,vRedSub_MeanDEL)
title('Red F_sub (Mean)')
xlabel('Time (s)');
ylabel('\Delta F/F_0');

subplot(4,2,5)
hold off
plot(vTimes,vGreenRatio_MaxDEL)
title('Green F (Max)')
xlabel('Time (s)');
ylabel('\Delta F/F_0');

subplot(4,2,6)
hold off
plot(vTimes,vRedRatio_MaxDEL)
title('Red F (Max)')
xlabel('Time (s)');
ylabel('\Delta F/F_0');

subplot(4,2,7)
hold off
plot(vTimes,vGreenSub_MaxDEL)
title('Green F_sub (Max)')
xlabel('Time (s)');
ylabel('\Delta F/F_0');

subplot(4,2,8)
hold off
plot(vTimes,vRedSub_MaxDEL)
title('Red F_sub (Max)')
xlabel('Time (s)');
ylabel('\Delta F/F_0');

% saveas(pFig6,[strData(1:end-4) '_DelF_Fo']);

%% Delta R/Ro

%Baseline Values
iRatio1_Mean_Base = nanmean(vRatio1_Mean(1:iStartFrame));
iRatio1_Max_Base = nanmean(vRatio1_Max(1:iStartFrame));
iRatio2_Mean_Base = nanmean(vRatio2_Mean(1:iStartFrame));
iRatio2_Max_Base = nanmean(vRatio2_Max(1:iStartFrame));
iRatio3_Mean_Base = nanmean(vRatio3_Mean(1:iStartFrame));
iRatio3_Max_Base = nanmean(vRatio3_Max(1:iStartFrame));
iRatio4_Mean_Base = nanmean(vRatio4_Mean(1:iStartFrame));
iRatio4_Max_Base = nanmean(vRatio4_Max(1:iStartFrame));
iRatio5_Mean_Base = nanmean(vRatio5_Mean(1:iStartFrame));
iRatio5_Max_Base = nanmean(vRatio5_Max(1:iStartFrame));
iRatio6_Mean_Base = nanmean(vRatio6_Mean(1:iStartFrame));
iRatio6_Max_Base = nanmean(vRatio6_Max(1:iStartFrame));

%Divide by Base Values
vRatio1_MeanDEL = (vRatio1_Mean-iRatio1_Mean_Base)./iRatio1_Mean_Base;
vRatio1_MaxDEL = (vRatio1_Max-iRatio1_Max_Base)./iRatio1_Max_Base;
vRatio2_MeanDEL = (vRatio2_Mean-iRatio2_Mean_Base)./iRatio2_Mean_Base;
vRatio2_MaxDEL = (vRatio2_Max-iRatio2_Max_Base)./iRatio2_Max_Base;
vRatio3_MeanDEL = (vRatio3_Mean-iRatio3_Mean_Base)./iRatio3_Mean_Base;
vRatio3_MaxDEL = (vRatio3_Max-iRatio3_Max_Base)./iRatio3_Max_Base;
vRatio4_MeanDEL = (vRatio4_Mean-iRatio4_Mean_Base)./iRatio4_Mean_Base;
vRatio4_MaxDEL = (vRatio4_Max-iRatio4_Max_Base)./iRatio4_Max_Base;
vRatio5_MeanDEL = (vRatio5_Mean-iRatio5_Mean_Base)./iRatio5_Mean_Base;
vRatio5_MaxDEL = (vRatio5_Max-iRatio5_Max_Base)./iRatio5_Max_Base;
vRatio6_MeanDEL = (vRatio6_Mean-iRatio6_Mean_Base)./iRatio6_Mean_Base;
vRatio6_MaxDEL = (vRatio6_Max-iRatio6_Max_Base)./iRatio6_Max_Base;

% Plots


pFig7 = figure(7);
subplot(3,2,1)
hold off
plot(vTimes,vRatio1_MeanDEL)
title('R = G_R_O_I - R_R_O_I')
xlabel('Time (s)');
ylabel('\Delta R/R_0');

subplot(3,2,2)
hold off
plot(vTimes,vRatio2_MeanDEL)
title('R = G_R_O_I/R_R_O_I')
xlabel('Time (s)');
ylabel('\Delta R/R_0');

subplot(3,2,3)
hold off
plot(vTimes,vRatio3_MeanDEL)
title('R = (G_R_O_I-G_B_a_c_k)-(R_R_O_I-R_B_a_c_k)')
xlabel('Time (s)');
ylabel('\Delta R/R_0');

subplot(3,2,4)
hold off
plot(vTimes,vRatio4_MeanDEL)
title('R = (G_R_O_I-G_B_a_c_k)/(R_R_O_I-R_B_a_c_k)')
xlabel('Time (s)');
ylabel('\Delta R/R_0');

subplot(3,2,5)
hold off
plot(vTimes,vRatio5_MeanDEL)
title('R = (G_R_O_I-R_R_O_I)/(G_B_a_c_k-R_B_a_c_k)')
xlabel('Time (s)');
ylabel('\Delta R/R_0');

subplot(3,2,6)
hold off
plot(vTimes,vRatio6_MeanDEL)
title('(G_R_O_I/G_B_a_c_k)/(R_R_O_I/R_B_a_c_k)')
xlabel('Time (s)');
ylabel('\Delta R/R_0');

% saveas(pFig7,[strData(1:end-4) '_DelR_RoMean']);

pFig8 = figure(8);
title('Max')
subplot(3,2,1)
hold off
plot(vTimes,vRatio1_MaxDEL)
title('R = G_R_O_I - R_R_O_I')
xlabel('Time (s)');
ylabel('\Delta R/R_0');

subplot(3,2,2)
hold off
plot(vTimes,vRatio2_MaxDEL)
title('R = G_R_O_I/R_R_O_I')
xlabel('Time (s)');
ylabel('\Delta R/R_0');

subplot(3,2,3)
hold off
plot(vTimes,vRatio3_MaxDEL)
title('R = (G_R_O_I-G_B_a_c_k)-(R_R_O_I-R_B_a_c_k)')
xlabel('Time (s)');
ylabel('\Delta R/R_0');

subplot(3,2,4)
hold off
plot(vTimes,vRatio4_MaxDEL)
title('R = (G_R_O_I-G_B_a_c_k)/(R_R_O_I-R_B_a_c_k)')
xlabel('Time (s)');
ylabel('\Delta R/R_0');

subplot(3,2,5)
hold off
plot(vTimes,vRatio5_MaxDEL)
title('R = (G_R_O_I-R_R_O_I)/(G_B_a_c_k-R_B_a_c_k)')
xlabel('Time (s)');
ylabel('\Delta R/R_0');

subplot(3,2,6)
hold off
plot(vTimes,vRatio6_MaxDEL)
title('(G_R_O_I/G_B_a_c_k)/(R_R_O_I/R_B_a_c_k)')
xlabel('Time (s)');
ylabel('\Delta R/R_0');


% saveas(pFig8,[strData(1:end-4) '_DelR_RoMax']);
close(pFig1); close(pFig2); close(pFig3); close(pFig4);
close(pFig5); close(pFig6); close(pFig7); close(pFig8);

%% Summary Plot

pFig9 = figure(9);

subplot(4,2,1)
hold off
plot(vTimes,vGreenROI_Mean)
title('Green ROI (Mean)')
xlabel('Time (s)');
ylabel('Intensity (A.U.)');

subplot(4,2,2)
hold off
plot(vTimes,vRedROI_Mean)
title('Red ROI (Mean)')
xlabel('Time (s)');
ylabel('Intensity (A.U.)');

subplot(4,2,3)
hold off
plot(vTimes,vGreenBack_Mean)
title('Green Back (Mean)')
xlabel('Time (s)');
ylabel('Intensity (A.U.)');

subplot(4,2,4)
hold off
plot(vTimes,vRedBack_Mean)
title('Red Back (Mean)')
xlabel('Time (s)');
ylabel('Intensity (A.U.)');

subplot(4,2,5)
hold off
plot(vTimes,vRatio1_MeanDEL)
title('R = G_R_O_I - R_R_O_I')
xlabel('Time (s)');
ylabel('\Delta R/R_0');

subplot(4,2,6)
hold off
plot(vTimes,vRatio2_MeanDEL)
title('R = G_R_O_I/R_R_O_I')
xlabel('Time (s)');
ylabel('\Delta R/R_0');

subplot(4,2,7)
hold off
plot(vTimes,vRatio4_MeanDEL)
title('R = (G_R_O_I-G_B_a_c_k)/(R_R_O_I-R_B_a_c_k)')
xlabel('Time (s)');
ylabel('\Delta R/R_0');

subplot(4,2,8)
hold off
plot(vTimes,vRatio5_MeanDEL)
title('R = (G_R_O_I-R_R_O_I)/(G_B_a_c_k-R_B_a_c_k)')
xlabel('Time (s)');
ylabel('\Delta R/R_0');

saveas(pFig9,[strData(1:end-4) '_Summary DeltaR']);
saveas(pFig9,[strData(1:end-4) '_Summary DeltaR.png']);


% saveas(pFig9,[strData(1:end-4) '_Summary']);

%% Plots for ASH (green only)

pFig10 = figure(10);

subplot(3,2,1)
hold off
plot(vTimes,vGreenROI_Mean)
title('Green ROI (Mean)')
xlabel('Time (s)');
ylabel('Intensity (A.U.)');

subplot(3,2,2)
hold off
plot(vTimes,vGreenBack_Mean)
title('Green Background (Mean)')
xlabel('Time (s)');
ylabel('Intensity (A.U.)');

subplot(3,2,3)
hold off
plot(vTimes,vGreenRatio_Mean)
title('F (Ratio)')
xlabel('Time (s)');
ylabel('F (A.U.)');

subplot(3,2,4)
hold off
plot(vTimes,vGreenSub_Mean)
title('F (Subtraction)')
xlabel('Time (s)');
ylabel('F (A.U.)');


subplot(3,2,5)
hold off
plot(vTimes,vGreenRatio_MeanDEL)
title('\Delta F/F_0 (Ratio)')
xlabel('Time (s)');
ylabel('\Delta F/F_0');

subplot(3,2,6)
hold off
plot(vTimes,vGreenSub_MeanDEL)
title('\Delta F/F_0 (Subtraction)')
xlabel('Time (s)');
ylabel('\Delta F/F_0');

saveas(pFig10,[strData(1:end-4) '_Summary']);
saveas(pFig10,[strData(1:end-4) '_Summary.png']);

%% Save

save([strPath 'data\' strVidName strDescriptor '_data_plots.mat'], 'vGreenROI_Mean','vRedROI_Mean',...
    'vGreenBack_Mean','vRedBack_Mean','vGreenROI_Max','vRedROI_Max',...
    'vGreenBack_Max','vRedBack_Max',...
    'vGreenRatio_Mean','vGreenRatio_Max','vRedRatio_Mean','vRedRatio_Max',...
    'vGreenSub_Mean','vGreenSub_Max','vRedSub_Mean','vRedSub_Max',...
    'vRatio1_Mean','vRatio1_Max','vRatio2_Mean','vRatio2_Max',...
    'vRatio3_Mean','vRatio3_Max','vRatio4_Mean','vRatio4_Max',...
    'vRatio5_Mean','vRatio5_Max','vRatio6_Mean','vRatio6_Max',...
    'vGreenROI_MeanDEL','vRedROI_MeanDEL',...
    'vGreenBack_MeanDEL','vRedBack_MeanDEL','vGreenROI_MaxDEL','vRedROI_MaxDEL',...
    'vGreenBack_MaxDEL','vRedBack_MaxDEL',...
    'vGreenRatio_MeanDEL','vGreenRatio_MaxDEL','vRedRatio_MeanDEL','vRedRatio_MaxDEL',...
    'vGreenSub_MeanDEL','vGreenSub_MaxDEL','vRedSub_MeanDEL','vRedSub_MaxDEL',...
    'vRatio1_MeanDEL','vRatio1_MaxDEL','vRatio2_MeanDEL','vRatio2_MaxDEL',...
    'vRatio3_MeanDEL','vRatio3_MaxDEL','vRatio4_MeanDEL','vRatio4_MaxDEL',...
    'vRatio5_MeanDEL','vRatio5_MaxDEL','vRatio6_MeanDEL','vRatio6_MaxDEL');

end



