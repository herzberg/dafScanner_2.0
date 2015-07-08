clc, clear, close all;
N=0;
k=20;
for i=k:k+N
    s=strcat('brachos/brach1__Page_0',num2str(i),'.png');
    im=imread(s);
    imshow(im);
    title('original image');
    figure;

    [ls,lf] = findRLDaf(im,'l');
    [rl,rf] = findRLDaf(im,'r');
    imtmp=uint8(im)*255;
    imtmp(:,ls:lf)=100;
    imtmp(:,rl:rf)=100;
    imshow(imtmp);
    title('rabeinu chananel cropped')
    figure;
    im = im(:,lf:rl);

    
    topline = gettopline(im);
    imtmp = uint8(im)*255;
    color=100;
    imtmp(topline(2):topline(3),:)=color;
    imshow(imtmp);
    title('found the top of gemara')
    figure;
    
    [topleft, topright] = getRLCorners(im,topline);
    imtmp(:,topleft(2):topleft(3))=color;
    imtmp(:,topright(2):topright(3))=color;
    imshow(imtmp);
    title('found right and left columns')
    figure;
    
    start = topline(3);
    [corn,dim,start] = nextJunctionFinder(im,topright,start,2);
    imtmp(corn(2):corn(3),start:end)=color;
    imshow(imtmp)
    title('ignored extra word')
    figure;
    
    [corn2,dim2,start2] = nextJunctionFinder(im,corn,start,dim);
    imtmp(start2:end,corn2(2):corn2(3))=color;
    imshow(imtmp)
    title('found final vertical line')
%     
%     midrow = round(size(im,1)/2);
%     midcol = round(size(im,2)/2);
% 
%     % find gemara start
%     width=40;
%     w=midcol-width:midcol+width;
%     arbitrary_scaling = 1;
%     croppedim=im(:,w);
%     one_zero=sum(croppedim,2) >= length(w)*arbitrary_scaling;
% 
%     [numones,start,finish] = onestreams(one_zero');
%     clearHoriz=[numones' start' finish'];
%     for i=1:length(numones)
%         im(start(i):finish(i),:)=0;
%     end
%     figure
end
% for i=k:k+N
%     s=strcat('brachos/brach1__Page_0',num2str(i),'.png');
%     im=imread(s);
%     [ls,lf] = findRLDaf(im,'l');
%     [rl,rf] = findRLDaf(im,'r');
%     im(:,ls:lf)=0;
%     im(:,rl:rf)=0;
%     imshow(im)
% end

