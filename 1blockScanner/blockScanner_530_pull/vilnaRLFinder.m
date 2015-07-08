clc, clear, close all;
for ii = 18:50
    daf = imread(['brachos/brach1__Page_0' int2str(ii) '.png']);
    [s1,f1] = findRLDaf(daf,'r');
    [s2,f2] = findRLDaf(daf,'l');
    daf(:,s1:f1) = 0;
    daf(:,s2:f2) = 0;
    figure;
    imshow(daf);
end

