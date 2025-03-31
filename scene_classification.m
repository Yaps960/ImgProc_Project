function scene_classification(img, imgIdx, resultsDir)
    % Compute basic image statistics
    meanRGB = mean(reshape(double(img), [], 3));
    stdRGB = std(reshape(double(img), [], 3));

    % Compute image histogram for texture analysis
    [counts, binLocations] = imhist(rgb2gray(img));

    % Compute entropy (measure of randomness/texture complexity)
    entropyValue = entropy(rgb2gray(img));

    % Basic scene classification based on color distribution
    isOutdoor = false;
    isIndoor = false;
    isNaturalScene = false;
    isUrbanScene = false;

    % Simple rule-based classification 
    if meanRGB(3) > meanRGB(1) && meanRGB(3) > meanRGB(2) && meanRGB(3) > 100
        isOutdoor = true;
        if meanRGB(2) > 100
            isNaturalScene = true;
        else
            isUrbanScene = true;
        end
    else
        isIndoor = true;
    end

    % Edge detection (add if missing)
    cannyEdges = edge(rgb2gray(img), 'Canny');
    edgeDensity = sum(cannyEdges(:)) / numel(cannyEdges);

    % Display scene analysis results
    figure('Name', sprintf('Scene Classification %d', imgIdx));
    subplot(2, 2, 1); imshow(img); title('Original Image');
    subplot(2, 2, 2); bar(binLocations, counts);
    title('Grayscale Histogram'); xlabel('Intensity'); ylabel('Pixel Count');

    % Display scene classification results
    subplot(2, 2, 3:4);
    axis off;
    text(0.1, 0.9, 'Scene Analysis Results:', 'FontSize', 14, 'FontWeight', 'bold');
    text(0.1, 0.8, sprintf('Mean RGB: [%.2f, %.2f, %.2f]', meanRGB(1), meanRGB(2), meanRGB(3)));
    text(0.1, 0.7, sprintf('Image Entropy: %.4f', entropyValue));
    text(0.1, 0.6, sprintf('Edge Density: %.4f', edgeDensity));

    if isOutdoor
        text(0.1, 0.4, 'Classification: Outdoor Scene', 'FontWeight', 'bold');
        if isNaturalScene
            text(0.1, 0.3, 'Sub-classification: Natural Scene', 'FontWeight', 'bold');
        else
            text(0.1, 0.3, 'Sub-classification: Urban Scene', 'FontWeight', 'bold');
        end
    else
        text(0.1, 0.4, 'Classification: Indoor Scene', 'FontWeight', 'bold');
    end

    saveas(gcf, fullfile(resultsDir, sprintf('scene_classification_%d.png', imgIdx)));

    % Print scene analysis results
    fprintf('\nScene Analysis Results:\n');
    fprintf('----------------------\n');
    fprintf('Mean RGB: [%.2f, %.2f, %.2f]\n', meanRGB(1), meanRGB(2), meanRGB(3));
    fprintf('Image Entropy: %.4f\n', entropyValue);
    fprintf('Edge Density: %.4f\n', edgeDensity);
    if isOutdoor
        fprintf('Classification: Outdoor Scene\n');
        if isNaturalScene
            fprintf('Sub-classification: Natural Scene\n');
        else
            fprintf('Sub-classification: Urban Scene\n');
        end
    else
        fprintf('Classification: Indoor Scene\n');
    end
end