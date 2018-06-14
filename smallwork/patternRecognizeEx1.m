clear all;
%load data
w1=[0 0;2 1;1 0];
X1=w1(:,1);Y1=w1(:,2);
w2=[-1 1;-2 0;-2 -1];
X2=w2(:,1);Y2=w2(:,2);
w3=[0 -2;0 -1;1 -2];
X3=w3(:,1);Y3=w3(:,2);
%calculate average mu
mu1=[sum(w1)/3;sum(w1)/3;sum(w1)/3];
mu11=sum(w1)/3;
mu2=[sum(w2)/3;sum(w2)/3;sum(w2)/3];
mu22=sum(w2)/3;
mu3=[sum(w3)/3;sum(w3)/3;sum(w3)/3];
mu33=sum(w3)/3;
%calculate covariance matrix
sig1=transpose(w1-mu1)*(w1-mu1)/2;
sig2=transpose(w2-mu2)*(w2-mu2)/2;
sig3=transpose(w3-mu3)*(w3-mu3)/2;
%calculate inverse matrix
sig1Inv=pinv(sig1);
sig2Inv=pinv(sig2);
sig3Inv=pinv(sig3);
%calculate the det
det1=det(sig1);
det2=det(sig2);
det3=det(sig3);
%the priori probability
p1=1/3;
p2=1/3;
p3=1/3;
%calculate g
x=[-2 -2];
g1=-0.5*(x-mu11)*sig1Inv*transpose(x-mu11)-0.5*log(det1)+log(p1);
g2=-0.5*(x-mu22)*sig2Inv*transpose(x-mu22)-0.5*log(det2)+log(p2);
g3=-0.5*(x-mu33)*sig3Inv*transpose(x-mu33)-0.5*log(det3)+log(p3);
fprintf('%f,%f,%f\n',g1,g2,g3);
plot(X1,Y1,'x');
hold on;
plot(X2,Y2,'o');
hold on;
plot(X3,Y3,'+');
hold on;

syms x1;
syms x2;
g12=-0.5*([x1 x2]-mu11)*sig1Inv*([x1 x2]-mu11)'-0.5*log(det1)+log(p1)-...
    (-0.5*([x1 x2]-mu22)*sig2Inv*([x1 x2]-mu22)'-0.5*log(det2)+log(p2))
g13=-0.5*([x1 x2]-mu11)*sig1Inv*([x1 x2]-mu11)'-0.5*log(det1)+log(p1)-...
    (-0.5*([x1 x2]-mu33)*sig3Inv*([x1 x2]-mu33)'-0.5*log(det3)+log(p3))
g23=-0.5*([x1 x2]-mu22)*sig2Inv*([x1 x2]-mu22)'-0.5*log(det2)+log(p2)-...
    (-0.5*([x1 x2]-mu33)*sig3Inv*([x1 x2]-mu33)'-0.5*log(det3)+log(p3))
%'-0.5*([x y]-mu11)*sig1Inv*transpose([x y]-mu11)-0.5*log(det1)+log(p1)-(-0.5*([x y]-mu22)*sig2Inv*transpose([x y]-mu22)-0.5*log(det2)+log(p2))'
h1=ezplot(g12,[-2,2,-2,2]);
set(h1,'Color','red');
hold on;
h2=ezplot(g13,[-2,2,-2,2]);
set(h2,'Color','yellow');
hold on;
h3=ezplot(g23,[-2,2,-2,2]);
set(h3,'Color','blue');
