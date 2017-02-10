function period = func_periodFinder(Block)
% PEACKFINDER gets a histogram and find period p based on the idea of the
% paper
%Firs of all the s_max,s_min and s_0 should be finded

% Frist Method for estimation of Period
FirstPeriod=func_FirstPeriodFinder(Block);
% Second Method for estimaton of Period
SecondPeriod=func_SecondPeriodFinder(Block);

%   Final Estimation of period
period=min([FirstPeriod SecondPeriod]);

return;

