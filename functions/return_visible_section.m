function [filtered_obj, visible_angles] = return_visible_section(simulation, aperture_angle)
    obj_image = simulation.obj_image;
    source_pos = simulation.source_position;
    
    [rows, cols] = size(obj_image);
    visible_mask = false(size(obj_image));
    angle_map = nan(size(obj_image)); % Initialize with NaN
    
    [obj_rows, obj_cols] = find(obj_image == 0);
    
    for i = 1:length(obj_rows)
        r = obj_rows(i);
        c = obj_cols(i);
        
        % Calculate vector from source to pixel (in image coordinates)
        dx = c - source_pos(2);  % x-distance (columns)
        dy = r - source_pos(1);  % y-distance (rows)
        
        % Calculate angle relative to vertical (y-axis)
        angle = atan2d(dx, -dy); % -dy because image y-axis points downward
        
        % Normalize angle to [-180,180] range
        angle = mod(angle + 180, 360) - 180;
        
        % Store angle regardless of visibility
        angle_map(r, c) = angle;
        
        % Skip if outside aperture angle
        if abs(angle) > aperture_angle/2
            continue;
        end
        
        % Visibility check (same as before)
        line_cols = linspace(source_pos(2), c, max(abs(dx), abs(dy)) + 1);
        line_rows = linspace(source_pos(1), r, max(abs(dx), abs(dy)) + 1);
        
        line_cols = round(line_cols);
        line_rows = round(line_rows);
        
        unique_mask = [true, diff(line_cols) ~= 0 | diff(line_rows) ~= 0];
        line_cols = line_cols(unique_mask);
        line_rows = line_rows(unique_mask);
        
        visible = true;
        for j = 1:length(line_cols)
            x = line_cols(j);
            y = line_rows(j);
            
            if x < 1 || x > cols || y < 1 || y > rows
                continue;
            end
            
            if ~(x == source_pos(2) && y == source_pos(1)) && ...
               ~(x == c && y == r) && ...
               obj_image(y, x) == 0
                visible = false;
                break;
            end
        end
        
        if visible
            visible_mask(r, c) = true;
        end
    end
    
    filtered_obj = zeros(size(obj_image));
    filtered_obj(visible_mask) = 1;
    
    % Return angles only for visible pixels
    visible_angles = angle_map;
    visible_angles(~visible_mask) = NaN;
end