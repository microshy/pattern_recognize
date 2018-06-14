clear all;
inputData=load('IRIS.txt');
X=inputData(:,1:4);
Y=inputData(:,5);
m=size(X,1);
n=size(X,2);
cnt=0;

%use min-func to choose the colsest cores and set class
predictY=Y;

%calculate coreNew
cntin=zeros(1,3);
coreNew=zeros(3,4);
for i=1:m
    switch predictY(i)
        case 1,
            coreNew(1,:)=coreNew(1,:)+X(i,:);
            cntin(1)=cntin(1)+1;
        case 2,
            coreNew(2,:)=coreNew(2,:)+X(i,:);
            cntin(2)=cntin(2)+1;
        case 3,
            coreNew(3,:)=coreNew(3,:)+X(i,:);
            cntin(3)=cntin(3)+1;
    end
end
coreNew=coreNew./[cntin;cntin;cntin;cntin]';

%calculate the distance in the form of matrix
for i=1:m
        distance(i)=(X(i,:)-coreNew(predictY(i),:)).^2*ones(4,1);
end

costJ=sum(distance);

