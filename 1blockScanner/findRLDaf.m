function [ start,finish ] = findRLDaf( daf,side )
    %UNTITLED2 Summary of this function goes here
    %   Detailed explanation goes here
    cropEdgeSize = 20;
    cropTopSize = 10;
    uthresh = 30;
    lthresh = 4;
    daf = daf(cropTopSize+1:end,cropEdgeSize + 1:end-cropEdgeSize);
    strelSize = 10;
    SE = strel('rectangle',[strelSize strelSize]);
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
        sNew = s(~startBadInds);
        eNew = e(~startBadInds);
        tNew = t(~startBadInds);
    else
        sNew = s;
        eNew = e;
        tNew = t;
    end
    
    
    endBadInds = tNew > uthresh | tNew < lthresh | eNew == size(cutDaf,2);
    if sum(endBadInds) >= 1
        sNew = sNew(~endBadInds);
        eNew = eNew(~endBadInds);
        tNew = tNew(~endBadInds);
    end

    if (length(tNew) >= 1)
        start = sNew(1) + cropEdgeSize;
        finish = eNew(1) + cropEdgeSize;

    else 
        if isequal(side,'l')
           start = -1; 
           [~,maxI] = max(t);
           finish = e(maxI) + cropEdgeSize; 
        elseif isequal(side,'r') %this code has not been tested yet...probably a one-off error
            [~,maxI] = max(t);
            start = s(maxI) + cropEdgeSize;
            finish = -1;
        end
        
    end
end


