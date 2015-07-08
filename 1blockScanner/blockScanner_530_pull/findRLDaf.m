function [ start,finish ] = findRLDaf( daf,side )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
cropEdgeSize = 20;
uthresh = 30;
lthresh = 4;
daf = daf(:,cropEdgeSize + 1:end-cropEdgeSize);
SE = strel('rectangle',[10 10]);
%SE = strel('rectangle',[30 30]);
daf = ~imclose(1-daf,SE);
%imshow(daf);
currLength = round(size(daf,1)/2);
    cutDaf = daf(1:currLength,:);
    arbitraryScaling = 0.99;
    sumVec = sum(cutDaf,1) >= length(1:currLength)*arbitraryScaling;
    [t,s,e] = onestreams(sumVec);
    

    
    if isequal(side,'l')
        startBadInds = t > uthresh | t < lthresh | s == 1 | s > size(cutDaf,2)/2;
    elseif isequal(side,'r')
        startBadInds = t > uthresh | t < lthresh | s == 1 | e < size(cutDaf,2)/2;
    end
    
    if sum(startBadInds) >= 1 
        s = s(~startBadInds);
        e = e(~startBadInds);
        t = t(~startBadInds);
    end
    
    
    endBadInds = t > uthresh | t < lthresh | e == size(cutDaf,2);
    if sum(endBadInds) >= 1
        s = s(~endBadInds);
        e = e(~endBadInds);
        t = t(~endBadInds);
    end

    if (length(t) >= 1)
        start = s(1) + cropEdgeSize;
        finish = e(1) + cropEdgeSize;

    else 
        start = -1;
        finish = -1;
    end
end


