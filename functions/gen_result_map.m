function [fig, map] = gen_result_map(simulation, g, sigma, threshold, plot)
    Nx = simulation.kgrid.Nx;
    Ny = simulation.kgrid.Ny;
    
    % Applies threshold
    % g(g < threshold) = 0;

    g_matrix = reshape(g, [Nx, Ny]); % Reshape g into 2D grid (Nx × Ny)
    g_matrix(g_matrix < 0) = 0;      % Filter values smaller than 0
    
    [X, Y] = meshgrid(1:Nx, 1:Ny);   % Create grid coordinates
    
    
    % Loop over all voxels and add Gaussian contributions
    g_smoothed = zeros(Ny, Nx);
    for i = 1:Ny
        for j = 1:Nx
            if g_matrix(i,j) > 0
                G = g_matrix(i,j) * exp(-((X - j).^2 + (Y - i).^2) / (2*sigma^2));
                g_smoothed = g_smoothed + G;
            end
        end
    end
    
    % Normalize
    g_smoothed = g_smoothed / max(g_smoothed(:));
    g_smoothed = flipud(g_smoothed); % The result comes x-mirroed 
    
    % Applies threshold
    g_smoothed(g_smoothed < threshold) = 0;

    
    % Create figure with two layers
    fig = figure;
    
    % First layer: Probability map
    h1 = surf(X, Y, g_smoothed, 'EdgeColor', 'none');
    view(2);
    colormap(h1.Parent, 'parula');
    colorbar;
    hold on;
    
    % Second layer: Object image
    obj_img = simulation.obj_image;
    obj_img = ~flipud(obj_img);
    
    obj_img = double(obj_img)/max(double(obj_img(:)));
    
    transparency = 0.3;
    h2 = surf(X, Y, ones(size(g_smoothed)), 'CData', obj_img, ...
        'FaceColor', 'texturemap', 'EdgeColor', 'none', ...
        'FaceAlpha', transparency, 'AlphaDataMapping', 'none');
    colormap(h2.Parent);
    
    % Names and labels
    title('Normalized Probability Map with Object Overlay');
    xlabel('y'); ylabel('x');
    axis tight;
    grid off;

    if plot == 0
        set(fig, 'Visible', 'off');
    end

    map = flipud(g_smoothed);
end

