% *************************************************************************
% Felipe Reis Campanha Ribeiro
% felipercr.eng@gmail.com
% Telecom SudParis, 2025
%
% ...
% *************************************************************************

% =========================================================================
% Load and calculate data
% =========================================================================
map = simulation.result_map;
apperture_angle = 60;
visible_section = return_visible_section(simulation, apperture_angle);
threshold_ratio = 0.1;
window_size = 5;
maxima_line = get_maxima_line(map, threshold_ratio, window_size);


% =========================================================================
% Reconstruction plot
% =========================================================================
plot = 1;
fig = gen_reconstructions_plot(maxima_line, map, visible_section, plot);


% =========================================================================
% Save image
% =========================================================================
saveas(fig, return_file_name(simulation, 'recplt'));


% =========================================================================
% Clear workspace
% =========================================================================
clearvars -except simulation obj_loaclization_accuracy obj_shape_error;


