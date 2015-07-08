function [ccInds] = sepLetterFinder( im,cc )
%sepLetterFinder takes a connecte components struct of a bw image of gemara text as input and outputs the
%indexes, if any, of letters with overlapping connComps, indicating they are either a hay or kuf 
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
ys(ys == 0) = size(ol,1);

ccInds = [(xs'-1)*2+1 (ys'-1)*2+2];

% figure;imshow(im);
% hold on;
% plot(ceo(ys,1),ceo(ys,2),'*m');
% plot(cee(xs,1),cee(xs,2),'*g');
% hold off;

end

