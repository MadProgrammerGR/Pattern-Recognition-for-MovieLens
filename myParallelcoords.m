%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple minimalistic matlab's parallelcoords implemetation 
% using plot for compatability with octave. Works for up to a total of 7 groups.
% 
% INPUT ARGUMENTS:
%  X:      An NxL matrix where each row represents one observation.
%  Group: A vector of length N where i element 
%          represents the group that the Xi observation belongs to.
%  Labels: A cell array of strings of size L for the x-axis labels.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function myParallelcoords(X, Group, Labels)
  [N,L] = size(X);
  if length(Group) != N || length(Labels) != L
    error("Number of observation rows must match number of Labels"); return;
  endif
  
  figure;
  M = mean(X); %ana sthlh
  [~,index] = sort(M,"descend");
  [g,ig] = sort(Group); 
  g = unique(g);
  pale=['r'; 'g'; 'b'; 'y'; 'm'; 'c';'k'];
  prevC='_';
  ps = [];
  for i = 1:N
    color = pale(find(g==Group(ig(i))));
    p = plot(X(ig(i),index),'Color',color);
    hold on;
    if prevC != color
      ps = [ps p];
    endif
    prevC = color;
  endfor
  legend(ps,g);
  set(gca,'xtick',1:L);
  set(gca,'xticklabel',Labels(index));
endfunction
