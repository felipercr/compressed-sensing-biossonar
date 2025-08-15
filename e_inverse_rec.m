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


