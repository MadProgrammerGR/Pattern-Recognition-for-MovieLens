close('all'); clear;
[headers,User_ID,X] = readData();
[l,N] = size(X);
m = 2;
init_repre = rand(18,m)*4+1;
[km_repre,km_bel] = k_means(X,init_repre);
printf("k-means cluster size: %d %d\n", sum(km_bel==1), sum(km_bel==2));
init_repre
km_repre

order = randperm(N);
%parallelcoords(X(:,order(1:100))','Group',km_bel(order(1:100)),'Labels',headers(2:end));
myParallelCoords(X(:,order(1:100))',km_bel(order(1:100)),headers(2:end));

dista = zeros(N,N);
for i=1:N
    for j=i+1:N
        dista(i,j)=distan(X(:,i),X(:,j));
        dista(j,i)=dista(i,j);
    endfor
endfor
% oi grammes tou bel einai me th seira oi omadopoihseis pou proekypsan
[bel,thres]=agglom(dista,1); % 1 for single link, 2 for complete link
Z=linkage(X','single','euclidean'); % aplou desmou
figure, dendrogram(Z);
