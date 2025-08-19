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

% clc;
% clearvars;
addpath("functions\")

% =========================================================================
% Simulation control
% =========================================================================
num_sensors = 11;
sensor_type = 1;
    % 1 = disc receiver
    % 2 = line receiver

emitter_type = 1;
    % 1 = point
    % 2 = flat

image_number = 1;
simulation_time = 280e-6; % [s]

simulation = Simulation(sensor_type, emitter_type, num_sensors, ...
    image_number, simulation_time);


% =========================================================================
% Defining the grid
% =========================================================================
% Defining the dimentions
Nx = 150;
Ny = 150;
% dx = 1e-3; % [m] Define as [mm]
dx = 1.5e-3; % [m] A bit bigger than the milimiter to improve the simulation
dy = dx;
simulation.create_grid(Nx, Ny, dx, dy);


% =========================================================================
% Loading the object images
% =========================================================================
image_objects_file = ['object_images/im' num2str(image_number) '.bmp'];
simulation.load_object_image(image_objects_file)


% =========================================================================
% Defining the medium proprieties 
% =========================================================================
% Black regions (immage == 0) will have different speeds (objetcs)
sound_speed = 1500;          % [m/s] We can change according to IFRMER's arcticle
objects_sound_speed = 800;   % [m/s] we don't put 0 to avoid artefacts
medium_density = 1000;       % [kg/m^3]
alpha_coeff = 0.75;          % [db/(MHz^y cm)]
objects_alpha_coeff = 200;   % [db/(MHz^y cm)]
alpha_power = 1.5;           % [dimentionless] y in the above exponent

simulation.define_medium_properties(sound_speed, objects_sound_speed, ...
    medium_density, alpha_coeff, objects_alpha_coeff, alpha_power);


% =========================================================================
% Defining the source
% =========================================================================
% Defining the position of the source point
source_x_pos = round(Nx * 19/24);
source_y_pos = round(Ny * 1/2);
simulation.define_source_position(source_x_pos, source_y_pos);

% Defining the signal
n_samples = 300;
f_signal  = 120e3;             % [Hz]
n_periods = 4;
if emitter_type == 1
    source_magnitude = 10;     % [Pa]
elseif emitter_type == 2
    source_magnitude = 0.3e-6; % [m/s] using u_mask instead of p_mask
end
window = 1;                    % We want to window the signal (kaiser window)

simulation.define_source_signal_pulse(f_signal, n_periods, n_samples, ...
    source_magnitude, window);


% =========================================================================
% Defining the time array
% =========================================================================
simulation.create_time_array();
simulation.check_cfl();


% =========================================================================
% Defining the sensor mask
% =========================================================================
if simulation.sensor_type == 1
    dist = 10e-2;                               % [m] Define circle radius
elseif simulation.sensor_type == 2
    dist =  round(simulation.kgrid.Nx * 18/24); % [m] Define the x coordinate
end
simulation.create_sensor_mask(dist);


% =========================================================================
% Running the simulation
% =========================================================================
simulation.run_simulation();


% =========================================================================
% Process the resulting data
% =========================================================================
end_of_click = 110e-6;
simulation.remove_emitter_signal(end_of_click);
simulation.normalize_data();
% snr = 0;
% simulation.awgn_to_measurements(snr);


% =========================================================================
% Visualisation
% =========================================================================
simulation.visualize_results();
simulation.save_recording_image();


% =========================================================================
% Clear workspace
% =========================================================================
clearvars -except simulation;