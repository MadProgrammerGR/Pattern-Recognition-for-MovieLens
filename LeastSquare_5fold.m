clear;
function [W,SuccessRate] = fold(id)
  data = importdata(strcat("5folds/ff_",num2str(id),".base.csv"), ",", 1).data;
  Y = data(:,3);
  X = data(:,4:end);
  clear data;
  W = inv(X'*X)*X'*Y; %least squares' optimal weights vector of hyperplane

  data = importdata(strcat("5folds/ff_",num2str(id),".test.csv"), ",", 1).data;
  Y = data(:,3);
  X = data(:,4:end);
  Guess = W'*X';
  SuccessRate = 1-sum(abs(round(Guess')-Y))/length(Y);
endfunction

Wbest = [];
bestSuccessRate = 0;
for id=0:4
  [W,SuccessRate] = fold(id);
  if SuccessRate > bestSuccessRate
    bestSuccessRate = SuccessRate;
    Wbest = W;
  endif
endfor

bestSuccessRate
Wbest
