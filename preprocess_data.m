clear;
data = dlmread("ml-100k/u.data");

X = sortrows(data,1); % ta3inomhsh me vash to user_id
N = 100000; % plh8os va8mologhsewn
M = 1682; % plh8os tainiwn

N_users = 943;
Y = zeros(N_users,M);
j = 1;
previd = X(1,1);
for i=1:N
  id = X(i,1);
  movie = X(i,2);
  if id == previd
    Y(j,movie) = 1; % se periptwsh rating, edw
  else
    j = j + 1;
  end
  previd = id;
end



