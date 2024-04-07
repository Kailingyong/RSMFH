function [W1,W2,B,obj] = slove_RSMFH(X, Y, L, param)

fprintf('training...\n');

%% set the parameters
nbits = param.nbits;
lambdaX = param.lambdaX;
lambdaY = 1-lambdaX;
alpha = param.alpha;
mu = param.mu;
gamma = param.gamma;
beta = param.beta;
lastF = 99999999;
threshold = 0.01;
obj = [];


%% get the dimensions
[n, dX] = size(X);
dY = size(Y,2);
% options.WeightMode = 'Cosine';

%% transpose the matrices
% S = L * L';
X = X'; Y = Y'; 
L = L';
% W = constructW(L,options);
% S = 2 * W' * W - eye(n)' * eye(n);


%% initialization
% U1 = randn(dX, nbits);
% U2 = randn(dY, nbits);
% W1 = randn(nbits, dX);
% W2 = randn(nbits, dY);
E1 = randn(nbits, n);
E2 = randn(nbits, n);
V = randn(nbits, n);
B = sign(randn(nbits, n));
G1 = eye(nbits,nbits);
G2 = eye(nbits,nbits);
P = randn(nbits, size(L,1));

R = randn(nbits, nbits);
[U, ~, ~] = svd(R);
R = U(:,1:nbits);

%% iterative optimization
for iter = 1:param.iter
    
    % update B 
    B = sign( beta * R * V  + mu * P * L );
    
    % update U1 and U2 
    U1 = (X * (V + E1)')/((V + E1) * (V + E1)' + (gamma/lambdaX) * eye(nbits));
    U2 = (Y * (V + E2)')/((V + E2) * (V + E2)' + (gamma/lambdaY) * eye(nbits));
    
    % update E1 and E2 
    E1 = (U1' * U1 + (gamma/lambdaX) * G1)\(U1' * (X - U1 * V) - (alpha/lambdaX) * E2);
    E2 = (U2' * U2 + (gamma/lambdaY) * G2)\(U2' * (Y - U2 * V) - (alpha/lambdaY) * E1);

    %update P
    P = mu * (B * L')/(mu * L * L' + gamma * eye(size(L,1)));

    % update V
    V1 = lambdaX * U1' * U1 + lambdaY * U2' * U2 + beta * R' * R  + gamma * eye(nbits);
    V2 = lambdaX * U1'* (X - U1 * E1) + lambdaY * U2' * (Y - U2 * E2) + beta * R' * B;
    V = V1\V2;
    
     % update R
    [S1, ~, S2] = svd(beta * B * V');
    R = S1*S2';
    
    % update G1 and G2 
    G11 = sqrt(sum(E1.*E1,2)+eps);   
    d1 = 0.5./G11;  
    G1 = diag(d1);
    
    G22 = sqrt(sum(E2.*E2,2)+eps);   
    d2 = 0.5./G22;  
    G2 = diag(d2);
    
    %objective function
    norm1 = lambdaX * norm(X - U1 * (V + E1), 'fro');
    norm2 = lambdaY * norm(Y - U2 * (V + E2), 'fro');
    norm3 = alpha * trace(E1 * E2');
    norm4 = mu * norm(B - P * L,'fro');
    norm5 = beta * norm(B - R * V,'fro');
    norm6 = gamma * trace(E1' * G1 * E1) + gamma * trace(E2' * G2 * E2);
    norm7 = gamma * (norm(U1, 'fro') + norm(U2, 'fro') + norm(P, 'fro')  + norm(V, 'fro'));
    currentF = norm1 + norm2 + norm3 + norm4 + norm5 + norm6 + norm7;
    fprintf('current obj: %.4f\n', currentF);
    
    
    obj = [obj;currentF];
end


W1 = (B * X')/(X * X'+ gamma * eye(dX));
W2 = (B * Y')/(Y * Y'+ gamma * eye(dY));

% W1 = (V * X')/(X * X'+ gamma * eye(dX));
% W2 = (V * Y')/(Y * Y'+ gamma * eye(dY));
end
