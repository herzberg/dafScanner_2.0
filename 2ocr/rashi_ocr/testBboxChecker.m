clc,clear,close all;
im = imread('testLine.png');


cc = bwconncomp(~im);
bbStruct = regionprops(cc,'BoundingBox');
bb = cat(1,bbStruct.BoundingBox);
bbo = bb(1:2:end,:);
bbe = bb(2:2:end-1,:);

ceStruct = regionprops(cc,'Centroid');
ce = cat(1,ceStruct.Centroid);
ceo = ce(1:2:end,:);
cee = ce(2:2:end-1,:);


ol = bboxOverlapRatio(bbo,bbe);
nums = 1:size(ol,1)*size(ol,2);
olNums = nums(ol > 0);
xs = ceil(olNums/size(ol,1));
ys = mod(olNums,size(ol,1));

figure;imshow(im);
hold on;
plot(ceo(ys,1),ceo(ys,2),'*m');
plot(cee(xs,1),cee(xs,2),'*g');
hold off;