function output_featureVector = func_wavletFeatureCalculator(input_Histogram)
%FUNC_WAVLETFEATURECALCULATOR Summary of this function goes here
%   Get the normalized Histogram az input and calculate the feater vector

% Calculate the fft of the histogram
Y=fft(input_Histogram{1,1});

% Calculate the Frequency vector of  FFT
fs=1; % It is an image and in the image the color increses by the factor of 1 as the result FS is One

N=length(input_Histogram{1,2});

% Frequency Domain
f=(0:N-1)*(fs/N);


% Calculate the di moments
sum=0;
momentSum1=0;
momentSum2=0;
momentSum3=0;
momentSum4=0;
for i=1:N/2
    sum=sum+abs(Y(i));
    momentSum1=momentSum1+(f(i)^1)*(abs(Y(i)));
    momentSum2=momentSum2+(f(i)^2)*(abs(Y(i)));
    momentSum3=momentSum3+(f(i)^3)*(abs(Y(i)));
end

M1=momentSum1/sum;
M2=momentSum2/sum;
M3=momentSum3/sum;


output_featureVector=[M1 M2 M3];

return

