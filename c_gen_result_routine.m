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
% Load g
% =========================================================================
load('g.mat', 'g');


% =========================================================================
% Generate result
% =========================================================================
sigma = 5;         % Controls "spread" of influence 
threshold = 0.2;   % Filter everything below this value
plot = 1;          % Boolean, plot or not
[fig, map] = gen_result_map(simulation, g, sigma, threshold, plot);
simulation.set_result_map(map);


% =========================================================================
% Save result
% =========================================================================
saveas(fig, return_file_name(simulation, 'result'));


% =========================================================================
% Clear workspace
% =========================================================================
clearvars -except simulation;

