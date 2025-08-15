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

% =========================================================================
% Generate visible section
% =========================================================================
aperture_angle_degrees = 60;
visible_section = return_visible_section(simulation, aperture_angle_degrees);


% =========================================================================
% Calculate accuracy
% =========================================================================
result_map = simulation.result_map;

obj_loaclization_accuracy = (sum(visible_section .* result_map) / sum(visible_section)) * 100;

obj_shape_error = (sum(~visible_section .* result_map) / sum(~visible_section)) * 100;


% =========================================================================
% Accuracy plot
% =========================================================================
plot = 1;
fig = gen_accuracy_plot(visible_section, result_map, plot);
saveas(fig, return_file_name(simulation, 'accplt'));


% =========================================================================
% Clear workspace
% =========================================================================
clearvars -except simulation obj_loaclization_accuracy obj_shape_error;