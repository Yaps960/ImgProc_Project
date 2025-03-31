% COLOR SEGMENTATION FUNCTION
% This function segments an image based on color.
function [greenMask, redMask, blueMask] = color_segmentation(img, imgIdx, resultsDir)
    % Convert to different color spaces
    hsvImg = rgb2hsv(img);
    ycbcrImg = rgb2ycbcr(img);
    labImg = rgb2lab(img);

    % Display and save different color spaces
    figure('Name', sprintf('Color Spaces %d', imgIdx));
    subplot(2, 2, 1); imshow(img); title('RGB');
    subplot(2, 2, 2); imshow(hsvImg); title('HSV');
    subplot(2, 2, 3); imshow(ycbcrImg, []); title('YCbCr');
    subplot(2, 2, 4); imshow(labImg, []); title('LAB');
    saveas(gcf, fullfile(resultsDir, sprintf('color_spaces_%d.png', imgIdx)));

    % HSV-based color segmentation
    hBand = hsvImg(:,:,1);
    sBand = hsvImg(:,:,2);
    vBand = hsvImg(:,:,3);

    % Thresholding for color segmentation
    greenMask = (hBand > 0.2 & hBand < 0.4) & (sBand > 0.3) & (vBand > 0.3);
    redMask = ((hBand > 0.95 | hBand < 0.05) & sBand > 0.5 & vBand > 0.5);
    blueMask = (hBand > 0.55 & hBand < 0.7) & (sBand > 0.4) & (vBand > 0.3);

    % Apply morphological operations
    se = strel('disk', 5);
    greenMask = imopen(greenMask, se);
    redMask = imopen(redMask, se);
    blueMask = imopen(blueMask, se);

    % Display and save segmentation results
    figure('Name', sprintf('Color Segmentation %d', imgIdx));
    subplot(2, 2, 1); imshow(img); title('Original');
    subplot(2, 2, 2); imshow(greenMask); title('Green Objects');
    subplot(2, 2, 3); imshow(redMask); title('Red Objects');
    subplot(2, 2, 4); imshow(blueMask); title('Blue Objects');
    saveas(gcf, fullfile(resultsDir, sprintf('color_segmentation_%d.png', imgIdx)));

    % Create and save color-coded segmentation mask
    colorSegMask = zeros(size(img));
    colorSegMask(:,:,1) = redMask;
    colorSegMask(:,:,2) = greenMask;
    colorSegMask(:,:,3) = blueMask;
    imwrite(colorSegMask, fullfile(resultsDir, sprintf('color_seg_mask_%d.png', imgIdx)));
end
