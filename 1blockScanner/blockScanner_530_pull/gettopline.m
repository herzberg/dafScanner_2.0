function  topline  = gettopline( im )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
midrow = round(size(im,1)/2);
midcol = round(size(im,2)/2);

% find gemara start
width=40;
w=midcol-width:midcol+width;
arbitrary_scaling = 1;
croppedim=im(:,w);
one_zero=sum(croppedim,2) >= length(w)*arbitrary_scaling;

[numones,start,finish] = onestreams(one_zero');
clearHoriz=[numones' start' finish'];
gemaraFinder = clearHoriz(round(1:length(clearHoriz)/3),:);
gemaraFinder = sortrows(gemaraFinder,1);
gemaraFinder = sortrows(gemaraFinder(end-2:end,:),2);
topline = gemaraFinder(3,:);

end

