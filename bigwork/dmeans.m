function [means]=dmeans(X,Y)
%��ʼ��
means=zeros(40,size(X,2));
%���
for i=1:size(X,1)
    %if Y(i)==0
    %    means{10}=means{10}+double(X{i});
    %else
        means(Y(i),:)=means(Y(i),:)+X(i,:);
    %end
end
%���ֵ
%for i=1:40
means=means/10;
%end
end