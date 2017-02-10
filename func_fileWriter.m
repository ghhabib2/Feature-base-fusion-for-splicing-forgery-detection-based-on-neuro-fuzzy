function bool_outPut = func_fileWriter( input_args )
%FUNC_FILEREADER Summary of this function goes here
%   Detailed explanation goes here
% Read the informaton of the images from hard drive and return the list of
% them

%Connection To database
con=func_Dbconnector();

filePath='D:\ImageDataSet\4cam_auth\';
fileString='D:\\ImageDataSet\\4cam_auth\\'
func_InsertFiles(filePath,fileString,0,1,con);
filePath='D:\ImageDataSet\4cam_splc\';
fileString='D:\\ImageDataSet\\4cam_splc\\'
func_InsertFiles(filePath,fileString,1,1,con);

return

% Insert the information of file to Database based on the inserted
% Directory Path
%<parameters>
% Path = Image Path
% Label = 1 if image is forged and 0 if image is not forged
% ImageGroup=Test Group Id (A figure bigger than 1)
% conn=Connection to Database
%</parameters>
function bool_outPut=func_InsertFiles(path,filestring,label,imageGroup,conn)


% Get the list of files
fileList=dir(path);
% Get the size of returned list
[rows cols dimension]=size(fileList);

for i=1:rows
    % Read each of the records
    tempRec=fileList(i);
    
    if(tempRec.isdir==0)
        
        % Get file type
        filePath=tempRec.name(end-3:end);
        
        % Find out whether the image is an tif image or not
        if(strcmp(filePath,'.tif'))
        
        % The target is a file read it and save the information of the file
        % in a dataset.
        
        
        filePath=[filestring tempRec.name];
        % Create the value string
        colValues=['''' filePath '''' ',' num2str(label) ','   num2str(imageGroup)];   
        
        % Create the query
        script=['insert into t_images(imagePath,isForgery,imageSet) values(' colValues ');']; 
        
        % Excute the query
        bool_outPut=exec(conn,script);
           
        end
        
    end
        
end

return

