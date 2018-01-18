function [bel,repre]=MBSAS(X,theta,q,order)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%  [bel, repre]=BSAS(X,theta,q,order)
% This function implements the BSAS (Basic Sequential Algorithmic Scheme)
% algorithm. It performs a single pass on the data. If the currently
% considered vector lies at a significant distance (greater than a given
% dissimilarity threshold) from the clusters formed so far a new cluster
% is formed represented by this vector. Otherwise the considered vector
% is assigned to its closest cluster. The results of the algorithm are 
% influenced by the order of presentation of the data.
%
% INPUT ARGUMENTS:
%  X:       lxN matrix, each column of which corresponds to an
%           l-dimensional data vector.
%  theta:   the dissimilarity threshold.
%  q:       the maximum allowable number of clusters.
%  order:   N-dimensional vector containing a permutation of the integers
%           1,2,...,N. The i-th element of this vector specifies the order of
%           presentation of the i-th vector to the algorithm.
%
% OUTPUT ARGUMENTS:
%  bel:     N-dimensional vector whose i-th element contains the
%           cluster label for the i-th data vector.
%  repre:   a matrix, each column of which contains the l-dimensional (mean) 
%           representative of each cluster.
%
% (c) 2010 S. Theodoridis, A. Pikrakis, K. Koutroumbas, D. Cavouras
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[l,N]=size(X);
if(length(order)==0)
    order=1:1:N;
end

% Cluster determination phase
n_clust=1;  % no. of clusters
[l,N]=size(X);
bel=zeros(1,N);
bel(order(1))=n_clust;
repre=X(:,order(1));
clusters_sizes=1; % posa dianysmata exei h ka8e klash
for i=2:N
   [m1,m2]=size(repre);
% Determining the closest cluster representative}}
   [s1,s2]=min(sqrt(sum((repre-X(:,order(i))*ones(1,m2)).^2))); %euklideia
%   [s1,s2]=min(sum(abs(repre-X(:,order(i))*ones(1,m2)))); %manhattan
   if(s1>theta) && (n_clust<q)
       n_clust=n_clust+1;
       bel(order(i))=n_clust;
       repre=[repre X(:,order(i))];
       clusters_sizes=[clusters_sizes 1]; % h kainourgia klash exei mono 1, ton antiproswpo
   end
end

for i=1:N
  if bel(order(i))==0
    [m1,m2]=size(repre);
    [s1,s2]=min(sqrt(sum((repre-X(:,order(i))*ones(1,m2)).^2))); %euklideia
    bel(order(i))=s2;
    clusters_sizes(s2)=clusters_sizes(s2)+1; % topo8eth8hke sthn klash s2
    % twra isxyei oti: sum(bel==value) == clusters_sizes(value)
    repre(:,s2)=((clusters_sizes(s2)-1)*repre(:,s2) + X(:,order(i)))/clusters_sizes(s2);
  end
end
