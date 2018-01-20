clear;
function [W,SuccessRate] = fold(id)
  data = importdata(strcat("5folds/ff_",num2str(id),".base.csv"), ",", 1).data;
  Y = data(:,3);
  Y(Y==0) = -1;
  X = data(:,4:end);
  clear data;
  W = inv(X'*X)*X'*Y; %least squares' optimal weights vector of hyperplane

  data = importdata(strcat("5folds/ff_",num2str(id),".test.csv"), ",", 1).data;
  Y = data(:,3);
  Y(Y==0) = -1;
  X = data(:,4:end);
  Guess = W'*X';
  Guess(Guess>0)=1;
  Guess(Guess<0)=-1;
  SuccessRate = sum(Guess'==Y)/length(Y);
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
