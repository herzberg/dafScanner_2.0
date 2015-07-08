function [numones, start, finish] = onestreams( one_zero )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if length(one_zero) == 0
    numones = 0;
    start = 1;
    finish = 1;
    return;
end

% find # of ones in each onechunk
add = 0;
one_zero=one_zero(:)';
if one_zero(1) == 1
    add=1;
    one_zero = [ 0 one_zero];
end
if one_zero(end) == 1
    one_zero = [one_zero 0];
end
numones = diff(find(~one_zero))-1;
numones = numones(numones>0);

% find where onechunks start and end
chunk = diff(one_zero);
start = find(chunk==1)+1;
finish = find(chunk==-1);
if add==1
    start = start-1;
    finish=finish-1;
end
end

