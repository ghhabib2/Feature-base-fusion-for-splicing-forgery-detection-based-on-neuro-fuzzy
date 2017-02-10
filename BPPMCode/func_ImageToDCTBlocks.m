% This function get the image path as input and return image matrix 8x8
% Blocks which its color space changed from RGB to YUV and also from
% unsigned Interger to signed one.
function imageMatrix=func_ImageToDCTBlocks(x)
% Read the Image
imageMatrix=imread(x);
imageMatrix=double(imageMatrix);

% Get the size of the image
[rows columns colorBandsNum]=size(imageMatrix);


%Set the values of the block sizes
cellNumers=floor(columns/8);
rowNumbers=floor(rows/8);
% Vectors Numbers that used for spliting images
blockVectorR = [8 * ones(1, rowNumbers), rem(rows, 8)];
blockVectorC = [8 * ones(1, cellNumers), rem(columns, 8)];

%ConvertImageColorspace form unsiged to signed.
for i=1:rows
    for j=1:columns
        imageMatrix(i,j,1)=imageMatrix(i,j,1)-128;
        imageMatrix(i,j,2)=imageMatrix(i,j,2)-128;
        imageMatrix(i,j,3)=imageMatrix(i,j,3)-128;
    end
end

% Convert color Space form RGB to YUV and then return the value to Image
% R as Red
%R=imageMatrix(:,:,1);
% G as Green
%G=imageMatrix(:,:,1);
% B as Blue
%B=imageMatrix(:,:,1);
%Convert to YUV
%Y = 0.299 * R + 0.587 * G + 0.114 * B;
%U = -0.14713 * R - 0.28886 * G + 0.436 * B;
%V = 0.615 * R - 0.51499 * G - 0.10001 * B;

%imageMatrix=cat(3,Y,U,V);
imageMatrix=func_rgb2yuv(imageMatrix);
%imageMatrix=rgb2yuv(imageMatrix);

% Seperate different color channels of the image
ImageChannelY=imageMatrix(:,:,1);
ImageChannelU=imageMatrix(:,:,2);
ImageChannelV=imageMatrix(:,:,3);

%Now difine a temerory function for converting each channel to cofficent
%equvalent cofficent matrix
dctStandard=dctmtx(8);
dct = @(block_struct) dctStandard * block_struct.data * dctStandard';
ImageChannelYDCT = blockproc(ImageChannelY,[8 8],dct);
ImageChannelUDCT = blockproc(ImageChannelU,[8 8],dct);
ImageChannelVDCT = blockproc(ImageChannelV,[8 8],dct);

%Combine 3 Channels 3 Get a Data for from 3 different channels
imageMatrix=cat(3,ImageChannelYDCT,ImageChannelUDCT,ImageChannelVDCT);
% Convert Color Space to 8x8 blocks for extracting their features and
% return the results
imageMatrix=mat2cell(imageMatrix,blockVectorR,blockVectorC,colorBandsNum);
% Return the final value of the matrix. Based on the block structre which
% each block has 8x8 dimension.
return

