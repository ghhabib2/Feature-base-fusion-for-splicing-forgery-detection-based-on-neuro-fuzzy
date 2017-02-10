function featureOutput = func_GLCM(inputImage)
%UNTITLED Summary of this function goes here
%   This function get the image as input and return back the features
%   related to the Chroma based splicing detection

% Read the target Image
targetImage=imread(inputImage);



% Convert the color space to YCbCr One
targetImage=rgb2ycbcr(targetImage);

% Get the Egde Matrixes for Cb and Cr Channels

% Get the Cb Channel of the target Image
targetImageCbChannel=targetImage(:,:,2);

% Now get the Edge Images for Cb channel

% Get the size of the image
[rows cols]=size(targetImageCbChannel);

% Create an empty matrix which holds the information of E_h
targetImageCbChannelE_h=zeros(rows,cols);

for i=1:rows
    for j=1:cols
        % read the pixels one by one and find the equvalent E_h value
        if(i<rows)
            targetImageCbChannelE_h(i,j)=abs(targetImageCbChannel(i+1,j)-targetImageCbChannel(i,j));
        else
            targetImageCbChannelE_h(i,j)=targetImageCbChannelE_h(i-1,j);
        end
    end
end

% Create an empty matrix which holds the information of E_j
targetImageCbChannelE_j=zeros(rows,cols);

for i=1:rows
    for j=1:cols
        % read the pixels one by one and find the equvalent E_j value
        if(j<cols)
            targetImageCbChannelE_j(i,j)=abs(targetImageCbChannel(i,j+1)-targetImageCbChannel(i,j));
        else
            targetImageCbChannelE_j(i,j)=targetImageCbChannelE_h(i,j-1);
        end
    end
end

% Create an empty matrix which holds the information of E_d
targetImageCbChannelE_d=zeros(rows,cols);

for i=1:rows
    for j=1:cols
        % read the pixels one by one and find the equvalent E_d value
        if(i>=rows)
            if(j>=cols)
                targetImageCbChannelE_d(i,j)=targetImageCbChannelE_d(i,j);
            else
                targetImageCbChannelE_d(i,j)=abs(targetImageCbChannel(i,j+1)-targetImageCbChannel(i,j));            
            end
        elseif(i<rows)
            if(j<cols)
                targetImageCbChannelE_d(i,j)=abs(targetImageCbChannel(i+1,j+1)-targetImageCbChannel(i,j));            
            else
                targetImageCbChannelE_d(i,j)=abs(targetImageCbChannel(i+1,j)-targetImageCbChannel(i,j));
            end
        end
    end
end


% Create an empty matrix which holds the information of E_d
targetImageCbChannelE__d=zeros(rows,cols);

for i=1:rows
    for j=1:cols
        % read the pixels one by one and find the equvalent E_d value
        if(i<rows)
            if(j==1)
                targetImageCbChannelE__d(i,j)=abs(targetImageCbChannel(i+1,j)-targetImageCbChannel(i,j));
            else
                targetImageCbChannelE_d(i,j)=abs(targetImageCbChannel(i+1,j-1)-targetImageCbChannel(i,j));
            end
        else
            if(j==1)
                targetImageCbChannelE__d(i,j)=targetImageCbChannelE__d(i-1,j);
            else
                targetImageCbChannelE__d(i,j)=abs(targetImageCbChannel(i,j-1)-targetImageCbChannel(i,j));
            end
        end
    end
end

% Now treshold the values of each matrix based on the best treshold values.
% Base on the idea of the paer treshold T should be 7
t=7;
for i=1:rows
    for j=1:cols
        if(targetImageCbChannelE_h(i,j)>=t)
            targetImageCbChannelE_h(i,j)=t;
        end
        
        if(targetImageCbChannelE_j(i,j)>=t)
            targetImageCbChannelE_j(i,j)=t;
        end
        
        if(targetImageCbChannelE_d(i,j)>=t)
            targetImageCbChannelE_d(i,j)=t;
        end
        
        if(targetImageCbChannelE__d(i,j)>=t)
            targetImageCbChannelE__d(i,j)=t;
        end
    end
end

% Now Calculate the GLCM for the each of the eadge matrixes

CbCM_h=graycomatrix(targetImageCbChannelE_h);
CbCM_j=graycomatrix(targetImageCbChannelE_j);
CbCM_d=graycomatrix(targetImageCbChannelE_d);
CbCM__d=graycomatrix(targetImageCbChannelE__d);


