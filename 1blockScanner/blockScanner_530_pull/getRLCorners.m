function [left, right ] = getRLCorners( im, topline )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

h=topline(3)-round(topline(1)/2):topline(3)+round(topline(1)/2);
arbitrary_scaling = 1;
croppedim = im(h,:);
one_zero=sum(croppedim,1) >= length(h)*arbitrary_scaling;
[numones,start,finish] = onestreams(one_zero);
clearHoriz=[numones' start' finish'];
gemaraFinder = sortrows(clearHoriz,1);
gemaraFinder = sortrows(gemaraFinder(end-1:end,:),2);
left = gemaraFinder(gemaraFinder(:,2)==min(gemaraFinder(:,2)),:);
right = gemaraFinder(gemaraFinder(:,2)==max(gemaraFinder(:,2)),:);
end

