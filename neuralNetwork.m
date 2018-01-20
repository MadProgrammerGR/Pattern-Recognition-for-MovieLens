% X LxN
% Y 1xN
function [W,WW] = neuralNetwork(X,Y)
  [l,N]=size(X);
  X = [X;ones(1,N)];
  l = l+1;
  rate = 0.7;
  % 2 layers, 1 hidden 1 output
  % W = w_ini;
  k = 11; % neurwnes sto kryfo epipedo
  W = rand(k,l)*100; % arxikopoihsh olwn twn varwn tyxaia sto [0,100]
  WW = rand(1,k)*100; % ta varh tou neurwna e3odou

  max_iter=20000; % Maximum allowable number of iterations
  iter=0;         % Iteration counter
  J = 1;
  while J>0.01 && iter<max_iter
    iter=iter+1;
    % e3odos tou messaiou layer diastashs k x N 
    % dld y(2,123) = to apotelesma tou 2o neurwna gia to 123o dianysma(sthlh) tou x
    u = W*X;
    y = sigm(u);
    % e3odos tou teleutaiou epipedou (me ena neurwna) diastashs 1 x N
    uu = WW*y;
    yy = sigm(uu);
    % ypologismos synarthshs kostous gia ta twrina varh
    ei = yy-Y; % 1xN
    J = sum(0.5*ei.^2);

    ddelta = sigm_d(uu).*ei; % 1xN
    delta = sigm_d(u).*(WW'*ddelta); % kxN
    W = W - rate.*sum(delta')'*ones(1,L);% kxL
    WW = WW - rate.*(ddelta*y'); % 1xk
  end
endfunction

function y = sigm(x)
  y = 1./(1+e.^(-x));
endfunction

function y = sigm_d(x) %paragwgos ths apo panw sigmoeidhs
  t = sigm(x);
  y = t.*(1-t);
endfunction
