function BPMM = func_BPMMFinder(image)
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


%Now get the size of BPPM using the number of blocks
[rows columns dimentsion]=size(DCTCofficentsBlocks);
%rows=uint8(rows);
%columns=uint8(columns);
BPMM=zeros(rows,columns);
BPMM=double(BPMM);

% Hold the information of probablites for later calculation
BPMMProbablites=cell(rows,columns);

%Create a temp Cell Matrix that hold the information of probabilites that
%going to considered in callcualtion.
tempProbablityHolder=cell(rows,columns);

%Callculate all of the Basian probablites and save the informaton of them

% Start surffing on the list of histograms
[histrows histcol histdem]=size(periodsANDDCTcofficentsHistogram);

for i=1:histrows
    for j=1:histcol
        
        % Start surrfing based on the three different color channels
        for channel=1:3
            % get the information of the period and information of the DCT
            % Get the period value
            p=periodsANDDCTcofficentsHistogram{i,j}{1,channel}{1,2};
            %Check whether the period is gratger than 1, If not then ignore the
            %the histogram
            if(p>1)
                %Get the all DCT cofficence of frequence and callculate the
                %histogram with 60 bins.
                histogram=hist(periodsANDDCTcofficentsHistogram{i,j}{1,channel}{1,1},60);
                %Find the value of s_0 which is the index of maximum value
                %in histogram
                [val,s_0]=max(histogram);
                %Start Callculating the probablities
                period_end=s_0+p-1;
                lenghVector=length(histogram);
                for bin=s_0:period_end
                    %   Find the tempered
                    %Calculate the sum of histograms needed for prababiliy
                    %calculation
                    summation=0;
                    for k=0:p-1
                        if(s_0+k<=lenghVector)
                            summation=summation+histogram(floor(s_0/p)*p+k);
                        end
                    end
                    
                    if (bin<=lenghVector)
                        
                    p_unchanged_bin=histogram(bin)/summation;
                    p_tempered_bin=1/p;
                    
                    %Know callculate the posterior probabilites for the bin
                    %p_besian_tempered=p_tempered_bin/(p_tempered_bin+p_unchanged_bin);
                    p_besian_unchanged=p_unchanged_bin/(p_tempered_bin+p_unchanged_bin);
                    
                    % Now based on DCT frequency that histogram belongs to
                    % it, search in the blocks and find which blocks
                    % contribute on building of this bin. Howerver first of
                    % all we should find the interval that contribute in
                    % bulilding of that bin.
                    % For this purpose we first the maximum an mimum values
                    % of dct cofficents contributes in buliding of
                    % histogram.
                    [min_coff,index]=min(periodsANDDCTcofficentsHistogram{i,j}{1,channel}{1,1});
                    [max_coff,index]=max(periodsANDDCTcofficentsHistogram{i,j}{1,channel}{1,1});
                    intervalsize=abs(max_coff-min_coff);
                    % Now we should find the size of each range.
                    rangeSize=intervalsize/60;
                    %Now by having range size it is possible to get the
                    %range begining.
                    range_begining=((bin-1)*rangeSize)+min_coff;
                    range_end=(bin*rangeSize)+min_coff;
                    
                    % search in te correspond frequency to find which block
                    % should be consider for collculation
                    % for this purpose we shoud fine the frequency first.
                    %find requency row
                    frow=ceil(double(j/8));
                    %find freguqncy column
                    if (rem(j,8)==0)
                        fcolumn=8;
                    else
                        fcolumn=j-floor(j/8)*8;
                    end
                    %This gives which place in the block should be searched
                    %for the values of interval
                    
                    %Now start from the block ans control wether the value
                    %of cofficent is between interval or not. If the value
                    %is between interval then add up the tempered probablity
                    %value to the BPMM map corresponding block value.
                    for blockrow=1:rows
                        for blockcol=1:columns
                            % Get the block
                            dctBlock=DCTCofficentsBlocks{blockrow,blockcol}(:,:,channel);
                            if(isempty(dctBlock)==0)
                                if(dctBlock(frow,fcolumn)>=range_begining) & (dctBlock(frow,fcolumn)<range_end)
                                   if(p_besian_unchanged>0)
                                        tempPMMProbablites=BPMMProbablites(blockrow,blockcol);
                                        tempPMMProbablites{1,1}=[tempPMMProbablites{1,1};p_besian_unchanged];
                                        BPMMProbablites(blockrow,blockcol)=tempPMMProbablites;
                                   end
                                   
                                end
                            end
                        end
                    end
                    
                    end
                    
                    %This is the end of the process of generation BPMM map
                    
                end
            end
        end
        
        
    end
end

%Now calculate the accumulated probablity and generate BPMM map
[BPMMrow BPMMcol dem]=size(BPMMProbablites);

for i=1:BPMMrow
    for j=1:BPMMcol
        %get the list of probablites
        probablitesList=BPMMProbablites(i,j);
        
        [plistrow plistcol plistdem]=size(probablitesList{1,1});
        
        %Primitive calculations of probablites
        p1=1;
        p2=1;
        
        for k=1:plistrow
            p1=p1*probablitesList{1,1}(k);
            p2=p2*(1-probablitesList{1,1}(k));
        end
        
        %Now accumilated probability for is
        accp=p1/(p1+p2);
        BPMM(i,j)=accp;
        % This is the value inserted as the value of BPMM pixel value
        
    end
end


% %===============================================
% %Find the min and max of probalblites
minP=round(min(min(BPMM)));
maxP=round(max(max(BPMM)));
minP=minP+ 0.010;
maxP=maxP- 0.010;
OptimumT=0
temperoryTValue=0;

for t=minP:0.010:maxP
    % Find the maximum of
    % Classify pixels based on the value of t
    %Class of tempered blocks
    class0=find(BPMM<=t);
    %[r0,c0,v0]=find(BPMM<=t);
    %Class of untempered blocks
    %[r1,c1,v1]=find(BPMM>t);
    class1=find(BPMM>t);
    
    
    mean0=mean(class0);
    variance0=var(class0);    
    
    mean1=mean(class1);
    variance1=var(class1);
            
    meanall=(mean0-mean1)^2;
    
    finalResult=meanall/(variance0+variance1);
    
    if(finalResult>=temperoryTValue)
        temperoryTValue=finalResult;
        OptimumT=t;
    end
    
end

finalBPMM=zeros(rows,columns);

for i=1:rows
    for j=1:columns
        if(BPMM(i,j)<=OptimumT)
            finalBPMM(i,j)=0;
        else
            finalBPMM(i,j)=255;
        end
    end
end
% %=============================================

figure;
imagesc(BPMM);
colormap(gray);
%imshow(BPMM);

return

