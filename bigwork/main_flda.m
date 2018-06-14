clear all;

%��ȡ������
[X,Y]=readimg();

%���dά������ֵ����
means=dmeans(X,Y);

%��������ɢ�Ⱦ����Լ�����ɢ�Ⱦ���
sw=ds(X,Y,means);

%�������ɢ�Ⱦ���
sb=dsb(X,Y,means);

%����ɢ������
st=sw+sb;

%��������
temp=sw\sb;
temp=(temp+temp')/2;
[V, D] = eig(temp);
[Y_arr,I] = sort(diag(D),'descend'); % ����Ĭ�ϵ�������
V = V(:,I);

%��ά
Z=X*V(:,1:9);

%����
%im = imread('F:/ѧϰ/ģʽʶ��/bigwork/att_faces/s1/2.pgm');
%images = im;
%images=double(images(:));
%predictZ=images'*V(:,1);
%classn=judge(Z,predictZ,40);

%��ȷ��
correctnumber=0;
for i=1:40
    fpath =strcat('F:/ѧϰ/ģʽʶ��/bigwork/att_faces/s',num2str(i));  %�������ļ��е�����
    flist = dir(sprintf('%s/*.pgm', fpath));
    for imidx = 1:min(length(flist), 200)
        %fprintf('[%d]', imidx); %��ʾ����
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

