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
  g = unique(Group);
  pale=['r'; 'g'; 'b'; 'y'; 'm'; 'c';'k'];
  for i = 1:N
    color = pale(find(g==Group(i)));
    plot(X(i,:),'Color',color);
    hold on;
  endfor
  set(gca,'xtick',1:L);
  set(gca,'xticklabel',Labels);
endfunction
