%load data
clear all;
inputData=load('IRIS.txt');
X=inputData(:,1:4);
Y=inputData(:,5);
m=size(X,1);
n=size(X,2);

%Step1.given control parameters
K=3;%expect class
k=K;
thetan=10;
thetas=0.765;
thetac=0.1;
L=2;
I=20;

%set prarmeters in step7
iterateTimes=0;
step7ToStep11Flag=0;
%step7ToStep8Flag=0;
step10ToStep2Flag=0;

%set prarmeters in step10
mu=0.1;
%{
%choose three cores
Z=[];
coreNumber=int32(m*rand(K,1));
for i=1:K
    Z(i,:)=X(coreNumber(i),:);
end
%}

%Z=[X(coreNumber(1),:);X(coreNumber(2),:);X(coreNumber(3),:)];
Z(1,:)=X(1,:);
Z(2,:)=X(51,:);
Z(3,:)=X(101,:);


totaltimes=1;
while totaltimes<=I
%loop between step2 & step10
while 1
%Step2.calculate distance & classify for the 1st time
[distance,predictY,cnt]=Step2(X,Z,m,k);
step10ToStep2Flag=0;

%Step3.judge the number of each class & delete the exceptions
while 1
    for i=1:k
        if i>k
            break;
        end
        if Step3(cnt,i,thetan)==0
            %delete the core
            Z(i,:)=[];
            %minus the class number
            k=size(Z,1);
            %goto Step2
            [distance,predictY,cnt]=Step2(X,Z,m,k);
        end
    end
    boolvalid=1;
    for i=1:k
        boolvalid=boolvalid*(cnt(i)>=thetan);%when all the cnt>=thetan, boolvalid==1
    end
    if boolvalid%when boolvalid==1,break
        break;
    end
end

%Step4.calculate the new core
ZSum=zeros(k,n);
for i=1:m
    ZSum(predictY(i),:)=ZSum(predictY(i),:)+X(i,:);
end
Z=ZSum./[cnt;cnt;cnt;cnt]';

%Step5.calculate Dj
sumInnerDistance=zeros(k,1);
for j=1:m
    sumInnerDistance(predictY(j))=sumInnerDistance(predictY(j))+sum((X(j,:)-Z(predictY(j),:)).^2);
end
innerDistance=sumInnerDistance./cnt';

%Step6.calculate D
sumBetweenDistance=0;
for i=1:k
    sumBetweenDistance=sumBetweenDistance+cnt(i)*innerDistance(i);
end
betweenDistance=sumBetweenDistance/m;
plot(totaltimes,sumBetweenDistance,'.k');
hold on;

%Step7.judge whether to stop Or split Or move to Step11
if totaltimes==I
    thetac=0;
    step7ToStep11Flag=1;
elseif k>=2*K || mod(totaltimes,2)==0
    step7ToStep11Flag=1;
%elseif k<=K/2
%    step7ToStep8Flag=1;
%else
%    step7ToStep8Flag=1;
end

%whether go into step8 directly

%whether go into step11 directly
if step7ToStep11Flag==1
    break;
end

%Step8.calculate sigma
sumSigma=zeros(k,n);
for i=1:m
    sumSigma(predictY(i),:)=sumSigma(predictY(i),:)+(X(i,:)-Z(predictY(i),:)).^2;
end
sigma=sqrt(sumSigma./[cnt;cnt;cnt;cnt]');

%Step9.calculate sigmamax
sigmaMax=max(sigma')';

%Step10.judge whether to split
for i=1:k
    if sigmaMax(i)>thetas
        if (innerDistance(i)>betweenDistance && cnt(i)>(2*thetan+1)) ||(k<=K/2)
            zPlus=Z(i,:)+mu*sigma(i);
            zMinus=Z(i,:)-mu*sigma(i);
            k=k+1;
            Z(i,:)=zPlus;
            Z(k,:)=zMinus;
            step10ToStep2Flag=1;
            totaltimes=totaltimes+1;
            break;
        end
    end
end

if step10ToStep2Flag==0
    break;
end
end

%Step11.Calculate Dij
ZDistance=zeros(k*(k-1)/2,3);
num=1;
numberZSmallTheta=0;
for i=1:k-1
    for j=i+1:k
        ZDistance(num,1)=sum((Z(i,:)-Z(j,:)).^2);
        if ZDistance(num,1)<thetac
            numberZSmallTheta=numberZSmallTheta+1;
        end
        ZDistance(num,2)=i;
        ZDistance(num,3)=j;
        num=num+1;
    end
end
step7ToStep11Flag=0;

%Step12.sort the distance with thetac
sortedZDistance=sortrows(ZDistance);

%Step13.whether to combine
if numberZSmallTheta>L
    calculateZNumber=L;
else
    calculateZNumber=numberZSmallTheta;
end
for i=1:calculateZNumber
    if (Z(sortedZDistance(i,2),1)~=65536) && (Z(sortedZDistance(i,2),1)~=65536)
        ni=cnt(sortedZDistance(i,2));
        nj=cnt(sortedZDistance(i,3));
        Z(sortedZDistance(i,2),:)=1/(ni+nj)*(ni*Z(sortedZDistance(i,2),:)+nj*Z(sortedZDistance(i,3),:));
        Z(sortedZDistance(i,3),1)=65536;
    end
end
for i=1:k
    if i>k
        break;
    end
    if Z(i,1)==65536
        Z(i,:)=[];
        k=size(Z,1);
    end
end

%Step14.decide whether to stop
totaltimes=totaltimes+1;
end
grid on;
%output
resultFile=fopen('IRISresult.txt','w');
file=fprintf(resultFile,'%d \n',predictY);
fclose(resultFile);