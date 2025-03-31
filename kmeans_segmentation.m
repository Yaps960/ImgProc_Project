function [clusterMasks, clusterColors, numClusters, segmentedImg] = kmeans_segmentation(img, imgIdx, resultsDir)
    % CLUSTERING SEGMENTATION FUNCTION (K-MEANS)

    % Reshape the image for k-means clustering
    [rows, cols, ~] = size(img);
    reshapedImg = double(reshape(img, rows*cols, 3));

    % Apply k-means clustering
    numClusters = 5;
    [clusterIdx, ~] = kmeans(reshapedImg, numClusters, 'Distance', 'sqeuclidean', ...
        'Replicates', 3, 'MaxIter', 100);

    % Reshape cluster indices back to the image dimensions
    segmentedImg = reshape(clusterIdx, rows, cols);

    % Create cluster masks and color mapping
    clusterColors = hsv(numClusters); 
    clusterMasks = false(rows, cols, numClusters);

    % Create segmented color image
    segmentedColorImg = zeros(rows, cols, 3);
    
    for k = 1:numClusters
        % Create binary mask for each cluster
        clusterMasks(:,:,k) = (segmentedImg == k);

        % Assign colors to clusters
        segmentedColorImg(:,:,1) = segmentedColorImg(:,:,1) + clusterMasks(:,:,k) * clusterColors(k,1);
        segmentedColorImg(:,:,2) = segmentedColorImg(:,:,2) + clusterMasks(:,:,k) * clusterColors(k,2);
        segmentedColorImg(:,:,3) = segmentedColorImg(:,:,3) + clusterMasks(:,:,k) * clusterColors(k,3);
    end

    % Display results
    figure('Name', sprintf('K-means Clustering %d', imgIdx));
    subplot(1, 2, 1); imshow(img); title('Original Image');
    subplot(1, 2, 2); imshow(segmentedColorImg); title('K-means Segmentation');
    saveas(gcf, fullfile(resultsDir, sprintf('kmeans_segmentation_%d.png', imgIdx)));
end