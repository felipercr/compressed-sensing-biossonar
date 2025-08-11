function create_dictionary(simulation)

    fprintf("Creating dictionary... \n");

    kgrid = simulation.kgrid;
    sensor_mask = simulation.sensor.mask;

    N_sensors = sum(sensor_mask(:));
    Nx = kgrid.Nx;
    Ny = kgrid.Ny;
    Nt = kgrid.Nt;
    N_voxels = Nx*Ny;

    n_cut = simulation.n_cut;
    Nt = Nt-n_cut;

    dictionary = zeros(N_sensors, N_voxels, Nt+1);

    for s = 1:N_sensors
        fprintf("Sensor %d of %d ", s, N_sensors);
        for v = 1:N_voxels
            distance = calculate_distance(simulation, v, s);
            signal = -propagated_wave(simulation, distance); % The minus accounts for phase inversion
            signal = signal(n_cut:end);
            max_signal_value = max(abs(signal));
            if max_signal_value == 0 
                max_signal_value = 1;
            end
            normalized_signal = signal / max_signal_value;
            dictionary(s, v, :) = normalized_signal;
        end
        fprintf("Complete \n");
    end

    dict_name = return_file_name(simulation, 'dictionary');
        
    fprintf("Saving... \n");
    save(dict_name, 'dictionary', '-v7.3');

    fprintf("Creation complete \n\n");
    
end
