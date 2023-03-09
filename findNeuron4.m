function stGUI = findNeuron2(stGUI)
% Description:             Finds the AWD neuron in images in an image
% Inputs:                  handles struct for CaGUI, and point of neuron
%                          from previous image
% Outputs:                 updated handle for CaGUI
% Author:                  Daniel A. Porto (dporto3@gatech.edu)
% Date Last modified:      Mar 4, 2013

%     rgImage = imread(sprintf('%s/%s',stGUI.sDirName,stGUI.vFiles(stGUI.iFile).name));
%     rgImage = double(rgImage);
% 
%     axes(stGUI.axes2)
%     imagesc(rgImage)
%     title(sprintf('Original (Image %i out of %i)',stGUI.iFile,stGUI.iNumFiles))
%     axis image

% EDIT
%
% used to analyze cell specific optogenetics experiments
% LUCINDA: this is for constant threshold and sum (not max)

if nargin<1 || isempty(stGUI)
    load('temp.mat')
    stGUI = handles;
end

%% Parameters/Inputs
    i = stGUI.iFile;
    rgImage = stGUI.rgImage;
    iNumPixels = stGUI.iROIPixels;
    vPoint = stGUI.vPoint;
    vPoint_auto = stGUI.vPoint_auto;
    bTrack = stGUI.bTrack;

    
%% Find Neuron

if bTrack

    rgImageCrop = imcrop(rgImage,stGUI.vZoomRect);
    %Get outline of Body -> Inside is 1, Outiside is 0
%     rgBody = imfilter(rgImage,ones(5)/25)>50;
%     rgBodySmooth = imerode(imdilate(rgBody,strel('disk',20)),strel('disk',20));
    
    %Apply blob filter
    % vBlobSize = [iX iY];
    vBlobSize = [51 51];
    dBlobSigma = stGUI.dSigma;
    rgBlob = imfilter(rgImageCrop, -fspecial('log', vBlobSize, dBlobSigma));
    rgBlobNorm = double(zeros(size(rgBlob)));
    rgBlobNorm = rgBlob - min(rgBlob(:));
    rgBlobNorm = rgBlobNorm/max(rgBlobNorm(:));
    % rgBlobNorm = rgBlobNorm.*rgBodySmooth;
    
    % Crop Blob Filtered Image
    %rgBlobNormCrop = imcrop(rgBlobNorm, stGUI.vZoomRect);
    rgBlobNormCrop = rgBlobNorm;
    
    %Threshold blobs for neuron
    rgBW = rgBlobNormCrop > stGUI.dThresh;
    rgBW_auto = rgBlobNormCrop > 2.5*mean(mean(rgBlobNormCrop));
    rgLabel = bwlabel(rgBW);
    rgLabel_auto = bwlabel(rgBW_auto);
    
    %Remove objects from border
    iBorder = 5;
    rgBorder = ones(size(rgBlobNormCrop));
    rgBorder(iBorder+1:end-iBorder, iBorder+1:end-iBorder) = 0;
    %vectors of objects on border
    vOnBorder = unique(rgLabel(:).*rgBorder(:));   
    if length(vOnBorder) > 1
    for n = vOnBorder(2:end)'
        rgBW(rgLabel==n) = 0;
        rgBW_auto(rgLabel_auto==n) = 0;
    end
    end
    rgLabel2 = bwlabel(rgBW);
    rgLabel2_auto = bwlabel(rgBW_auto);

    
    %Plots
    axes(stGUI.axes3)
    imagesc(rgBlobNormCrop)
    title(sprintf('Blob Filtered (Image %i out of %i)',stGUI.iFile,stGUI.iNumFiles))
    colorbar
    axis image
