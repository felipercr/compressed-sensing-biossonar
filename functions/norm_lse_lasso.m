function x = norm_lse_lasso(F, g, gamma)
    % Resolve: minimize ‖Fx - g‖₂ + γ‖x‖₁ sujeito a 0 ≤ x ≤ 1
    
    [~, res] = mosekopt('symbcon echo(0)');
    n = size(F, 2);  % Número de variáveis
    k = size(g, 1);   % Número de observações
    
    % Estrutura do problema
    prob.c = [zeros(2*n, 1); 1; gamma];  % Objetivo: t1 + γ*t2
    
    % Restrições para reformulação L1 (|x| ≤ u via -u ≤ x ≤ u)
    prob.a = [eye(n),  eye(n), zeros(n, 2);   %  x + u ≥ 0
             -eye(n),  eye(n), zeros(n, 2);   % -x + u ≥ 0
             zeros(1, n), -ones(1, n), 0, 1]; % sum(u) ≤ t2
    
    % Limites das restrições
    prob.blc = [zeros(2*n, 1); 0];   % Limites inferiores
    prob.buc = [inf*ones(2*n, 1); inf]; % Limites superiores
    
    % Limites das variáveis (0 ≤ x ≤ 1)
    prob.blx = [zeros(n, 1);    % x ≥ 0
                -inf*ones(n, 1); % u sem limite inferior
                0;              % t1 ≥ 0
                0];             % t2 ≥ 0
    prob.bux = [ones(n, 1);     % x ≤ 1
                inf*ones(n, 1);  % u sem limite superior
                inf;            % t1 sem limite
                inf];           % t2 sem limite
    
    % Cone quadrático para a norma L2 (‖Fx - g‖₂ ≤ t1)
    prob.f = sparse([zeros(1, 2*n), 1, 0; F, zeros(k, n+2)]);
    prob.g = [0; -g];
    prob.accs = [res.symbcon.MSK_DOMAIN_QUADRATIC_CONE k+1];
    
    % Resolver
    [~, res] = mosekopt('minimize echo(0)', prob);
    x = res.sol.itr.xx(1:n);  % Extrair a solução
end