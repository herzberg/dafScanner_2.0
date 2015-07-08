function [left, right ] = getRLCorners( im, topline,isTos,isAmudAlef,imcloseCoef,tosline )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%isTos = 1 when daf is known to have tosfos. This, along with isAmudAlef,
%will affect where you choose right and left corners
%along with tosLine, which is the vertical line where tos borders gem.


%this code relies on the fact that the input im (daf) is cut very close on
%both the right and left
h=topline(3)-round(topline(1)/2):topline(3)+round(topline(1)/2);
arbitrary_scaling = 1;
croppedim = im(h,:);

if imcloseCoef > 0
    se = strel('rectangle',[imcloseCoef imcloseCoef]);
    croppedim = imclose(croppedim,se);
else
    se = strel('rectangle',[-imcloseCoef -imcloseCoef]);
    croppedim = imopen(croppedim,se);
end

one_zero=sum(croppedim,1) >= length(h)*arbitrary_scaling;
[numones,start,finish] = onestreams(one_zero);
clearHoriz=[numones' start' finish'];
gemaraFinder = sortrows(clearHoriz,1);

%this assumes there are at least two eligible points
try
    gemaraFinderPrime = sortrows(gemaraFinder(end-1:end,:),2);
catch e
    if isAmudAlef && ~isTos
        left = [2,1,2];
        right = gemaraFinder(end,:);
        return;
    elseif ~isAmudAlef && ~isTos
        left = gemaraFinder(end,:);
        right = [2,size(im,2)-1,size(im,2)];
        return;
    else
        disp('there is tosfos, but can"t find RL corners...');
    end
end
left = gemaraFinderPrime(gemaraFinderPrime(:,2)==min(gemaraFinderPrime(:,2)),:);
right = gemaraFinderPrime(gemaraFinderPrime(:,2)==max(gemaraFinderPrime(:,2)),:);



if ~isequal(tosline,[-1,-1,-1]);
    if isAmudAlef
        left = tosline;
    else
        right = tosline;
    end
end


if ~isTos && isAmudAlef %then there's probably nothing on the left, just say the left corner is 1
    left = gemaraFinder(gemaraFinder(:,2) == 1,:);
    if isempty(left) %your assumption that there exists a line at 1 is wrong, make a very thin line there
        left = [2,1,2];
    end
elseif ~isTos && ~isAmudAlef
    right = gemaraFinder(gemaraFinder(:,3) == size(im,2),:);
    if isempty(right) %your assumption that there exists a line at size(im,2) is wrong, make a very thin line there
        right = [2,size(im,2)-1,size(im,2)];
    end
end

end

