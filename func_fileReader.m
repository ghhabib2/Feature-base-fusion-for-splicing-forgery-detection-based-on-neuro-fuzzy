function file_List = func_fileReader(testGroup)
%FUNC_FILEREADER Summary of this function goes here
%   Read the list of file from dataset based on the test dataset group and

% Connect To Database
conn=func_Dbconnector();

% Create the syntax for fetching the Image List
syntax=['Select * from t_images where imageSet=' num2str(testGroup)];

output=exec(conn,syntax);

output=fetch(output);

file_List=output.Data;

return

