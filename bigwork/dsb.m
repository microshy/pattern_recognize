function [dsb]=dsb(X,Y,means)
sum=zeros;
for i=1:size(X,1)
    sum=sum+X(i,:);
end
mean0=sum/size(X,1);
dsb=zeros;
for i=1:40
    dsb=dsb+10*(means(i,:)-mean0)'*(means(i,:)-mean0);
end
end