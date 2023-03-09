function [green_top_mean, red_top_mean] = analyze_process(vidfolder,vidname)
% get x number of brightest pixels in selection area, area follows the
% neuron body

v = VideoReader(fullfile(vidfolder, [vidname, '.avi']));

% read in corresponding mat file
load(fullfile(vidfolder, 'data', [vidname, 'ALM_data.mat']));

frame145 = read(v, 145);
frame145=rgb2gray(frame145);
imagesc(frame145)
hold on
plot(vAllPoints(1,145),vAllPoints(2,145), '*')
line([1,512],[vAllPoints(2,145),vAllPoints(2,145)])
line([1,512],[vAllPoints(2,145)-150,vAllPoints(2,145)-150])
line([1,512],[vAllPoints(2,145)-250,vAllPoints(2,145)-250])
green_roi = drawpolygon;

green_rel_pos = green_roi.Position-repmat([vAllPoints(1,145),vAllPoints(2,145)],4,1);

red_roi = drawpolygon;

background_g_roi = drawpolygon;
background_r_roi = drawpolygon;

red_rel_pos = red_roi.Position-repmat([vAllPoints(1,145),vAllPoints(2,145)],4,1);

% get top 500 brightest pixels as process
for i = 1:v.NumFrames
    temp_raw_frame = read(v,i);
    temp_raw_frame = rgb2gray(temp_raw_frame);
    
    background_g_mask = poly2mask(background_g_roi.Position(:,1), background_g_roi.Position(:,2),512,512);
    background_g_pixel_int_all = temp_raw_frame(background_g_mask);
    background_g_pixel_mean(i) = mean(background_g_pixel_int_all,'all');
    
    background_r_mask = poly2mask(background_r_roi.Position(:,1), background_r_roi.Position(:,2),512,512);
    background_r_pixel_int_all = temp_raw_frame(background_r_mask);
    background_r_pixel_mean(i) = mean(background_r_pixel_int_all,'all');
    
    temp_frame = zeros(size(temp_raw_frame));
    temp_frame(:,1:256) = temp_raw_frame(:,1:256) - background_g_pixel_mean(i);
    temp_frame(:,257:end) = temp_raw_frame(:,257:end) - background_r_pixel_mean(i);
    green_temp = green_rel_pos + repmat([vAllPoints(1,i),vAllPoints(2,i)],4,1);

    green_top_mask = poly2mask(green_temp(:,1), green_temp(:,2),512,512);

    green_top_pixel_int_all = temp_frame(green_top_mask);
    green_top_pixel_int_all = sort(green_top_pixel_int_all, 'descend');
    green_top_pixel_int_500 = green_top_pixel_int_all(1:500);
    green_top_pix_int_all{i}=green_top_pixel_int_all;
   
    red_temp = red_rel_pos + repmat([vAllPoints(1,i),vAllPoints(2,i)],4,1);

    red_mask = poly2mask(red_temp(:,1), red_temp(:,2),512,512);
    
    red_top_pixel_int_all = temp_frame(red_mask);
    red_top_pixel_int_all = sort(red_top_pixel_int_all, 'descend');
    red_top_pixel_int_500 = red_top_pixel_int_all(1:500);

    
    red_top_mean(i) = mean(red_top_pixel_int_500,'all');
    green_top_mean(i) = mean(green_top_pixel_int_500,'all');
    
end

figure
plot(red_top_mean)

figure
plot(green_top_mean)
