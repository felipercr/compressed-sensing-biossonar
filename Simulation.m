% *************************************************************************
% Author: Felipe Reis Campanha Ribeiro
% Contact: felipercr.eng@gmail.com
% Institution: Telecom SudParis, 2025
%
% Title: Compressed Sensing on the Case of the Inverse Problem of a 
%        Biomimetic Sonar Inspired by Dolphin Echolocation
%
% Description:
% This code was developed by Felipe Reis for the experiments described in
% the above article. It is made publicly available to allow replication of
% the experiments and further development.
%
% License:
% This work is licensed under the MIT License (see LICENSE file in the 
% repository).
%
% Citation:
% If you use this code in your research or publications, please cite it
% accordingly
% *************************************************************************

classdef Simulation < handle


    % =====================================================================
    % Properties
    % =====================================================================
    properties
        % Simulation control
        sensor_type {mustBeInteger}
        n_sensors {mustBeInteger}
        emitter_type {mustBeInteger}
        image_number {mustBeInteger}
        simulation_time {mustBeFloat}
    end

    properties (SetAccess = private)
        % Variables that after set will be re-used, user protected
        kgrid
        medium
        alpha_coeff_medium
        sound_speed_medium
        source
        source_position
        sensor
        signal
        normalized_signal
        signal_characteristics
        obj_image
        sensor_data
        sensor_dictionary
        fig
        result_map
        n_cut
        nc_mask
    end



    % =====================================================================
    % Methods
    % =====================================================================
    methods
        %% Constructor %%
        function obj = Simulation(sensor_type, emitter_type, num_sensors, image_number, simulation_time)
            obj.sensor_type = sensor_type;
            obj.n_sensors = num_sensors;
            obj.emitter_type = emitter_type;
            obj.image_number = image_number;
            obj.simulation_time = simulation_time;
        end

        %% Creates the grid %%
        function create_grid(obj, Nx, Ny, dx, dy)
            obj.kgrid = kWaveGrid(Nx, dx, Ny, dy);
        end

        %% Loads the image containing the objects %%
        function load_object_image(obj, image_objects_file)
            image = imread(image_objects_file);
            
            if size(image, 3) == 3
                image = rgb2gray(image);                           % Convert to grey scale
            end

            image = imbinarize(image);
            image = imresize(image, [obj.kgrid.Nx obj.kgrid.Ny]);  % Redimention to the grid
            obj.obj_image = double(image);

        end

        %% Define medium proprieties %%
        function define_medium_properties(obj, sound_speed, objects_sound_speed, ...
                medium_density, alpha_coeff, objects_alpha_coeff, alpha_power)
            obj.sound_speed_medium = sound_speed;
            obj.alpha_coeff_medium = alpha_coeff;
            obj.medium.sound_speed = sound_speed * obj.obj_image + objects_sound_speed * (1 - obj.obj_image);
            obj.medium.density = medium_density * ones(obj.kgrid.Nx, obj.kgrid.Ny);   % Defining a uniform density
            obj.medium.alpha_coeff = alpha_coeff * obj.obj_image + objects_alpha_coeff * (1 - obj.obj_image);
            obj.medium.alpha_power = alpha_power;
        end

        %% Defines the position(s) of the source(s) %%
        function define_source_position(obj, source_x_pos, source_y_pos)
            switch obj.emitter_type
                case 1
                    obj.source.p_mask = zeros(obj.kgrid.Nx, obj.kgrid.Ny);
                    obj.source.p_mask(source_x_pos, source_y_pos) = 1;
                    obj.source_position = [source_x_pos, source_y_pos];
                case 2
                    % Create a source mask of a single line
                    obj.source.u_mask = zeros(obj.kgrid.Nx, obj.kgrid.Ny);
                    margin = 1;
                    obj.source.u_mask(source_x_pos, margin:obj.kgrid.Ny - margin) = 1;
            end
        end

        %% Defines the signal to be emitted from the source as a pulse %%
        function define_source_signal_pulse(obj, f_signal, n_periods, n_samples, magnitude, window)
            period = 1 / f_signal;
            pulse_time = n_periods * period;
            t_array = linspace(0, pulse_time, n_samples);
        
            obj.signal = magnitude*sin(2*pi*f_signal*t_array);
            if window
                kaiser_coeff = 5;
                obj.signal = obj.signal .* kaiser(n_samples, kaiser_coeff)';
            end

            if obj.emitter_type == 1
                obj.source.p = obj.signal; 
                obj.normalized_signal = obj.signal/max(abs(obj.signal(:)));
            elseif obj.emitter_type == 2
                obj.source.ux = obj.signal; 
            end

            obj.signal_characteristics.f_signal = f_signal;
            obj.signal_characteristics.n_samples = n_samples;
            obj.signal_characteristics.n_periods = n_periods;
            obj.signal_characteristics.magnitude = magnitude;
        end

        %% Defines source signal as a chirp %%
        function define_source_signal_chirp(obj)
            ... % TODO (challenging, it will need to re-analyze my definition of dt too)
        end

        %% Creates the simulation time array %%
        function create_time_array(obj)
            obj.kgrid.dt = (obj.signal_characteristics.n_periods * ...
                (1/obj.signal_characteristics.f_signal))/obj.signal_characteristics.n_samples;
            obj.kgrid.Nt = obj.simulation_time / obj.kgrid.dt;  % Nt = time / dt
            obj.kgrid.t_array = linspace(0, obj.simulation_time, obj.kgrid.Nt);
        end

        %% Check to see if the cfl is too high %%
        function check_cfl(obj)
            cfl = obj.medium.sound_speed * obj.kgrid.dt/obj.kgrid.dx;
            max_cfl = 0.3;
            if cfl > max_cfl
                error("CFL too high \n");
            end
        end

        %% Creates the sensor mask, there are multiple options %%
        function create_sensor_mask(obj, dist)
            num_sensors = obj.n_sensors;
            switch obj.sensor_type
                case 1
                    sensor_radius = dist;
                    sensor_arc_angle = pi;
                    angle_per_sensor = sensor_arc_angle/(num_sensors+1);

                    mid_x_pos = obj.kgrid.Nx;
                    mid_y_pos = obj.kgrid.Ny * 1/2;

                    obj.sensor.mask = zeros(obj.kgrid.Nx, obj.kgrid.Ny);
                    current_angle = angle_per_sensor;
                    for i = 1:num_sensors
                        x = round(sensor_radius * sin(current_angle) / obj.kgrid.dx);
                        y = round(sensor_radius * cos(current_angle) / obj.kgrid.dx);
                        obj.sensor.mask(mid_x_pos - x, mid_y_pos + y) = 1;
                        current_angle = current_angle + angle_per_sensor;
                    end

                case 2
                    x = dist;
                    space = obj.kgrid.Ny / (num_sensors + 1);
                    y_positions = round((1:num_sensors) * space);
                    obj.sensor.mask = zeros(obj.kgrid.Nx, obj.kgrid.Ny);
                    for i = 1:num_sensors
                        obj.sensor.mask(x, y_positions(i)) = 1;
                    end
            end
        end

        %% Runs the simulation %%
        function run_simulation(obj)
            % PMLInside defines the absorbing marging position
            obj.sensor_data = kspaceFirstOrder2D(obj.kgrid, obj.medium, ...
                obj.source, obj.sensor, PMLInside=false, PMLSize=15, ...
                PMLAlpha=2, PlotPML=false);
        end

        %% Visualize the results %%
        function visualize_results(obj)
            obj.fig = figure;
            time_axis = (0:size(obj.sensor_data, 2) - 1) * obj.kgrid.dt;
            if obj.sensor_type == 1
                y_angles = linspace(pi, 0, size(obj.sensor_data, 1)); 
                imagesc(time_axis * 1e6, y_angles, obj.sensor_data);
                colormap(getColorMap);
                ylabel('Sensor Angle [rad]');
                xlabel('Time [us]');
                colorbar;
            elseif obj.sensor_type == 2
                imagesc(time_axis * 1e6, 1:size(obj.sensor_data, 1), ...
                    obj.sensor_data, [-1, 1]);
                colormap(getColorMap);
                ylabel('Sensor number');
                xlabel('Time [us]');
                colorbar;
            end

        end

        %% Save the results as png %%
        function save_recording_image(obj)
            saveas(obj.fig, ['recording_images/rec_sen' num2str(obj.sensor_type) '_ob' ...
                num2str(obj.image_number) '.png']);
        end

        %% Removes everything before final_time = 0 %%
        function remove_emitter_signal(obj, final_time)
            n_time = round(final_time / obj.kgrid.dt);
            obj.n_cut = n_time;
            obj.sensor_data = obj.sensor_data(:, n_time:end);

        end

        %% Normalizes each received signal independently %%
        function normalize_data(obj)
            max_vals = max(abs(obj.sensor_data), [], 2);  % Max along rows (dimension 2)
            max_vals(max_vals == 0) = 1;  
            obj.sensor_data = obj.sensor_data ./ max_vals;
        end

        %% Save the result map %%
        function set_result_map(obj, result_map)
            obj.result_map = result_map;
        end

        %% Add a awgn %%
        function awgn_to_measurements(obj, snr)
            obj.sensor_data = awgn(obj.sensor_data, snr, 'measured');
        end

        %% Define non computable mask %%
        function set_nc_mask(obj, nc_mask)
            obj.nc_mask = nc_mask;
        end
    end
end

