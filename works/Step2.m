function [distance,predictY,cnt]=Step2(X,Z,m,k)
%Step2.calculate distance
for i=1:m
    for j=1:k
        distance(i,j)=sum((X(i,:)-Z(j,:)).^2);
    end
end

%classify for the 1st time
predictY=zeros(m,1);
for i=1:m
    for j=1:k
        if min(distance(i,:))==distance(i,j)
            predictY(i)=j;
        end
    end
end

%count
cnt=zeros(1,k);
for i=1:m
    cnt(predictY(i))=cnt(predictY(i))+1;
end

end