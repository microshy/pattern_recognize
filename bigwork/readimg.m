function [X,Y]=readimg()
images = [];

for i=1:40
fpath =strcat('F:/学习/模式识别/bigwork/att_faces/s',num2str(i));  %这里是文件夹的名字
flist = dir(sprintf('%s/*.pgm', fpath));
for imidx = 1:min(length(flist), 200)
    fprintf('[%d]', imidx); %显示进程
    fname = sprintf('%s/%s', fpath, flist(imidx).name);
    im = imread(fname);
    images{length(images)+1} = im;
end
fprintf('\n');
end

for i=1:length(images)
    if mod(i,10)==0
        Y(i)=fix(i/10);
    else
        Y(i)=fix(i/10)+1;
    end
end

temp=[];
for i=1:length(images)
    temp=images{i};
    temp=temp(:);
    X(i,:)=double(temp');
end
end