function [classn]=judge(Y,Z,predictZ,classnum,n)
for i=1:size(Z,1)
    distance(i,1)=(predictZ-Z(i,:))*(predictZ-Z(i,:))';
end
for i=1:size(Z,1)
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
end