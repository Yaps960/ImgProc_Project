% Read the image
img = imread('./project_images/1.jpg');

% Crop and resize the image
rect = [450, 0, 1000, 1000];
img_cropped = imcrop(img, rect);
img_resized = imresize(img_cropped, [512 512]);

% Write the resized image to file
imwrite(img_resized, '1_resized.jpg');

% Convert the resized image to HSV color space
img_hsv = rgb2hsv(img_resized);

% Define HSV thresholds for segmenting a color (Hue, Saturation, Value)
hueMin = 0.01;  % Minimum hue value (e.g., range of colors)
hueMax = 0.9;   % Maximum hue value

saturationMin = 0.1;  % Minimum saturation (from 0 to 1)
saturationMax = 0.8;  % Maximum saturation (from 0 to 1)

valueMin = 0.05;       % Minimum value (brightness, from 0 to 1)
valueMax = 1.0;       % Maximum value (brightness, from 0 to 1)

% Create a mask based on thresholds for Hue, Saturation, and Value
mask_hsv = (img_hsv(:,:,1) >= hueMin) & (img_hsv(:,:,1) <= hueMax) & ...
           (img_hsv(:,:,2) >= saturationMin) & (img_hsv(:,:,2) <= saturationMax) & ...
           (img_hsv(:,:,3) >= valueMin) & (img_hsv(:,:,3) <= valueMax);

% Apply the mask to the image for segmentation
segmented_image_hsv = bsxfun(@times, img_resized, cast(mask_hsv, 'like', img_resized));

% Convert the resized image to YCbCr color space
img_ycbcr = rgb2ycbcr(img_resized);

% Define YCbCr thresholds for segmenting a color (Y, Cb, Cr)
yMin = 150;    % Minimum Y (brightness)
yMax = 225;    % Maximum Y (brightness)

cbMin = 20;    % Minimum Cb (chrominance)
cbMax = 150;   % Maximum Cb (chrominance)

crMin = 50;   % Minimum Cr (chrominance)
crMax = 250;   % Maximum Cr (chrominance)

% Create a mask based on thresholds for Y, Cb, and Cr
mask_ycbcr = (img_ycbcr(:,:,1) >= yMin) & (img_ycbcr(:,:,1) <= yMax) & ...
             (img_ycbcr(:,:,2) >= cbMin) & (img_ycbcr(:,:,2) <= cbMax) & ...
             (img_ycbcr(:,:,3) >= crMin) & (img_ycbcr(:,:,3) <= crMax);

% Apply the mask to the image for segmentation
segmented_image_ycbcr = bsxfun(@times, img_resized, cast(mask_ycbcr, 'like', img_resized));

% Display the images in two separate figures
figure; 
subplot(1, 2, 1); % First subplot for HSV-based segmentation
imshow(segmented_image_hsv);
title('HSV Segmented Image');

subplot(1, 2, 2); % Second subplot for YCbCr-based segmentation
imshow(segmented_image_ycbcr);
title('YCbCr Segmented Image');
