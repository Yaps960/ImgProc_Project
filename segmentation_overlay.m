function segmentation_overlay(img, imgIdx, resultsDir, clusterMasks, clusterColors, numClusters, greenMask, redMask, blueMask, segmentedImg, cleanedEdges)
% 5.1 Overlay Segmentation Outputs
    figure('Name', sprintf('Segmentation Visualization %d', imgIdx));
    
    % Ensure img is double for overlay calculations
    imgDouble = im2double(img);
    
    % Color-based Segmentation Overlay
    colorSegOverlay = imgDouble;
    
    % Green overlay
    greenOverlay = colorSegOverlay;
    for c = 1:3
        channelOverlay = greenOverlay(:,:,c);
        if c == 2  % Green channel
            channelOverlay(greenMask) = 0.7 * channelOverlay(greenMask) + 0.3;
        else
            channelOverlay(greenMask) = 0.7 * channelOverlay(greenMask);
        end
        greenOverlay(:,:,c) = channelOverlay;
    end
    
    % Red overlay
    redOverlay = colorSegOverlay;
    for c = 1:3
        channelOverlay = redOverlay(:,:,c);
        if c == 1  % Red channel
            channelOverlay(redMask) = 0.7 * channelOverlay(redMask) + 0.3;
        else
            channelOverlay(redMask) = 0.7 * channelOverlay(redMask);
        end
        redOverlay(:,:,c) = channelOverlay;
    end
    
    % Blue overlay
    blueOverlay = colorSegOverlay;
    for c = 1:3
        channelOverlay = blueOverlay(:,:,c);
        if c == 3  % Blue channel
            channelOverlay(blueMask) = 0.7 * channelOverlay(blueMask) + 0.3;
        else
            channelOverlay(blueMask) = 0.7 * channelOverlay(blueMask);
        end
        blueOverlay(:,:,c) = channelOverlay;
    end
    
    % Combine overlays
    colorSegOverlay = max(greenOverlay, max(redOverlay, blueOverlay));
    
    % Convert back to original image type
    colorSegOverlay = im2uint8(colorSegOverlay);
    
    % K-means Segmentation Overlay
    segmentationOverlay = imgDouble;
    for k = 1:numClusters
        clusterMask = (segmentedImg == k);
        clusterColor = clusterColors(k,:);
        for c = 1:3
            channelOverlay = segmentationOverlay(:,:,c);
            channelOverlay(clusterMask) = 0.7 * channelOverlay(clusterMask) + 0.3 * clusterColor(c);
            segmentationOverlay(:,:,c) = channelOverlay;
        end
    end
    
    % Convert back to original image type
    segmentationOverlay = im2uint8(segmentationOverlay);
    
    % Edge-based Segmentation Overlay
    edgeOverlay = imgDouble;
    for c = 1:3
        channelOverlay = edgeOverlay(:,:,c);
        channelOverlay(cleanedEdges) = 0.5 * channelOverlay(cleanedEdges) + 0.5;
        edgeOverlay(:,:,c) = channelOverlay;
    end
    
    % Convert back to original image type
    edgeOverlay = im2uint8(edgeOverlay);
    
    % Display visualization subplots
    subplot(2, 2, 1); imshow(img); title('Original Image');
    subplot(2, 2, 2); imshow(colorSegOverlay); title('Color Segmentation Overlay');
    subplot(2, 2, 3); imshow(segmentationOverlay); title('K-means Segmentation Overlay');
    subplot(2, 2, 4); imshow(edgeOverlay); title('Edge Segmentation Overlay');
    
    saveas(gcf, fullfile(resultsDir, sprintf('segmentation_overlay_%d.png', imgIdx)));
end