% 
%     axes(stGUI.axes4)
%     imagesc(imcrop(rgLabel2, stGUI.vZoomRect))
%     title(sprintf('Labeled Objects (Image %i out of %i)',stGUI.iFile,stGUI.iNumFiles))
%     axis image
    
    %Look for nearest object
    iNumObjects = length(unique(rgLabel2))-1;
    iNumObjects_auto = length(unique(rgLabel2_auto))-1;
    sInfo = regionprops(rgBW,'Centroid');
    sInfo_auto = regionprops(rgBW_auto,'Centroid');
    
    bFound = false;
    if iNumObjects == 0
        fprintf('No Object Found in Image %i \n', stGUI.iFile);
        vNewPoint = stGUI.vPoint;
        stGUI.vAllPoints(:,i) = [NaN; NaN];

    elseif(iNumObjects==1)
        vNewPoint = sInfo.Centroid;
        stGUI.vAllPoints(:,i) = vNewPoint';

        bFound = true;
    else
        if isempty(stGUI.vPoint)
            axes(stGUI.axes2)
            imagesc(rgImage)
            title('Click on Neuron')
            [iX, iY] = getpts;
            vPoint = [iX, iY];
            title(sprintf('Original (Image %i out of %i)',stGUI.iFile,stGUI.iNumFiles))
        end
        vDist = zeros(1,numel(sInfo));
        for n = 1:numel(sInfo)
            vDist(n) = pdist([vPoint;sInfo(n).Centroid]);
        end
        minDist = min(vDist);
        vNewPoint = sInfo(vDist == minDist).Centroid;
        stGUI.vAllPoints(:,i) = vNewPoint';
        bFound = true;
    end


    if iNumObjects_auto == 0
        fprintf('No Object Found in Image %i \n', stGUI.iFile);
        vNewPoint_auto = stGUI.vPoint_auto;
        stGUI.vAllPoints_auto(:,i) = [NaN; NaN];

    elseif(iNumObjects==1)
        vNewPoint_auto = sInfo_auto.Centroid;
        stGUI.vAllPoints_auto(:,i) = vNewPoint_auto';

        bFound = true;
    else
        if isempty(stGUI.vPoint)
            axes(stGUI.axes2)
            imagesc(rgImage)
            title('Click on Neuron')
            [iX, iY] = getpts;
            vPoint = [iX, iY];
            title(sprintf('Original (Image %i out of %i)',stGUI.iFile,stGUI.iNumFiles))
        end
        vDist_auto = zeros(1,numel(sInfo_auto));
        for n = 1:numel(sInfo_auto)
            vDist_auto(n) = pdist([vPoint_auto;sInfo_auto(n).Centroid]);
        end
        minDist_auto = min(vDist_auto);
        vNewPoint_auto = sInfo_auto(vDist_auto == minDist_auto).Centroid;
        stGUI.vAllPoints_auto(:,i) = vNewPoint_auto';
        bFound = true;
    end
    
else
    vNewPoint = vPoint;
    vNewPoint_auto = vPoint_auto;
end
    
    bFound = true;
%     vNewPoint = vPoint;
    vNewPoint = floor(vNewPoint);
    stGUI.vPoint = vNewPoint;
    
    vNewPoint_auto = floor(vNewPoint_auto);
    stGUI.vPoint_auto = vNewPoint_auto;
    
    %Make ROI and Background Regions
