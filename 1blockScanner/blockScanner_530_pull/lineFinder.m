function [ output_args ] = lineFinder( img,lineDir,scannerLen,startPos )
%takes in img and outputs first col/row from startPos where it detects a
%white line of at least length scannerLen. 
%lineDir is either 'horiz' or 'vert'
scanVec = [];
imgCenterX = round(size(img,2)/2);
imgCenterY = round(size(img,1)/2);

if isequal(lineDir,'horiz')
   scanVec = zeros(1,scannerLen); 
   scanImg = img(:,imgCenterX-scannerLen/2:imgCenterX+scannerLen/2);
   imshow(scanImg);
   
elseif isequal(lineDir,'vert')
    scanVec = zeros(scannerLen,1);
end






end

