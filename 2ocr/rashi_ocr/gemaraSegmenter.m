clc, clear, close all;

input = '../../1blockScanner/results/cutoutGemara/brachos/brachos_19.png';
outputDir = 'rashiChars';
daf = logical(imread(input));
output = dir(outputDir);
realFiles = output(not([output.isdir]));
numFiles = length(realFiles);

maxPics = 20;

%% segment rashi into chars
dafScrewedUp = imclose(daf,strel('disk',3));
dafScrewedUp = imopen(dafScrewedUp,strel('disk',10));
perc = 0.99;
hLines = sum(dafScrewedUp,2) >= size(daf,2)*perc;
[n,s,f] = onestreams(hLines);

%maxLines = length(n)-1
maxLines = 4;

count = 0;
for ii = maxLines:maxLines
    hLine = daf(f(ii):s(ii+1),1:size(daf,2));
    figure;imshow(hLine);
    cc = bwconncomp(~hLine);
    inds = sepLetterFinder(hLine,cc);
    for jj = 1:size(inds,1)
       pList1 = cc.PixelIdxList{inds(jj,1)};
       pList2 = cc.PixelIdxList{inds(jj,2)};
       
       pList = [pList1; pList2];
       pListX = ceil(pList/size(hLine,1));
       pListX = pListX - min(pListX);
       
       pListY = mod(pList,size(hLine,1));
       pListY(pListY == 0) = size(hLine,1);
       pListY = pListY - min(pListY);
       %flip y
       midY = mean(pListY);
       pListY = -(pListY - midY) + midY;
       
       figure;plot(pListX,pListY,'.b');
       
    end
    
    vChars = sum(hLine,1) >= size(hLine,1)*0.9;
    [n1,s1,f1] = onestreams(vChars);
%     for jj = 1:length(n1)-1
%        tempChar = hLine(1:size(hLine,1),f1(jj):s1(jj+1));
%        count = count + 1;
%        imwrite(tempChar,[outputDir '/' int2str(count) '.png']);
%     end
end
%% rename files
% output = dir(outputDir);
% realFiles = output(not([output.isdir]));
% numFiles = length(realFiles);
% 
% testData = fopen('rashiCharsText.txt','r');
% data = fscanf(testData,'%c');
% fclose(testData);
% for ii = 1:numFiles
%    
%    oldFileName = realFiles(ii).name;
%    oldFileNum = str2num(oldFileName(5:find(oldFileName == '.',1)-1));
%    tempFileName = char([int2str(oldFileNum) 'c' data(oldFileNum) '_'  '.png']);
%    movefile([outputDir '/' realFiles(ii).name],['rashiCharsNew/' tempFileName]); 
% end