%Calculate the GLCM for Cr color channels
% Get the Cb Channel of the target Image
targetImageCrChannel=targetImage(:,:,3);

% Now get the Edge Images for Cb channel

% Create an empty matrix which holds the information of E_h
targetImageCrChannelE_h=zeros(rows,cols);

for i=1:rows
    for j=1:cols
        % read the pixels one by one and find the equvalent E_h value
        if(i<rows)
            targetImageCrChannelE_h(i,j)=abs(targetImageCrChannel(i+1,j)-targetImageCrChannel(i,j));
        else
            targetImageCrChannelE_h(i,j)=targetImageCrChannelE_h(i-1,j);
        end
    end
end

% Create an empty matrix which holds the information of E_j
targetImageCrChannelE_j=zeros(rows,cols);

for i=1:rows
    for j=1:cols
        % read the pixels one by one and find the equvalent E_j value
        if(j<cols)
            targetImageCrChannelE_j(i,j)=abs(targetImageCrChannel(i,j+1)-targetImageCrChannel(i,j));
        else
            targetImageCrChannelE_j(i,j)=targetImageCrChannelE_h(i,j-1);
        end
    end
end

% Create an empty matrix which holds the information of E_d
targetImageCrChannelE_d=zeros(rows,cols);

for i=1:rows
    for j=1:cols
        % read the pixels one by one and find the equvalent E_d value
        if(i>=rows)
            if(j>=cols)
                targetImageCrChannelE_d(i,j)=targetImageCrChannelE_d(i,j);
            else
                targetImageCrChannelE_d(i,j)=abs(targetImageCrChannel(i,j+1)-targetImageCrChannel(i,j));            
            end
        elseif(i<rows)
            if(j<cols)
                targetImageCbChannelE_d(i,j)=abs(targetImageCrChannel(i+1,j+1)-targetImageCrChannel(i,j));            
            else
                targetImageCbChannelE_d(i,j)=abs(targetImageCrChannel(i+1,j)-targetImageCrChannel(i,j));
            end
        end
    end
end


% Create an empty matrix which holds the information of E_d
targetImageCrChannelE__d=zeros(rows,cols);

for i=1:rows
    for j=1:cols
        % read the pixels one by one and find the equvalent E_d value
        if(i<rows)
            if(j==1)
                targetImageCrChannelE__d(i,j)=abs(targetImageCrChannel(i+1,j)-targetImageCrChannel(i,j));
            else
                targetImageCbChannelE_d(i,j)=abs(targetImageCrChannel(i+1,j-1)-targetImageCrChannel(i,j));
            end
        else
            if(j==1)
                targetImageCrChannelE__d(i,j)=targetImageCrChannelE__d(i-1,j);
            else
                targetImageCrChannelE__d(i,j)=abs(targetImageCrChannel(i,j-1)-targetImageCrChannel(i,j));
            end
        end
    end
end

% Now treshold the values of each matrix based on the best treshold values.
% Base on the idea of the paer treshold T should be 7

for i=1:rows
    for j=1:cols
        if(targetImageCrChannelE_h(i,j)>=t)
            targetImageCrChannelE_h(i,j)=t;
        end
        
        if(targetImageCrChannelE_j(i,j)>=t)
            targetImageCrChannelE_j(i,j)=t;
        end
        
        if(targetImageCrChannelE_d(i,j)>=t)
            targetImageCrChannelE_d(i,j)=t;
        end
        
        if(targetImageCrChannelE__d(i,j)>=t)
            targetImageCrChannelE__d(i,j)=t;
        end
    end
end

% Now Calculate the GLCM for the each of the eadge matrixes
CrCM_h=graycomatrix(targetImageCrChannelE_h);
CrCM_j=graycomatrix(targetImageCrChannelE_j);
CrCM_d=graycomatrix(targetImageCrChannelE_d);
CrCM__d=graycomatrix(targetImageCrChannelE__d);

% Convert Matrixes to vector
CbCM_h=CbCM_h(:)';
CbCM_j=CbCM_j(:)';
CbCM_d=CbCM_d(:)';
CbCM__d=CbCM__d(:)';

CrCM_h=CrCM_h(:)';
CrCM_j=CrCM_j(:)';
CrCM_d=CrCM_d(:)';
CrCM__d=CrCM__d(:)';

% Create the primery feature Vector
featureOutput=[CbCM_h CbCM_j CbCM_d CbCM__d CrCM_h CrCM_j CrCM_d CrCM__d];

% Create the final feature vector using Boost feature selection(BFS)

end

