function line_matrix = get_maxima_line(probability_map, threshold_ratio, window_size)
    % Inputs:
    %   probability_map: 2D matrix of probabilities
    %   threshold_ratio: Fraction of max probability to threshold (e.g., 0.1)
    %   window_size: Smoothing window size (e.g., 5)
    %
    % Output:
    %   line_matrix: Binary 2D matrix where 1 = maxima line, 0 = background
    
    % Find maxima indices for each column
    [probValues, maxIndices] = max(probability_map, [], 1);
    
    % Apply threshold
    probThreshold = threshold_ratio * max(probability_map(:));
    maxIndices(probValues < probThreshold) = NaN;
    
    % Smooth the line (omit NaN gaps)
    smoothedIndices = smoothdata(maxIndices, 'movmean', window_size, 'omitnan');
    
    % Create binary matrix with the line
    line_matrix = zeros(size(probability_map));
    valid_cols = find(~isnan(smoothedIndices));
    for col = valid_cols
        row = round(smoothedIndices(col)); % Round to nearest integer
        if row >= 1 && row <= size(probability_map, 1)
            line_matrix(row, col) = 1;
        end
    end
end