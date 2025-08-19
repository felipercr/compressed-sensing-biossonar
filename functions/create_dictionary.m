function create_dictionary(simulation, nc_mask)

    fprintf("Creating dictionary... \n");

    kgrid = simulation.kgrid;
    sensor_mask = simulation.sensor.mask;

    N_sensors = sum(sensor_mask(:));
    Nt = kgrid.Nt;

    n_cut = simulation.n_cut;
    Nt = Nt - n_cut;

    % Pre-select valid filters
    valid_voxels = find(~nc_mask);  % linear indices
    N_computable_voxels = numel(valid_voxels);

    % Pre-aclocate dictionary
    dictionary = zeros(N_sensors, N_computable_voxels, Nt+1);

    for s = 1:N_sensors
        fprintf("Sensor %d of %d ", s, N_sensors);

        % Loop only on valid voxels
        for v_idx = 1:N_computable_voxels
            v = valid_voxels(v_idx);

            % Shifts signal in time
            distance = calculate_distance(simulation, v, s);
            signal = -propagated_wave(simulation, distance); % phase inversion
            signal = signal(n_cut:end);

            % Normalize
            max_signal_value = max(abs(signal));
            if max_signal_value == 0
                max_signal_value = 1;
            end
            normalized_signal = signal / max_signal_value;

            % Save
            dictionary(s, v_idx, :) = normalized_signal;

        end
        fprintf("Complete \n");
    end

    dict_name = return_file_name(simulation, 'dictionary');
    fprintf("Saving... \n");
    save(dict_name, 'dictionary', '-v7.3');

    fprintf("Creation complete \n\n");

end
