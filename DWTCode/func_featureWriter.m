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
   featureVector=func_DWTCode(imagePath);
   
   % Create the query for writing result in Database again
   
   featureVector=[imageId featureVector];
   
   values=[values;featureVector];
   
   
end

colList={'imageId','f1','f2','f3','f4','f5','f6','f7','f8','f9','f10','f11','f12','f13','f14','f15','f16','f17','f18','f19','f20','f21','f22','f23','f24','f25','f26','f27','f28','f29','f30','f31','f32','f33','f34','f35','f36','f37','f38','f39','f40','f41','f42','f43','f44','f45','f46','f47','f48','f49','f50','f51','f52','f53','f54','f55','f56','f57','f58','f59','f60','f61','f62','f63','f64','f65','f66','f67','f68','f69','f70','f71','f72','f73','f74','f75','f76','f77','f78'};

fastinsert(conn,'t_dwtfeatures',colList,values);

end

