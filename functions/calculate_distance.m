function distance = calculate_distance(simulation, v_number, s_number)

    dx = simulation.kgrid.dx;
    dy = simulation.kgrid.dy;

    % Find source coordinates
    source_position = simulation.source_position;
    source_position = source_position .* [dx, dy];

    % Find sensor coordinates
    sensors_mask = simulation.sensor.mask;
    sensor_indices = find(sensors_mask);
    [x_s, y_s] = ind2sub(size(sensors_mask), sensor_indices(s_number));
    sensor_position = [x_s, y_s] .* [dx, dy];

    % Find voxel coordinates
    [x_v, y_v] = ind2sub(size(simulation.medium.sound_speed), v_number);
    voxel_position = [x_v, y_v] .* [dx, dy];

    distance_e_v = norm(source_position - voxel_position);
    distance_v_s = norm(voxel_position - sensor_position);

    distance = distance_e_v + distance_v_s;

end

