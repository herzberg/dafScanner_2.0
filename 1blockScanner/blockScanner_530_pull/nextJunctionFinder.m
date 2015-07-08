function [ nextWindow,nextDim,nextStart ] = nextJunctionFinder( img,corner,start,dim)
%dir = ['u','d','l','r'
shrinkWindow = 3;
if dim == 1
    otherDim = 2;
    window = img(corner(2)+shrinkWindow:corner(3)-shrinkWindow,start:end);
else % dim == 2
    otherDim = 1;
    window = img(start:end,corner(2)+shrinkWindow:corner(3)-shrinkWindow);
end



arbitraryScaling = 0.99;

se = strel('rectangle',[2 2]);
%window = imclose(window,se);

one_zero = sum(window,dim) >= size(window,dim)*arbitraryScaling;
[n,s,f] = onestreams(one_zero);

juncIndex = f(1) + start;

nextWindow=juncIndex;
nextDim=1;
nextStart=1;


end

