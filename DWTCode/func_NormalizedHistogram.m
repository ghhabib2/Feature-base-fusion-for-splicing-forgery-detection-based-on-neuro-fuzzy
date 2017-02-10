function normalizedHistogram = func_NormalizedHistogram(input_data)
%FUNC_NORMALIZEDHISTOGRAM Summary of this function goes here
% Get the Data and return Normalized Histogram information

max_Color=floor(max(max(input_data)));
min_Color=round(min(min(input_data)));

% Set the ceneters of histogram
xcenteres=[min_Color:max_Color];

% Convert matrix to vector
input_data=input_data(:);

% Find the Normalized histogram of the Image
[nelements xcenteres]=hist(input_data,xcenteres);

nelements=nelements/sum(nelements);

normalizedHistogram=cell(1);

normalizedHistogram{1}=nelements;
normalizedHistogram{2}=xcenteres;

return

