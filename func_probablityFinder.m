function [ output_args ] = func_BPPMFinder(image)
%   This function is get the image blocks as Input and returns the BPPM map
%   as output. This map is going to be used for forgery detection using a
%   SVM classsifer. All the implimentation of this paper done based on the
%   Paper "Fast, automatic and fine-grained tampered JPEG image detection
%   via DCT coefficient analysis" Wittern by Zhouchen Lin, Junfeng, Xiaoou Tang, Chi-Keung Tang

% Start alghorithm by getting the image and change the color space to YUV
% and also calculate the DCT cofficents for each pixel based on the
% standard 8*8 dct matrix and by dviding the image to 8*8 image blocks. The
% output of this step is 8*8 image blocks that the value of pixels of them
% converted to DCT cofficents.
DCTCofficentsBlocks=func_ImageToDCTBlocks(image);

% In the next stepm these information sent to another function for
% calcualting the periods and information necessary for calculating the
% BPMM.
periodsANDDCTcofficentsHistogram=func_HistogramOfDctCoff(DCTCofficentsBlocks);


%In this step besian probablity calcualted based on group of histograms
%that has value bigger than 1. The input of this step is the size of our
%BPMM and the histograms and periods and the output would the BPMM map.
BPMM=



end

