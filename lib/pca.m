function Y = pca(X,percentage)
  if percentage <= 0 || percentage >= 1
    percentage = 0.8;
  end
  
  S = std(X); % ka8e sthlhs
  [SS, I] = sort(S,'descend'); % SS = S(i)
  total = sum(SS);
  N = length(SS);
  j = 1;
  _sum = 0;
  while _sum < percentage*total
    _sum = _sum + SS(j);
    j = j+1;
  end
  Y = X(:,I(1:j));
end