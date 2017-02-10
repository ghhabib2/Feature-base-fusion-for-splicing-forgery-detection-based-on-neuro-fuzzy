function [ output_ImageHistogram ] = func_HistogramOfDctCoff( input_ImageBlocks )
% func_DCTCoffHistogram Summary of this function goes here
% This function gets the inpout dct cofficents blocks. And return a 8x8
% matrix contain the histogram of the dct cofficents
%Create a zero 8x8 matrix
%Get the size of the INput
[rows columns colorspaces]=size(input_ImageBlocks);

% Define a cell of arrays
ImageHistogram=cell(1,6);

% Define an empty array for each of items
for i=1:6
ImageHistogram{1,i}=cell(1,3);
end

%Solit each of the channels to two seperatd part for holding the
%informaiton of period for related color channel
for i=1:6
    for j=1:3
        ImageHistogram{1,i}{1,j}=cell(1,3);
    end
end




for row=1:rows
    for col=1:columns
        %get the target Block
        targetBlock=input_ImageBlocks{row,col};
        %Read each item of the block and then write item to the target
        %Convert 2-D block to the vector;
        if(isempty(targetBlock(:,:,1))==0) 
        targetVector1=targetBlock(:,:,1);
        targetVector2=targetBlock(:,:,2);
        targetVector3=targetBlock(:,:,3);
        
        % Get the low frequency quaficents
        freqY=zeros(1,6);
        freqU=zeros(1,6);
        freqV=zeros(1,6);
        
        freqY(1,1)=targetVector1(1,1);
        freqY(1,2)=targetVector1(1,2);
        freqY(1,3)=targetVector1(1,3);
        freqY(1,4)=targetVector1(2,1);
        freqY(1,5)=targetVector1(2,2);
        freqY(1,6)=targetVector1(3,1);
        
        freqU(1,1)=targetVector2(1,1);
        freqU(1,2)=targetVector2(1,2);
        freqU(1,3)=targetVector2(1,3);
        freqU(1,4)=targetVector2(2,1);
        freqU(1,5)=targetVector2(2,2);
        freqU(1,6)=targetVector2(3,1);
        
        
        
        freqV(1,1)=targetVector3(1,1);
        freqV(1,2)=targetVector3(1,2);
        freqV(1,3)=targetVector3(1,3);
        freqV(1,4)=targetVector3(2,1);
        freqV(1,5)=targetVector3(2,2);
        freqV(1,6)=targetVector3(3,1);
        
%         targetVector1=targetVector1';
%         targetVector2=targetVector2';
%         targetVector3=targetVector3';
        
%         targetVector1=targetVector1(:);
%         targetVector2=targetVector2(:);
%         targetVector3=targetVector3(:);
        
        % get the size of the block
%         [brows bcols spaces]=size(targetVector1);
        % surf in the vector
        
        %Frist frequency
        
        
        for j=1:6
            
            tempHistItem=ImageHistogram{1,j};
            
            tempYChannelHist=tempHistItem{1,1}{1,1};
            tempUChannelHist=tempHistItem{1,2}{1,1};
            tempVChannelHist=tempHistItem{1,3}{1,1};
            
            tempYChannelHist=[tempYChannelHist;freqY(1,j)];
            tempUChannelHist=[tempUChannelHist;freqU(1,j)];
            tempVChannelHist=[tempVChannelHist;freqV(1,j)];
            
            tempHistItem{1,1}{1,1}=tempYChannelHist;
            tempHistItem{1,2}{1,1}=tempUChannelHist;
            tempHistItem{1,3}{1,1}=tempVChannelHist;
            
            ImageHistogram{1,j}=tempHistItem;
            
            end
        end
    end
end

%Callculate the periods and put their values in the outpu
%   Size of the Output Histogram Band
[histRow histCol histBand]=size(ImageHistogram);
%Loop for calculating the Histogram and return it back to the 

for i=1:histCol
    % Y Channel
    tempChannel=ImageHistogram{1,i}{1,1}{1,1};
    p=func_periodFinder(tempChannel);
    ImageHistogram{1,i}{1,1}{1,2}=p;
    % U Channel
    tempChannel=ImageHistogram{1,i}{1,2}{1,1};
    p=func_periodFinder(tempChannel);
    ImageHistogram{1,i}{1,2}{1,2}=p;
    % V Channel
    tempChannel=ImageHistogram{1,i}{1,3}{1,1};
    p=func_periodFinder(tempChannel);
    ImageHistogram{1,i}{1,3}{1,2}=p;
end

 output_ImageHistogram=ImageHistogram;
return

