function x_opt = osqp_lasso(A, b, lambda)
    [m, n] = size(A);
    
    % Objective: min (1/2)x'(A'A)x - (A'b)'x + λ sum(t)
    P = A' * A;
    q = -A' * b;
    
    % Slack variables: -t ≤ x ≤ t (equivalent to |x| ≤ t)
    % Reformulate as:
    % x - t ≤ 0
    % -x - t ≤ 0
    A_ineq = [sparse(eye(n)), -sparse(eye(n));  % x - t ≤ 0
              -sparse(eye(n)), -sparse(eye(n))]; % -x - t ≤ 0
    l_ineq = -inf(2*n, 1);
    u_ineq = zeros(2*n, 1);
    
    % OSQP data
    P_blk = blkdiag(P, sparse(n, n));  % [P, 0; 0, 0]
    q_aug = [q; lambda * ones(n, 1)];  % [q; λ*1]
    
    % Solve with OSQP
    prob = osqp;
    prob.setup(P_blk, q_aug, A_ineq, l_ineq, u_ineq, 'verbose', false);
    
    res = prob.solve();
    x_opt = res.x(1:n);  % Extract x (discard slack variables t)
end