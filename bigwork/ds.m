function [sw]=ds(X,Y,means)
%��ʼ��
%si=[];

sw=zeros(size(X,2),size(X,2));
%���
for i=1:size(X,1)
    %if Y(i)==0
    %    si{10}=si{10}+(double(X{i})-means{10})*(double(X{i})-means{10})';
    %else
        sw=sw+(X(i,:)-means(Y(i),:))'*(X(i,:)-means(Y(i),:));
    %end
end
%{
%���ֵ�Լ�����ɢ��
si=si/10;
for i=1:40
    sw=sw+0.025*double(si{i});
end
%}
end