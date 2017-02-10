function [ output_args ] = func_Test()
%FUNC_TEST Summary of this function goes here
%   Detailed explanation goes here

conn=func_Dbconnector();

syntax='SELECT * FROM view_dwtfeatures WHERE (isForgery = 0)';

authanticatedList=exec(conn,syntax);

authanticatedList=fetch(authanticatedList);
authanticatedList=authanticatedList.Data;

syntax='SELECT * FROM view_dwtfeatures WHERE (isForgery = 1)';

spliced=exec(conn,syntax);

spliced=fetch(spliced);
spliced=spliced.Data;

% Get the size of matrixes
[row col dim]=size(authanticatedList);

trainsize=round(row*(5/6));


trainmatrix=authanticatedList(1:trainsize,1:78);
taringlabels=authanticatedList(1:trainsize,79);
testmatrix=authanticatedList(trainsize+1:end,1:78);

[row col dim]=size(spliced);

trainsize=round(row*(5/6));

trainmatrix=[trainmatrix;spliced(1:trainsize,1:78)];
taringlabels=[taringlabels;spliced(1:trainsize,79)];
testmatrix=[testmatrix;spliced(trainsize+1:end,1:78)];

templabels=[];
tempTrain=[];
temptest=[];

[row col dim]=size(testmatrix);

for i=1:row
    for j=1:col
        temptest(i,j)=testmatrix{i,j};
    end
end

[row col dim]=size(trainmatrix);


for i=1:row
    templabels(i,1)=taringlabels{i,1};
end

for i=1:row
    for j=1:col
        tempTrain(i,j)=trainmatrix{i,j};
    end
end

taringlabels=templabels;
testmatrix=temptest;
trainmatrix=tempTrain;

ens=fitensemble(trainmatrix,taringlabels,'AdaBoostM1',row,'Tree');

%[Y,scores]=predict(ens,testmatrix(1,:));

end