%     try
    
    % Make ROI Mask
    iSmall = stGUI.iSmall;
    seSmall = strel('disk',iSmall,8);
    rgSmall = getnhood(seSmall);
    iSmallRect = (size(rgSmall,1)-1)/2;
    if stGUI.bZoom
        rgSmallMask = false(size(imcrop(rgImage,stGUI.vZoomRect)));
    else
        rgSmallMask = false(size(rgImage));
    end
    rgSmallMask(vNewPoint(2)-iSmallRect:vNewPoint(2)+iSmallRect,...
        vNewPoint(1)-iSmallRect:vNewPoint(1)+iSmallRect) = rgSmall;
    
    % Make Corresponding ROI for other Channel
    if stGUI.bPickGreen
        iShift = size(rgImage,2)/2;
    else
        iShift = -size(rgImage,2)/2;
    end
    rgSmallRedMask = false(size(rgImage));
    rgSmallRedMask(vNewPoint(2)-iSmallRect:vNewPoint(2)+iSmallRect,...
        vNewPoint(1)-iSmallRect+iShift:vNewPoint(1)+iSmallRect+iShift) = rgSmall;
    
    
    %Make Background Mask
    iBig = stGUI.iBig;
    seBack = strel('disk',iBig,8);
    rgBack = getnhood(seBack);
    iBackRect = (size(rgBack,1)-1)/2;
    if stGUI.bZoom
        rgBackMask = false(size(imcrop(rgImage,stGUI.vZoomRect)));
    else
        rgBackMask = false(size(rgImage));
    end
    
    if stGUI.bBackRing
        rgBackMask(vNewPoint(2)-iBackRect:vNewPoint(2)+iBackRect,...
            vNewPoint(1)-iBackRect:vNewPoint(1)+iBackRect) = rgBack;
        rgBackMask(vNewPoint(2)-iSmallRect:vNewPoint(2)+iSmallRect,...
            vNewPoint(1)-iSmallRect:vNewPoint(1)+iSmallRect) = ~rgSmall;

        %Make Background Mask for Other Channel
        rgBackRedMask = false(size(rgImage));
        rgBackRedMask(vNewPoint(2)-iBackRect:vNewPoint(2)+iBackRect,...
            vNewPoint(1)-iBackRect+iShift:vNewPoint(1)+iBackRect+iShift) = rgBack;
        rgBackRedMask(vNewPoint(2)-iSmallRect:vNewPoint(2)+iSmallRect,...
            vNewPoint(1)-iSmallRect+iShift:vNewPoint(1)+iSmallRect+iShift) = ~rgSmall;
        cCircles = bwboundaries(rgBackMask);
    elseif stGUI.bManualOffset == false
        iXOffset = stGUI.iBackX;
        iYOffset = stGUI.iBackY;
        rgBackMask(vNewPoint(2)-iSmallRect+iYOffset:vNewPoint(2)+iSmallRect+iYOffset,...
            vNewPoint(1)-iSmallRect+iXOffset:vNewPoint(1)+iSmallRect+iXOffset) = rgSmall;

        %Make Background Mask for Other Channel
        rgBackRedMask = false(size(rgImage));
        rgBackRedMask(vNewPoint(2)-iSmallRect+iYOffset:vNewPoint(2)+iSmallRect+iYOffset,...
            vNewPoint(1)-iSmallRect+iShift+iXOffset:vNewPoint(1)+iSmallRect+iShift+iXOffset) = rgSmall;
        cCircles = bwboundaries(rgBackMask+rgSmallMask+rgBackRedMask+rgSmallRedMask);
    else
        vBackPoint = stGUI.vBackPoint;
        rgBackMask(vBackPoint(2)-iBackRect:vBackPoint(2)+iBackRect,...
            vBackPoint(1)-iBackRect:vBackPoint(1)+iBackRect) = rgBack;
        cCircles = bwboundaries(rgBackMask+rgSmallMask);
    end
    
