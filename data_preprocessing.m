% DATA PREPARATION FUNCTION
% This function creates the output directory, loads sample images, and processes them.
function imageFiles = data_preprocessing()
    % Create a directory to save results
    resultsDir = 'output';
    if ~exist(resultsDir, 'dir')
        mkdir(resultsDir);
    end

    % Load sample images (replace with your own image paths)
    imageFiles = {
        './project_images/1.jpg'; 
        './project_images/2.jpg';
        './project_images/3.jpg';
        './project_images/4.jpg';
        './project_images/5.jpg'
    };

    for imgIdx = 1:length(imageFiles)
        currentFile = imageFiles{imgIdx};
        
        % Check if file exists before reading
        if ~isfile(currentFile)
            fprintf('Error: File not found - %s\n', currentFile);
            continue; % Skip to next image
        end
        
        % Debugging: Print file details
        fileInfo = dir(currentFile);
        fprintf('File %s found. Size: %d bytes\n', currentFile, fileInfo.bytes);
        
        % Try reading the image
        try
            originalImg = imread(currentFile);
        catch ME
            fprintf('Error reading %s: %s\n', currentFile, ME.message);
            continue; % Skip to the next image
        end
        
        % Convert to RGB if grayscale
        if size(originalImg, 3) == 1
            originalImg = cat(3, originalImg, originalImg, originalImg);
        end
        
        % Resize to consistent resolution
        targetSize = [512, 512];
        img = imresize(originalImg, targetSize);
        
        % Display original image
        figure('Name', sprintf('Original Image %d', imgIdx));
        imshow(img);
        title('Original Image');
        saveas(gcf, fullfile(resultsDir, sprintf('original_%d.png', imgIdx)));

        [greenMask, redMask, blueMask] = color_segmentation(img, imgIdx, resultsDir);

        [cleanedEdges] = edge_segmentation(img, imgIdx, resultsDir);

        [clusterMasks, clusterColors, numClusters, segmentedImg] = kmeans_segmentation(img, imgIdx, resultsDir);
        
        object_detection(img, imgIdx, resultsDir, clusterMasks, clusterColors, numClusters);

        scene_classification(img, imgIdx, resultsDir);

        segmentation_overlay(img, imgIdx, resultsDir, clusterMasks, clusterColors, numClusters, greenMask, redMask, blueMask, segmentedImg, cleanedEdges);
    end
end