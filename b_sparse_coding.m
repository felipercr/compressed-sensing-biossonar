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
% Define a non-computable mask
% =========================================================================
type = 'half_grid';
begin = 75;
nc_mask = create_nc_mask(simulation, type, begin);
simulation.set_nc_mask(nc_mask);


% =========================================================================
% If the dictionary for the problem was not created, create
% If any changes on the sensors array was done, it will need a new one
% =========================================================================
dict_name = return_file_name(simulation, 'dictionary');
if ~exist(dict_name, 'file')  
    create_dictionary(simulation, nc_mask);  % Create dictionary only if file doesn't exist
end
 

% =========================================================================
% Load dictionary
% =========================================================================
fprintf('\n');
fprintf("Loading dictionary... \n");
load(dict_name, 'dictionary');
fprintf("Dictionary loaded \n\n");


% =========================================================================
% Pre-process data for the oprimization problem
% =========================================================================

% The optimization problem is given by:
% arg min g, s.t. ||y - A*g||_2 ^2 + lambda*||g||_1 

% The dimentions of each component are:
% y(s, 1, t); A(s, v, t); g(v, 1)
%
% Where: s = number of sensors
%        v = number of voxels
%        t = number of time samples

% We need to reduce the dimentionality of the 3D tensors to 2D matrices for
% the solvers to work. So, the following code will "stack the time arrays
% on top of each other", while maintaining the v dimention, since it is the
% dimention of the vector g, our target.
%
% Therefore, the new dimentions will be:
% y(s*t, 1); A(s*t, v); g(v, 1)

y = simulation.sensor_data;
A = dictionary;

s = size(A, 1); v = size(A, 2); t = size(A, 3);

y_squeezed = squeeze(y);                 % Brings the t dimention to the s dimention
y_transposed = y_squeezed.'; 
y_stack = y_transposed(:);

A_permuted = permute(A, [3, 1, 2]);      % Reorder dimensions: (t, s, v)
A_stack = reshape(A_permuted, [s*t, v]); % Brings the t dimention to the s dimention
clear A_permuted;


% =========================================================================
% Call the optimization problem solver
% =========================================================================
fprintf("Solving the optimization problem... \n");
lambda = 0.001;  

% Matlab built-in lasso
[g, stats] = lasso(A_stack, y_stack, "Lambda", lambda);

% SPAMS implementation, needs external installation
%start_spams;
%param.lambda = lambda;
%param.mode = 2; % L1 regularization
%param.pos = false; % No non-negativity constraint
%param.tol = 1;
%param.itermax = 1;
%g = mexLasso(y_stack, A_stack, param);

fprintf("Optimization problem solved \n\n");


% =========================================================================
% Correct g with non computed voxels
% =========================================================================
g = add_nc_voxels(simulation, nc_mask, g);


% =========================================================================
% Save g
% =========================================================================
save('g.mat', 'g')


% =========================================================================
% Clear workspace
% =========================================================================
clearvars -except simulation;

