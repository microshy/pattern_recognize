clear;
%��ȡ������
[X,Y]=readimg();
%���ò���
dim=size(X,2);
numbers=size(X,1);
sigma=200 ;
k=0;
threshold=0.8;
classnum=40;
n=10;
%������׼��
%X_norm=zscore(X);
X_norm=X;
%��˹�˾���
K=zeros(numbers,numbers);
%K=zeros(dim,dim);
for row=1:numbers
    for col=1:row
        temp=sum((X_norm(row,:)-X_norm(col,:)).^2);
        %temp=sum((X_norm(:,row)-X_norm(:,col)).^2);
        K(row,col)=exp(-temp/sigma^2);
    end
end
K=K+K';
for row = 1:numbers
%for row = 1:dim
    K(row,row) = K(row,row)/2;
end
%K���Ļ�
unit=ones(size(K))/numbers;
%unit=ones(size(K))/dim;
K_center = K - unit*K - K*unit + unit*K*unit;
%����ֵ��������
[U S]=svd(K_center);
diag_S=diag(S);
for i=1:size(diag_S)
    if sum(diag_S(1:i))/sum(diag_S)>=threshold
        k=i;
        break;
    end
end
Ureduce=U(:,1:k);
Sreduce=sqrt(diag_S);
for i=1:k
    Ureduce(:,i)=Ureduce(:,i)/Sreduce(i);
end

%��ͶӰ��ά
Z=Ureduce'*K;

%flda
%���dά������ֵ����
means=dmeans(Z',Y);

%��������ɢ�Ⱦ����Լ�����ɢ�Ⱦ���
sw=ds(Z',Y,means);

%�������ɢ�Ⱦ���
sb=dsb(Z',Y,means);

%����ɢ������
st=sw+sb;

%��������
temp=sw\sb;
temp=(temp+temp')/2;
[V, D] = eig(temp);
[Y_arr,I] = sort(diag(D),'descend'); % ����Ĭ�ϵ�������
V = V(:,I);

%��ά
Z2=Z'*V(:,1:2);

%��ȷ��
correctnumber=0;
%predictZ=Z'*V(:,1:2);
for a=1:size(Z2,1)
    predictZ(a,:)=(Z(:,a))'*V(:,1:2);
    for i=1:size(Z2,1)
        distance(i,1)=(predictZ(a,:)-Z2(i,:))*(predictZ(a,:)-Z2(i,:))';
    end
    for i=1:size(Z2,1)
        index(i,1)=Y(i);
    end
    format long g;
    temp=[distance index];
    sortclass=sortrows(temp);
    lut=zeros(classnum,1);
    for i=1:n
        lut(sortclass(i,2),1)=lut(sortclass(i,2),1)+1;
    end
    max=0;
    for i=1:classnum
        if max<lut(i)
            max=lut(i);
            classn=i;
        end
    end
    if classn==Y(a)
        correctnumber=correctnumber+1;
    end
end
correct=correctnumber/400;

