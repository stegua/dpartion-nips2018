% WARNING: This function is partially based on the code available on this
%          Website: http://marcocuturi.net/SI.html

function [distance] = myFS(a, b, A, lambda, maxIter, tol, verbose, C)

    % Set default values for basic parameters
    if nargin < 5 || isempty(maxIter)
        maxIter = 5000;
    end
    
    if nargin < 6 || isempty(tol)
        tolerance = 0.1e-5;
    end
    
    if nargin < 7 || isempty(verbose)
        verbose = false;
    end
    
    % Initialize the matrices
    n = length(A);
    v = reshape(ones(length(a),1)/length(a), n, n);
    a = reshape(a, n, n);
    b = reshape(b, n, n);
    
    % NOTE: matrix K is Kronecker, hence K = E tenser E
    % SEE: https://en.wikipedia.org/wiki/Kronecker_product
    E = exp(-lambda*A);
    % Avoid too small values 
    % REMARK: Uncomment the following can give a speed up, but 
    %         it introduces several numerical stability issues
    % E(E<1e-100) = 1e-100;

    % Main Sinkhorn loop, where the product K*u and K*v are optimized    
    for k = 1:maxIter
        KV = E*v*E;
        u = a./KV;
                
        KU = E*u*E;
        v = b./KU;
                
        if mod(k, 20) == 1 || k == maxIter
            KV = E*v*E;
            u = a./KV;        
            KU = E*u*E;                
            Criterion = norm(sum(abs(v.*(KU) - b)), Inf);
                        
            if verbose
                disp(join([num2str(k), ' ', num2str(Criterion)]));
            end
            if Criterion < tolerance || isnan(Criterion)
                break;
            end
        end
    end
    
    % Final Kantorovich-Wasserstein distance
    distance = sum(u(:).*(((kron(E,E).*C)*v(:))));
end