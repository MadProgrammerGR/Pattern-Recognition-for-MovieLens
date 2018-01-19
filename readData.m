function [headers,User_ID,X] = readData()
  % dhmiourgia tou pinaka dianysmatwn xarakthristikwn apo to tropopoihmeno dataset
  data = importdata("rating_scores_data.csv", ",", 1);
  headers = data.colheaders;
  data = data.data;
  User_ID = data(:,1)';
  %xwris th prwth sthlh alla kai anastrofo wste ka8e sthlh na apotelei ena dianysma xarakthristikwn
  X = data(:,2:end)';
  clear data;
  [l,N] = size(X);
  % eleipes times, dld otan o xrhsths den exei va8mologhsei kamia tainia me to sygkekrimeno genre
  for i = 1:l
    X(i,isnan(X(i,:))) = nanmean(X(i,:));
  end
endfunction
