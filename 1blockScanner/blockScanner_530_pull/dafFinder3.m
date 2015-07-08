clc, clear, close all;
N=40;
k=25;

for i=k:k+N
    pause(.350)
    s=strcat('../brachos/brach1__Page_0',num2str(i),'.png');
    im=imread(s);
    [ls,lf] = findRLDaf(im,'l');
    [rl,rf] = findRLDaf(im,'r');
    im = im(:,lf:rl);
    topline = gettopline(im);
    [topleft, topright] = getRLCorners(im,topline);

    start = topline(3);
    nextJunc = nextJunctionFinder(im,topright,start,2)
    nextJunc = nextJunc
    
    im(nextJunc:nextJunc+10,:) = 0;
    figure;
    imshow(im)



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

