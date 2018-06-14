clear all;

%读取人脸库
[X,Y]=readimg();

%求解d维样本均值向量
means=dmeans(X,Y);

%求类内离散度矩阵以及总离散度矩阵
sw=ds(X,Y,means);

%求类间离散度矩阵
sb=dsb(X,Y,means);

%总体散布矩阵
st=sw+sb;

%求特征根
temp=sw\sb;
temp=(temp+temp')/2;
[V, D] = eig(temp);
[Y_arr,I] = sort(diag(D),'descend'); % 降序，默认的是升序
V = V(:,I);

%降维
Z=X*V(:,1:9);

%测试
%im = imread('F:/学习/模式识别/bigwork/att_faces/s1/2.pgm');
%images = im;
%images=double(images(:));
%predictZ=images'*V(:,1);
%classn=judge(Z,predictZ,40);

%正确率
correctnumber=0;
for i=1:40
    fpath =strcat('F:/学习/模式识别/bigwork/att_faces/s',num2str(i));  %这里是文件夹的名字
    flist = dir(sprintf('%s/*.pgm', fpath));
    for imidx = 1:min(length(flist), 200)
        %fprintf('[%d]', imidx); %显示进程
        fname = sprintf('%s/%s', fpath, flist(imidx).name);
        im = imread(fname);
        images = im;
        images=double(images(:));
        predictZ=images'*V(:,1:9);
        classnumber=judge(Y,Z,predictZ,40,10);
        if classnumber==i
            correctnumber=correctnumber+1;
        end
    %fprintf('\n');
    end
end
correct=correctnumber/400;

