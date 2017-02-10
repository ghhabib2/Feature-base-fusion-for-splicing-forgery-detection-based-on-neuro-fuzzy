function period = func_SecondPeriodFinder(Block)
% PEACKFINDER gets a histogram and find period p based on the idea of the
% paper

%Callculatio teh fft of Histogram
[histBlock xcenters]=hist(Block,60);
% Normalize the histogram
histBlock=histBlock/sum(histBlock);
HistBlock=fft(histBlock);
N=length(xcenters);
Q = ceil((N+1)/2);

fftanArea=abs(HistBlock(1:Q));

[pks loc]=findpeaks(fftanArea);

if(isempty(pks)==0)
    period=round(1/pks(1));
else
    % It means that the signal do not have any peak and then do not have
    % any period
    period=1;
end

return;

