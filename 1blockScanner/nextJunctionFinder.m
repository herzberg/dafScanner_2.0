function [ nextWindow,nextDim,nextStart,dir ] = nextJunctionFinder( img,corner,start,dim,dir,imcloseCoef)
%dir = ['u','d','l','r'
%dim 1=>horizontal 2=>vertical
%corner = [thickness,startCol/Row,endCol/Row];
%imcloseCoef controls how much the image is closed when processing. higher
%means more white. generally = 2 when finding a junction inside gemara and
%1 when finding a junction inside rashi
arbitrary_shrinkWin = 3;

if start <= 0
    start = 1;
end

if dim == 1
    otherDim = 2;
    if isequal(dir,'r')
        window = img(corner(2) + arbitrary_shrinkWin:corner(3)-arbitrary_shrinkWin,start:end);
    else %isequal(dir,'l')
        window = img(corner(2) + arbitrary_shrinkWin:corner(3)-arbitrary_shrinkWin,1:start);
    end
else % dim == 2
    otherDim = 1;
    window = img(start:end,corner(2)+arbitrary_shrinkWin:corner(3)-arbitrary_shrinkWin);
end



arbitraryScaling = 0.8;

try
    if imcloseCoef > 0
        se = strel('rectangle',[imcloseCoef imcloseCoef]);
        window = imclose(window,se);
    else
        window = imclose(window,strel('rectangle',[2,1]));
        se = strel('rectangle',[-imcloseCoef -imcloseCoef]);
        window = imopen(window,se);
    end
catch
    nextWindow = [-1,-1,-1];
end
one_zero = sum(window,dim) >= size(window,dim)*arbitraryScaling;
[n,s,f] = onestreams(one_zero);

%factor which looks for a large amount of whitespace in a line which occurs
%even after the end of the first whitespace. This accounts for minor
%blockages (aka 'hint' words)
arb_len_white_space_cutoff = 15;

if isequal(dir,'r') || isequal(dir,'d')
    if length(f) >= 1
        juncIndex = f(1) + start-1; % why -1? No clue...
    else
        juncIndex = start;
    end
    %deal with 'hint' words in the middle of line
    %only check after the first whitespace ends
    largeWhiteInds = n(2:end) > arb_len_white_space_cutoff;
    if sum(largeWhiteInds) > 0 && isequal(dir,'r')
       juncIndex = f(find(largeWhiteInds,1) + 1) + start - 1;
    end
else %isequal(dir,'l') || isequal(dir,'u')
    if length(s) >= 1
        juncIndex = s(end);
    else
        juncIndex = size(window,dim);
    end
    largeWhiteInds = n(end-1:-1:1) > arb_len_white_space_cutoff;
    if sum(largeWhiteInds) > 0 && isequal(dir,'l')
       juncIndex = s(end-find(largeWhiteInds,1));
    end
end
arbitrary_winsize = size(window,dim);
if dim == 1
    try 
        window1 = img(corner(2)-arbitrary_winsize:corner(2),juncIndex-arbitrary_winsize:juncIndex);
        window2 = img(corner(3):corner(3)+arbitrary_winsize, juncIndex-arbitrary_winsize:juncIndex);
    catch e
        window1 = 0;
        window2 = 0;
        %disp('edge error avoided...');
    end
    if sum(window1(:)) > sum(window2(:))
        dir = 'u';
        nextStart = corner(2);
    else %sum(window1(:)) < sum(window2(:))%go down
        dir = 'd';
        if isequal(dir,'r')
            startCol = juncIndex-arbitrary_winsize;
            if (startCol < 1) 
                startCol = 1;
            end
            tempWindow = img(corner(3):end, startCol:juncIndex);
        else %isequal(dir,'l')
            endCol = juncIndex+arbitrary_winsize;
            if (endCol > size(img,2))
                endCol = size(img,2);
            end
            if corner(3) < 1 %due to a very specific error that was annoying me
                corner(3) = 1;
            end
            tempWindow = img(corner(3):end, juncIndex:endCol);
        end
        middle = tempWindow(:,round(size(tempWindow,2)/2));
        [n,s,f] = onestreams(middle);
        [m,i] = max(n);
        arbitrary_offset_that_is_very_convenient = 5;
        nextWindow = tempWindow(s(i)+arbitrary_offset_that_is_very_convenient:end,:);
        
        nextStart = corner(3);
    end
else % dim == 2
    try
        window1 = img(juncIndex-arbitrary_winsize:juncIndex,corner(2)-arbitrary_winsize:corner(2));
        window2 = img(juncIndex-arbitrary_winsize:juncIndex,corner(3):corner(3)+arbitrary_winsize);
    catch e
        window1 = 0;
        window2 = 0;
        %disp('edge error avoided...');
    end
    if sum(window1(:)) > sum(window2(:))
        dir = 'l';
        nextStart = corner(2);
    else %go right
        tempWindow = img(juncIndex-arbitrary_winsize:juncIndex,corner(3):end);
        middle = tempWindow(round(size(tempWindow,1)/2),:);
        [n,s,f] = onestreams(middle);
        [m,i] = max(n);
        arbitrary_offset_that_is_very_convenient = 5;
        
        nextStart = corner(3)+s(i)+arbitrary_offset_that_is_very_convenient;
        dir = 'r';
    end
end
% one_zeroL = sum(window,dim) >= size(window,dim)*arbitraryScaling;
% [n,s,f] = onestreams(one_zeroL);
nextDim=otherDim;

if juncIndex == size(img,otherDim) || juncIndex == 1
    nextWindow = [1,juncIndex,juncIndex];
else
    nextWindow = [arbitrary_winsize,juncIndex-arbitrary_winsize,juncIndex];
end

end

