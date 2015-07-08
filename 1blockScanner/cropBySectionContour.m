function [ croppedSec ] = cropBySectionContour( secContour, im )
%Given a list of points that surround a section in the daf, output that
%section cropped. It should be square, but portions outside contour should
%be white. Currently contour is ordered so that you can follow the path
%around point to point, but I don't think that's necessary

%round so that you can crop int rows and cols
secContour = round(sortrows(secContour,2));
usedSecContour = zeros(size(secContour));
boxCornerList = []; % list of top left and bottom right corners of boxes that define varying width sections of daf
croppedSec = im;

%make points that are almost equal, actually equal b/c this algorithm
%relies heavily on finding equal points
equalThresh = 15;
for jj = 1:size(secContour,1)-1
   tempPoint = secContour(jj,:);
   almostEqualPointsX = abs(secContour(:,1) - tempPoint(1)) < equalThresh;
   almostEqualPointsY = abs(secContour(:,2) - tempPoint(2)) < equalThresh;

   secContour(almostEqualPointsX,1) = tempPoint(1);
   secContour(almostEqualPointsY,2) = tempPoint(2);
   %if you find a point with both equal y and x
   almostEqualYandX = almostEqualPointsX & almostEqualPointsY;
   if sum(almostEqualYandX) > 1 % greater than 1 b/c obviously it will be equal to itself
       secContour(almostEqualYandX,:) = repmat([-1,-1],sum(almostEqualYandX),1);
       
       secContour(find(almostEqualYandX,1),:) = tempPoint; 
   end

end


for ii = 1:size(secContour,1)-1
   tempPoint = secContour(ii,:);
    if isequal(tempPoint,[-1,-1])
        continue;
    end   
   
   equiYInd = secContour(:,2) == tempPoint(2) & ...
       secContour(:,1) ~= tempPoint(1);
   tempEquiYPoint = secContour(equiYInd,:);
   if sum(equiYInd) > 1 % you found more than one point, reevaluate tempPoint so that you have widest area
       tempPoint(1) = min([tempPoint(1),tempEquiYPoint(:,1)']);
       tempEquiYPoint = max([tempPoint(1),tempEquiYPoint(:,1)']);
   end
   
   if ~isempty(boxCornerList) % then check prev corners to see if they will be new corners
       
       has1 = sum(boxCornerList(end-1,1)==usedSecContour(:,1) & tempPoint(2)==usedSecContour(:,2)) > 0;
       has2 = sum(boxCornerList(end,1)==usedSecContour(:,1) & tempPoint(2)==usedSecContour(:,2)) > 0;
       if isempty(tempEquiYPoint)
           xvec = [boxCornerList(end-1,1)*~has1, boxCornerList(end,1)*~has2];
       else
           xvec = [boxCornerList(end-1,1)*~has1, boxCornerList(end,1)*~has2,tempEquiYPoint(1)];
       end
       
       xvec(xvec == 0) = tempPoint(1); % guarentees that all points that are ~has1 or ~has2 will not be chosen as maxX. solution to problem below
       
       xdistvec = abs(tempPoint(1)-xvec);
       
       %choose max dist so that box contains all of content
       %WARNING: this makes an assumption and probably best to not include
       %corners already in secContour
       [~,maxInd] = max(xdistvec);
       equiYPoint = [xvec(maxInd),tempPoint(2)];
   else
       equiYPoint = tempEquiYPoint;
   end
   
   %by this point you have top two corners. now look for at least one
   %bottom one, possibly two depending on what's in secContour
   equiXInd1 = secContour(:,1) == tempPoint(1) & ...
       secContour(:,2) ~= tempPoint(2);
   equiXInd2 = secContour(:,1) == equiYPoint(1) & ...
       secContour(:,2) ~= equiYPoint(2);
     
   equiXPoint1 = secContour(equiXInd1,:);
   equiXPoint2 = secContour(equiXInd2,:);
   
   try 
       minYPointMat = sortrows([equiXPoint1;equiXPoint2],2); 
       minYPoint = minYPointMat(1,:); %first element is smallest Y
   catch e
       break;
   end
   boxCorners = [tempPoint; equiYPoint; minYPoint];
   
   %corners of box are min and max XY coords
   maxXY = max(boxCorners);
   minXY = min(boxCorners);
   boxCornerList = [boxCornerList; minXY; maxXY];
   
   minInd = secContour(:,1) == minYPoint(1) & ...
       secContour(:,2) == minYPoint(2);
   
   equiYInd = secContour(:,1) == equiYPoint(1) & ...
       secContour(:,2) == equiYPoint(2);
   
   
   usedSecContour(ii,:) = secContour(ii,:);
   usedSecContour(minInd,:) = secContour(minInd,:);
   secContour(ii,:) = [-1,-1];
   secContour(minInd,:) = [-1,-1];
   if sum(equiYInd) > 0
       usedSecContour(equiYInd,:) = secContour(equiYInd,:);
       secContour(equiYInd,:) = [-1,-1];
   end
   
    %white out left and right of each box
    croppedSec(minXY(2):maxXY(2),1:minXY(1)) = 1;
    croppedSec(minXY(2):maxXY(2),maxXY(1):end) = 1;
end

%white out top and bottom
globalMaxXY = max(boxCornerList);
globalMinXY = min(boxCornerList);

croppedSec(1:globalMinXY(2),:) = 1;
croppedSec(globalMaxXY(2):end,:) = 1;



end

