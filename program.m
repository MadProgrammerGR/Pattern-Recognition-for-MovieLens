addpath("lib");

close('all');
clear;

%data = dlmread("ml-100k/u.data");
%
%data = sortrows(data,1); % ta3inomhsh me vash to user_id
%N = 100000; % plh8os va8mologhsewn
%M = 1682; % plh8os tainiwn
%
%N_users = 943;
%X = zeros(N_users,M);
%j = 1;
%previd = data(1,1);
%for i=1:N
%  id = data(i,1);
%  movie = data(i,2);
%  if id == previd
%    X(j,movie) = data(j,3);%1; % se periptwsh rating, edw
%  else
%    j = j + 1;
%  end
%  previd = id;
%end
%%X = X';
%X = pca(X,0.1)';

% dhmiourgia tou pinaka dianysmatwn xarakthristikwn apo to tropopoihmeno dataset
data = importdata("rating_scores_data.csv", ",", 1).data; % xwris to header
% eleipes times, dld otan o xrhsths den exei va8mologhsei kamia tainia me to sygkekrimeno genre
data(isnan(data)) = 3;
User_ID = data(:,1)'; %kratame ta id mhpws xreiastoun
%xwris th prwth sthlh alla kai anastrofo wste ka8e sthlh na apotelei ena dianysma xarakthristikwn
X = data(:,4:end)'; 
%X = data(:,2:end)';
%X = data(:,4:end);
%X = pca(X,0.1)'; 

[l,N] = size(X);
clear data;

%for i = 1:N
%  [~,index] = sort(X(:,i),"descend");
%  X(index,i) = 1:l; % = [genre1=3 genre2=5 ...]
%%  X(:,i) = index;
%end

% kanonikopoihsh dedomenwn (ana grammh dld ana xarakthristiko)
%X = zscore(X, 0, 2);

% grafikh parastash 100 tyxaiwn dianysmatwn
%order = randperm(N);
%for i = 1:100
%%  if X(1,order(i)) < 0
%%    plot(X(:,order(i)),'b'),hold on
%%  else
%%    plot(X(:,order(i)),'r'),hold on
%%  endif
%  plot(X(:,order(i))),hold on
%endfor

% vriskoume tis min/max apostaseis meta3y twn dianysmatwn tou X
mind = Inf;
maxd = 0;
for i = 1:N
    for j = (i+1):N
%        d = sum((X(:,i)-X(:,j)).^2); %euklideia
        d = sqrt(sum((X(:,i)-X(:,j)).^2)); %euklideia
%        d = sum(abs(X(:,i)-X(:,j))); %manhattan
        if d < mind
          mind = d;
        elseif d > maxd
          maxd = d;
        endif
    endfor
endfor


% ypologismos eurous tou theta
n_theta = 40;
theta_range = linspace(mind, maxd, n_theta);
%theta_range = linspace(60,75,n_theta);
%meand = (mind+maxd)/2;
%theta_min = .25*meand;
%theta_max = 1.75*meand;
%theta_range = linspace(theta_min, theta_max, n_theta);

% efarmozoume n_times fores ton BSAS gia ka8e timh tou theta
n_times = 5;
q = N; % orizoume ws anwfli plh8ous klasewn enan mh perioristiko ari8mo
m_total = []; % plh8os klasewn pou proekypse apo ka8e timh tou theta
for theta = theta_range
    list_m = zeros(1, q); % poses fores emfanisthke to ka8e plh8os klasewn
    for stat = 1:n_times
        order = randperm(N); % tyxaia seira eisodwn twn dianysmatwn
        [~, repre] = BSAS(X,theta,q,order);
        k = size(repre,2); % plh8os twn klasewn poy proekypsan
        list_m(k) = list_m(k)+1;
    endfor
    [~, m_size] = max(list_m); % pio plh8os proekypse tis perissoteres fores
    m_total = [m_total m_size];
endfor

plot(theta_range, m_total, '-o');
title("Number of clusters for each value of Theta");
xlabel("Distance threshold (Theta)");
ylabel("Number of clusters");

rmpath("lib");