%     catch
%         fprintf('Region not in FOV \n')
%         bFound = false;
%     end
    
    if bFound == true
    
    %Get values
    if stGUI.bZoom
        rgImage = imcrop(rgImage,stGUI.vZoomRect);
        rgGreenROI = rgImage(rgSmallMask);
        rgGreenBack = rgImage(rgBackMask);
    else
        rgGreenROI = rgImage(rgSmallMask);
        rgGreenBack = rgImage(rgBackMask);
    end
    rgRedROI = rgImage(rgSmallRedMask);
    rgRedBack = rgImage(rgBackRedMask);
    
    
    %Switch Names If Picking Red
    if ~stGUI.bPickGreen
        rgGreenTempROI = rgGreenROI;
        rgGreenTempBack = rgGreenBack;
        rgGreenROI = rgRedROI;
        rgGreenBack = rgRedBack;
        rgRedROI = rgGreenTempROI;
        rgRedBack = rgGreenTempBack;
    end
    
    %Get Top Values for ROI
    if stGUI.bMaxFluor
        vGreen = sort(rgGreenROI(:),'descend');
        vRed = sort(rgRedROI(:),'descend');
        vGreenROI = vGreen(1:iNumPixels);
        vRedROI = vRed(1:iNumPixels);
    end 

    if stGUI.bTotalFluor
        vGreenROI2 = rgGreenROI;
        vRedROI2 = rgRedROI;
    end
    

    %Calculations
        
        stGUI.vFound(i) = bFound;

        stGUI.vGreenROI_Mean(i) = nanmean(vGreenROI(:));
        stGUI.vGreenBack_Mean(i) = nanmean(rgGreenBack(:));
        stGUI.vGreenROI_Max(i) = nanmax(vGreenROI(:));
        stGUI.vGreenBack_Max(i) = nanmax(rgGreenBack(:));
        stGUI.vRedROI_Mean(i) = nanmean(vRedROI(:));
        stGUI.vRedBack_Mean(i) = nanmean(rgRedBack(:));
        stGUI.vRedROI_Max(i) = nanmax(vRedROI(:));
        stGUI.vRedBack_Max(i) = nanmax(rgRedBack(:));
        
        
        stGUI.vRatio_Mean(i) = (stGUI.vGreenROI_Mean(i)-stGUI.vRedROI_Mean(i))...
            ./(stGUI.vGreenBack_Mean(i)-stGUI.vRedBack_Mean(i));
        stGUI.vRatio_Max(i) = (stGUI.vGreenROI_Max(i)-stGUI.vRedROI_Max(i))...
            ./(stGUI.vGreenBack_Max(i)-stGUI.vRedBack_Max(i));
    
        stGUI.vGreenROI_Mean2(i) = nanmean(vGreenROI2(:));
        stGUI.vGreenBack_Mean2(i) = nanmean(rgGreenBack(:));
        stGUI.vGreenROI_Max2(i) = nanmax(vGreenROI2(:));
        stGUI.vGreenBack_Max2(i) = nanmax(rgGreenBack(:));
        stGUI.vRedROI_Mean2(i) = nanmean(vRedROI2(:));
        stGUI.vRedBack_Mean2(i) = nanmean(rgRedBack(:));
        stGUI.vRedROI_Max2(i) = nanmax(vRedROI2(:));
        stGUI.vRedBack_Max2(i) = nanmax(rgRedBack(:));
        
        
        stGUI.vRatio_Mean2(i) = (stGUI.vGreenROI_Mean2(i)-stGUI.vRedROI_Mean2(i))...
            ./(stGUI.vGreenBack_Mean2(i)-stGUI.vRedBack_Mean2(i));
        stGUI.vRatio_Max2(i) = (stGUI.vGreenROI_Max2(i)-stGUI.vRedROI_Max2(i))...
            ./(stGUI.vGreenBack_Max2(i)-stGUI.vRedBack_Max2(i));
    
    else
        
        stGUI.vGreenROI_Mean(i) = NaN;
        stGUI.vGreenBack_Mean(i) = NaN;
        stGUI.vGreenROI_Max(i) = NaN;
        stGUI.vGreenBack_Max(i) = NaN;
        stGUI.vRedROI_Mean(i) = NaN;
        stGUI.vRedBack_Mean(i) = NaN;
        stGUI.vRedROI_Max(i) = NaN;
        stGUI.vRedBack_Max(i) = NaN;
        stGUI.vRatio_Mean(i) = NaN;
        stGUI.vRatio_Max(i) = NaN;

        stGUI.vGreenROI_Mean2(i) = NaN;
        stGUI.vGreenBack_Mean2(i) = NaN;
        stGUI.vGreenROI_Max2(i) = NaN;
        stGUI.vGreenBack_Max2(i) = NaN;
        stGUI.vRedROI_Mean2(i) = NaN;
        stGUI.vRedBack_Mean2(i) = NaN;
        stGUI.vRedROI_Max2(i) = NaN;
        stGUI.vRedBack_Max2(i) = NaN;
        stGUI.vRatio_Mean2(i) = NaN;
        stGUI.vRatio_Max2(i) = NaN;

    end

if bFound    
%Show Images
axes(stGUI.axes2)
hold on
for i = 1:length(cCircles)
    rgCircles = cCircles{i};
    plot(rgCircles(:,2),rgCircles(:,1),'r')
end
hold off

axes(stGUI.axes3)
hold on
for i = 1:length(cCircles)
    rgCircles = cCircles{i};
    plot(rgCircles(:,2),rgCircles(:,1),'r')
end
hold off
% 
% axes(stGUI.axes4)
% hold on
% for i = 1:length(cCircles)
%     rgCircles = cCircles{i};
%     plot(rgCircles(:,2),rgCircles(:,1),'r')
% end
% hold off

% Plot F/Fo

axes(stGUI.axes5)
vPlot = stGUI.vRatio_Mean/stGUI.vRatio_Mean(1);
vX_axis = [1:length(stGUI.vRatio_Mean)];
plot(vX_axis,vPlot);
hold on
scatter(vX_axis(stGUI.iFile),vPlot(stGUI.iFile),100,[0 0 1],'LineWidth',2)
hold off
xlabel('Frame')
ylabel('F/Fo')
title('vRatio_Mean')
end


end