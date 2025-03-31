function object_detection(img, imgIdx, resultsDir, clusterMasks, clusterColors, numClusters)
    % OBJECT DETECTION FUNCTION
    % This function detects objects in each cluster and draws bounding boxes.

    % Create figure for object detection
    figure('Name', sprintf('Object Detection %d', imgIdx));
    subplot(1, 2, 1); imshow(img); title('Original Image');

    % Create an overlay image for bounding boxes
    objBoundaryImg = img;

    % Initialize structure to store object properties
    objects = struct('ClusterID', {}, 'Label', {}, 'Area', {}, 'Centroid', {}, 'BoundingBox', {});
    objCount = 0;

    for k = 1:numClusters
        % Get current cluster mask
        clusterMask = clusterMasks(:,:,k);

        % Remove small objects (noise)
        cleanMask = bwareaopen(clusterMask, 200);

        % Label connected components
        [labeledMask, numComponents] = bwlabel(cleanMask);

        % Get region properties
        regionProps = regionprops(labeledMask, 'Area', 'Centroid', 'BoundingBox');

        % Store significant objects (with sufficient area)
        for j = 1:numComponents
            if regionProps(j).Area > 500 % Minimum area threshold
                objCount = objCount + 1;
                objects(objCount).ClusterID = k;
                objects(objCount).Label = objCount;
                objects(objCount).Area = regionProps(j).Area;
                objects(objCount).Centroid = regionProps(j).Centroid;
                objects(objCount).BoundingBox = regionProps(j).BoundingBox;

                % Draw bounding box
                x = regionProps(j).BoundingBox(1);
                y = regionProps(j).BoundingBox(2);
                width = regionProps(j).BoundingBox(3);
                height = regionProps(j).BoundingBox(4);

                % Use different colors for different clusters
                boxColor = clusterColors(k,:) * 255;

                % Draw bounding box on the overlay image
                objBoundaryImg = insertShape(objBoundaryImg, 'Rectangle', [x, y, width, height], ...
                    'Color', boxColor, 'LineWidth', 3);

                % Add label
                objBoundaryImg = insertText(objBoundaryImg, [x, y-15], sprintf('Obj %d', objCount), ...
                    'FontSize', 14, 'BoxColor', boxColor, 'TextColor', 'white');
            end
        end
    end

    % Display detection results
    subplot(1, 2, 2); imshow(objBoundaryImg); title('Object Detection Results');
    saveas(gcf, fullfile(resultsDir, sprintf('object_detection_%d.png', imgIdx)));

    % Display object information
    fprintf('\nDetected Objects Information:\n');
    fprintf('----------------------------\n');
    for i = 1:objCount
        fprintf('Object %d (Cluster %d):\n', objects(i).Label, objects(i).ClusterID);
        fprintf('  Area: %.2f pixels\n', objects(i).Area);
        fprintf('  Centroid: (%.2f, %.2f)\n', objects(i).Centroid(1), objects(i).Centroid(2));
        fprintf('  Bounding Box: [%.2f, %.2f, %.2f, %.2f]\n', ...
            objects(i).BoundingBox(1), objects(i).BoundingBox(2), ...
            objects(i).BoundingBox(3), objects(i).BoundingBox(4));
    end
end