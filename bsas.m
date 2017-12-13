function [retval] = bsas (X, threshold, max_nr_of_cls)
  N = length(X);
  m = 1;
  C{1,m} = [1];
  for i = 2:N
    xi = X(i,:);
    for j = 1:m
      D(j) = sum((xi-C{2,j}).^2);
    endfor
    [d, k] = min(D);
    
    if d>threshold & m<max_nr_of_cls
      m = m+1;
      C{1,m} = i;
      C{2,m} = xi;
    else
      C{1,k} = [C{1,k} i];
      
      n = length(C{1,k});
      C{2,k} = ((n-1)*C{2,k}+xi)./n;
    endif
    
  endfor
  
  
endfunction
