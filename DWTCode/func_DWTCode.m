function featureVector = func_DWTCode(inputImage)
%UNTITLED2 Summary of this function goes here
%   This tool get the input image and then return the features based on the
%   waveltet transform based on the article

% Get the target Image
targetImage=imread(inputImage);

% Convert the color space
targetImage=rgb2ycbcr(targetImage);

% Do the analyises in the Y channels
YcolorChannel=targetImage(:,:,1);

% Get the size of the image
[rows cols]=size(YcolorChannel);

YPredictionImage=zeros(rows,cols);

a=0;b=0;c=0;

for i=1:rows
    for j=1:cols
        % read the information of the pixels
        if(i>=rows)
            if(j<cols)
                YPredictionImage(i,j)=YcolorChannel(i,j+1);
            else
                YPredictionImage(i,j)=YcolorChannel(i,j);
            end
        end
        
        if(i<rows)
            if(j<cols)
                a=YcolorChannel(i+1,j);
                b=YcolorChannel(i,j+1);
                c=YcolorChannel(i+1,j+1);
                
                if(c<=min(a,b))
                    YPredictionImage(i,j)=max(a,b);
                elseif(c>=max(a,b))
                    YPredictionImage(i,j)=min(a,b);
                else
                    YPredictionImage(i,j)=a+b-c;
                end
               
            else
                YPredictionImage(i,j)=YcolorChannel(i+1,j);
            end
        end
    end
end

YcolorChannel=double(YcolorChannel);
YPredictionImage=double(YPredictionImage);
%calculate the error Image=
YErrorImage=abs(YcolorChannel-YPredictionImage);

% Get the Wavlet of Image and return the subabds if then

%Level 1 wavelet
[c s]=wavedec2(YcolorChannel,1,'db2');

% Return the subbBands of level 1;
IA1=wrcoef2('a',c,s,'db2',1);
IH1=wrcoef2('h',c,s,'db2',1);
IV1=wrcoef2('v',c,s,'db2',1);
ID1=wrcoef2('d',c,s,'db2',1);

%Level 2 wavelet
[c s]=wavedec2(YcolorChannel,2,'db2');

% Return the subbBands of level 2;
IA2=wrcoef2('a',c,s,'db2',2);
IH2=wrcoef2('h',c,s,'db2',2);
IV2=wrcoef2('v',c,s,'db2',2);
ID2=wrcoef2('d',c,s,'db2',2);

%Level 3 wavelet
[c s]=wavedec2(YcolorChannel,3,'db2');

% Return the subbBands of level 3;
IA3=wrcoef2('a',c,s,'db2',3);
IH3=wrcoef2('h',c,s,'db2',3);
IV3=wrcoef2('v',c,s,'db2',3);
ID3=wrcoef2('d',c,s,'db2',3);


% Waveltet of prediction Image
%===============================

%Level 1 wavelet
[c s]=wavedec2(YPredictionImage,1,'db2');

% Return the subbBands of level 1;
IEA1=wrcoef2('a',c,s,'db2',1);
IEH1=wrcoef2('h',c,s,'db2',1);
IEV1=wrcoef2('v',c,s,'db2',1);
IED1=wrcoef2('d',c,s,'db2',1);

%Level 2 wavelet
[c s]=wavedec2(YPredictionImage,2,'db2');

% Return the subbBands of level 2;
IEA2=wrcoef2('a',c,s,'db2',2);
IEH2=wrcoef2('h',c,s,'db2',2);
IEV2=wrcoef2('v',c,s,'db2',2);
IED2=wrcoef2('d',c,s,'db2',2);

%Level 3 wavelet
[c s]=wavedec2(YPredictionImage,3,'db2');

% Return the subbBands of level 3;
IEA3=wrcoef2('a',c,s,'db2',3);
IEH3=wrcoef2('h',c,s,'db2',3);
IEV3=wrcoef2('v',c,s,'db2',3);
IED3=wrcoef2('d',c,s,'db2',3);


% Get the Histogram of the image and each subban and ready them for
% extracting features

%Get the histogram of the image
ImageHist=func_NormalizedHistogram(YcolorChannel);
% Get the histogram of Level 1 wavelet of Image
IA1Hist=func_NormalizedHistogram(IA1);
IH1Hist=func_NormalizedHistogram(IH1);
IV1Hist=func_NormalizedHistogram(IV1);
ID1Hist=func_NormalizedHistogram(ID1);
% Get the histogram of Level 2 wavelet of Image
IA2Hist=func_NormalizedHistogram(IA2);
IH2Hist=func_NormalizedHistogram(IH2);
IV2Hist=func_NormalizedHistogram(IV2);
ID2Hist=func_NormalizedHistogram(ID2);
% Get the histogram of Level 3 wavelet of Image
IA3Hist=func_NormalizedHistogram(IA3);
IH3Hist=func_NormalizedHistogram(IH3);
IV3Hist=func_NormalizedHistogram(IV3);
ID3Hist=func_NormalizedHistogram(ID3);

%Get the histogram of the image
EImageHist=func_NormalizedHistogram(YErrorImage);

% Get the histogram of Level 1 wavelet of Error Image
IEA1Hist=func_NormalizedHistogram(IEA1);
IEH1Hist=func_NormalizedHistogram(IEH1);
IEV1Hist=func_NormalizedHistogram(IEV1);
IED1Hist=func_NormalizedHistogram(IED1);
% Get the histogram of Level 2 wavelet of Error Image
IEA2Hist=func_NormalizedHistogram(IEA2);
IEH2Hist=func_NormalizedHistogram(IEH2);
IEV2Hist=func_NormalizedHistogram(IEV2);
IED2Hist=func_NormalizedHistogram(IED2);
% Get the histogram of Level 3 wavelet of Error Image
IEA3Hist=func_NormalizedHistogram(IEA3);
IEH3Hist=func_NormalizedHistogram(IEH3);
IEV3Hist=func_NormalizedHistogram(IEV3);
IED3Hist=func_NormalizedHistogram(IED3);

% Start Calculating the final Features
featureVector=[];

% Image Features

featureVector=[featureVector func_wavletFeatureCalculator(ImageHist)];
featureVector=[featureVector func_wavletFeatureCalculator(IA1Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IH1Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IV1Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(ID1Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IA2Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IH2Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IV2Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(ID2Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IA3Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IH3Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IV3Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(ID3Hist)];

% Error Image Features
featureVector=[featureVector func_wavletFeatureCalculator(EImageHist)];
featureVector=[featureVector func_wavletFeatureCalculator(IEA1Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IEH1Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IEV1Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IED1Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IEA2Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IEH2Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IEV2Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IED2Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IEA3Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IEH3Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IEV3Hist)];
featureVector=[featureVector func_wavletFeatureCalculator(IED3Hist)];

% End of the alghorithm

return

