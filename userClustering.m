close('all'); clear;
[headers,User_ID,X] = readData();
[l,N] = size(X);
m = 2;
init_repre = rand(18,m)*4+1;
[km_repre,km_bel] = k_means(X,init_repre);
printf("k-means cluster size: %d %d\n", sum(km_bel==1), sum(km_bel==2));
init_repre
repre

%parallelcoords(X(:,1:100)','Group',km_bel(1:100),'Labels',headers(2:end));
myParallelCoords(X(:,1:100)',km_bel(1:100),headers(2:end));
