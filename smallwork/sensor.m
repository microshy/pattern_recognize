clear all;

X=[0,0;0,1;1,0;1,1];
Y=[1;1;2;2];
w=[1,1,1];
ro=1;

cnt=0;
X=[ones(size(X,1),1),X];
%J=sum(-w*X');

while 1
    w_old=w;
    cnt=cnt+1;
    fprintf('%d',cnt);
    fprintf('\n');
    for i=1:size(X,1)
        if (w*X(i,:)'<=0) & (Y(i)==1)
            w=w+ro*X(i,:);
        elseif w*X(i,:)'>=0 & Y(i)==2
            w=w-ro*X(i,:);
        end
        fprintf('%d\t',w);
        fprintf('\n');
    end
    if (w_old==w) | (cnt>=100)
        break;
    end
end