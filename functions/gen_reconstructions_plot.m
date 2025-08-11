function fig = gen_reconstructions_plot(maxima_line, map, visible_section, plot)
    % Create figure and store handle
    fig = figure('Position', [100, 100, 1200, 500]);
    
    % Left subplot: Probability map + line
    subplot(1, 2, 1);
    h_map = imagesc(map);
    colormap(gca, 'gray');
    hold on;
    red_line = cat(3, maxima_line, zeros(size(maxima_line)), zeros(size(maxima_line)));
    h_line = imagesc(red_line);
    set(h_line, 'AlphaData', maxima_line);
    hold off;
    colorbar;
    xlabel('x'); 
    ylabel('y');
    title('Probability Map with Maxima Line');
    
    % Right subplot: Visible section + line
    subplot(1, 2, 2);
    imagesc(visible_section);
    colormap(gca, 'gray');
    hold on;
    h_line = imagesc(red_line);
    set(h_line, 'AlphaData', maxima_line);
    hold off;
    colorbar;
    xlabel('x');
    title('Visible Section with Maxima Line');

    if plot == 0
        set(fig, 'Visible', 'off');
    end
    
end