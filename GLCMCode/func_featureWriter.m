function [ output_args ] = func_featureWriter()
%FUNC_FEATUREWRITER Summary of this function goes here
%   This function get the input images list form the input and calculate
%   the feature for each of them and save the final resutls in the dataset.

inputImagesList=func_fileReader(1);

% Get the size of the Images List
[rows cols dim]=size(inputImagesList);

%make connection to Database
conn=func_Dbconnector();

% Diffine a empty matrix for holding the feature information that should
% store in database
values=[];

for i=1:rows
    
   % Read each record and
   imageId=inputImagesList{i,1};
   imagePath=inputImagesList{i,2};
   
   %Extract the feature for given image
   featureVector=func_GLCM(imagePath);
   
   % Create the query for writing result in Database again
   
  featureVector=[imageId featureVector];
   
   values=[values;featureVector];
   
   
end

colList={'imageId'};

for i=1:512
    feildname=['f' num2str(i)];
    colList{i+1}=feildname;
end

fastinsert(conn,'t_glcmfeatures',colList,values);

end

