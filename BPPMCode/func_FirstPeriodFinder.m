function period = func_FirstPeriodFinder(Block)
% PEACKFINDER gets a histogram and find period p based on the idea of the
% paper
%Firs of all the s_max,s_min and s_0 should be finded

% Calculate the histogram of Block
blockHist=hist(Block,60);


%Get the size of histogram vector

noneZeroItems=find(blockHist);
[row columns dem]=size(noneZeroItems);
s_min=noneZeroItems(1);
s_max=noneZeroItems(columns);
[val,s_0]=max(blockHist);

%Celling array that holding the result of estimation
Hp=[];
temperoryPInterval=[1:round(s_max/20)];

for p=temperoryPInterval
    i_max=floor((s_max-s_0)/p);
    i_min=ceil((s_min-s_0)/p);
    h_p=0;
    for i=i_min:i_max
        item=i*p+s_0;
        h_p=h_p + blockHist(item);
    end
    h_p=h_p*(1/(i_max-i_min+1));
    Hp=[Hp;h_p];
end

%	Get the one part of estimation
[val,firstEstimation]=max(Hp);
% Now second part of estimation should be down basd on FFT spectrum of
% histogram

% Get the second estimation based on 

period=firstEstimation;
return;

