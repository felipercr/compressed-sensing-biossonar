function fig = gen_accuracy_plot(visible_section, result_map, plot)
    % Visible section (binary mask)
    fig = figure;
    imagesc(visible_section);
    colormap(gray);
    
    hold on;
    
    % Probability map with transparency
    h = imagesc(result_map);
    set(h, 'AlphaData', 0.5);
    colormap('hot');
    colorbar;
    
    % Add title and labels
    title('Visible Section with Probability Map Overlay');
    xlabel('x');
    ylabel('y');
    
    hold off;

    if plot == 0
        set(fig, 'Visible', 'off');
    end
    
end

