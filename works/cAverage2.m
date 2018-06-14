clear all;
inputData=load('IRIS.txt');
X=inputData(:,1:4);
Y=inputData(:,5);
m=size(X,1);
n=size(X,2);
cnt=0;
%three for-loop to find out the least cost J and its parameters

%select 3 cores
core=[X(1,:);X(2,:);X(101,:)];%a 3x4 core matrix
costJNew=0;
%calculate the distance in the form of matrix
for i=1:m
    for j=1:3
        distance(i,j)=(X(i,:)-core(j,:)).^2*ones(4,1);
    end
end
costJ=sum(min(distance'));

%use min-func to choose the colsest cores and set class
predictY=zeros(m,1);
for i=1:m
    for j=1:3
        if min(distance(i,:))==distance(i,j)
            predictY(i)=j;
        end
    end
end

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
    for j=1:3
        distanceNew(i,j)=(X(i,:)-coreNew(j,:)).^2*ones(4,1);
    end
end
costJNew=sum(min(distanceNew'));

%classfy
number=0;
while number<10
    number=number+1;
    for i=1:m
        for j=1:3
            if predictY(i)==j
                distanceMinus=cntin(j)/(cntin(j)-1)*(X(i,:)-coreNew(j,:)).^2*ones(4,1);
                distancePlus(j)=65535;
            else
                distancePlus(j)=cntin(j)/(cntin(j)+1)*(X(i,:)-coreNew(j,:)).^2*ones(4,1);
            end
        end
        for j=1:3
            if distanceMinus>min(distancePlus) && distancePlus(j)==min(distancePlus)
                coreNew(predictY(i),:)=coreNew(predictY(i),:)+(coreNew(predictY(i),:)-X(i,:))/(cntin(predictY(i))-1);
                cntin(predictY(i))=cntin(predictY(i))-1;
                predictY(i)=j;
                coreNew(predictY(i),:)=coreNew(predictY(i),:)-(coreNew(predictY(i),:)-X(i,:))/(cntin(predictY(i))+1);
                cntin(predictY(i))=cntin(predictY(i))+1;
                costJ=costJNew;
                costJNew=costJ-distanceMinus+min(distancePlus);
            end
        end
        if costJNew>=costJ
            print(1);
            break;
        end
    end
end
