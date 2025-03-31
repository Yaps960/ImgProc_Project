function [cleanedEdges] = edge_segmentation(img, imgIdx, resultsDir)
    % EDGE SEGMENTATION FUNCTION
    % This function segments an image based on edges using various edge detection methods.

    % Convert to grayscale for edge detection
    grayImg = rgb2gray(img);

    % Apply various edge detection methods
    sobelEdges = edge(grayImg, 'sobel');
    cannyEdges = edge(grayImg, 'canny');
    prewittEdges = edge(grayImg, 'prewitt');

    % Enhance edges using morphological operations
    se_line1 = strel('line', 3, 0);
    se_line2 = strel('line', 3, 90);
    dilatedEdges = imdilate(cannyEdges, [se_line1 se_line2]);

    % Close small gaps in the edges
    closedEdges = imclose(dilatedEdges, strel('disk', 2));

    % Fill holes in the closed edges to get potential object regions
    filledEdges = imfill(closedEdges, 'holes');

    % Remove small objects (noise)
    cleanedEdges = bwareaopen(filledEdges, 100);

    % Display and save edge detection results
    figure('Name', sprintf('Edge Detection %d', imgIdx));
    subplot(2, 3, 1); imshow(grayImg); title('Grayscale');
    subplot(2, 3, 2); imshow(sobelEdges); title('Sobel');
    subplot(2, 3, 3); imshow(cannyEdges); title('Canny');
    subplot(2, 3, 4); imshow(prewittEdges); title('Prewitt');
    subplot(2, 3, 5); imshow(dilatedEdges); title('Dilated Edges');
    subplot(2, 3, 6); imshow(cleanedEdges); title('Cleaned Region');
    saveas(gcf, fullfile(resultsDir, sprintf('edge_segmentation_%d.png', imgIdx)));
end