function [classificationResults,svmScore] = func_SVMClasssifier(trainingData,testData,labelsData)
%FUNC_SVMCLASSSIFIER Summary of this function goes here
%   SVM classifier used in this project

%This classifier has three main steps:
% 1- An adaboost classifier tun in the data two select the most powrfull
% features from each feature vectors.
% 2- SVM classifier use the result of step one used for training an SVM
% classifier
% 3- classfied DVM feed by test Data and final result extraced as one of
% the output parameters
% 4- Result of step 3, used for generation of posterior probablity equvalet
% to each data which generates the second output of the function


% Get the lenght of the Data
[row col dim]=size(trainingData);
% Adaboost the feature vector
Ensemble=fitensemble(trainingData,labelsData,'AdaBoostM1',row,'Tree');

% Train an svm classifiyer using tha adaboosted Training Data.
% Calculate Final feature vector
X=[];

for i=1:row
   for j=1:col
       X(i,j)=trainingData(i,j)* Ensemble.TrainedWeights(i,1);
   end
end

% Train Stron Classifier
SVMModel = fitcsvm(X,labelsData,'KernelFunction','rbf');

ScoreSVMModel=fitSVMPosterior(SVMModel);

[classificationResults,svmScore]=predict(ScoreSVMModel,testData);


end

