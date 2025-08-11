% *************************************************************************
% Felipe Reis Campanha Ribeiro
% felipercr.eng@gmail.com
% Telecom SudParis, 2025
%
% ...
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