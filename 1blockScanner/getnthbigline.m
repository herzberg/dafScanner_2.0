function  topline  = getnthbigline( im,n,startRow,divFactor,dim,windowW,windowCenter,thresh )
%gets the Nth big line from top in im, after im has been cropped to startRow:end
%rows. divFactor says what portion from the top of im you want to look at.
%after it's cropped this is a second pass at weeding out the bad rows
%thresh - grrr, didn't want to add this...it cuts off all lines below
%thresh thickness
%dim = 1,2
if startRow == -1 || size(im,2) == 0 %this is used when trying to specifically get a lot of big lines near bottom to test if it's the end of the perek. This will run when a nonexistant big line is input
    topline = zeros(1,3)-1;
    return;
end

if dim == 1
    imPrime = im(startRow:end,:);

    w=windowCenter-windowW:windowCenter+windowW;
    arbitrary_scaling = 0.9;
    croppedim=im(:,w);
    otherDim = 2;
elseif dim == 2
    startCol = startRow;
    imPrime = im(:,startCol:end);

    w=windowCenter-windowW:windowCenter+windowW;
    arbitrary_scaling = 0.9;
    croppedim=im(w,:);
    %se = strel('rectangle',[4 4]);
    %croppedim = imopen(croppedim,se);
    %figure;imshow(croppedim);
    otherDim = 1;
end

%figure; imshow(croppedim);
try 
    one_zero=sum(croppedim,otherDim) >= length(w)*arbitrary_scaling;

    [numones,start,finish] = onestreams(one_zero');
    clearHoriz=[numones' start' finish'];
    gemaraFinder = clearHoriz(round(1:length(clearHoriz)/divFactor),:);
    

    meanTestCol = gemaraFinder(:,1);
    [lineIds,lineCents] = kmeans(meanTestCol,3,'Replicates',15);
    [~,smallId] = min(lineCents);
    
    %meanThresh = mean(meanTestCol);

    %stdThresh = std(meanTestCol(meanTestCol < meanThresh));

    %gemaraFinderPrime = sortrows(gemaraFinder(meanTestCol > meanThresh + stdThresh,:),2);
    gemaraFinderPrime = sortrows(gemaraFinder(lineIds ~= smallId,:),2);
    gemaraFinderPrime = gemaraFinderPrime(gemaraFinderPrime(:,1) > thresh & gemaraFinderPrime(:,2) >= startRow,:);
    topline = gemaraFinderPrime(n,:);
    topline(2) = topline(2);% + startRow - 1;
    topline(3) = topline(3);% + startRow - 1;
catch e %if a sufficiently big line does not exist
    topline = zeros(1,3)-1;
end
end

