clc, clear, close all;

input = '../../1blockScanner/results/cutoutRashi/brachos/brachos_58.png';
input2 = 'rashiOCRtest.png';
outputDir = 'rashiChars';
rashi = logical(imread(input));
output = dir(outputDir);
realFiles = output(not([output.isdir]));
numFiles = length(realFiles);

maxPics = 200;

%% segment rashi into chars
hLines = sum(rashi,2) == size(rashi,2);
[n,s,f] = onestreams(hLines);
perc = 0.95;
for ii = 1:length(n)-1
    hLine = rashi(f(ii):s(ii+1),1:size(rashi,2));
    vChars = sum(hLine,1) >= size(hLine,1)*perc;
    [n1,s1,f1] = onestreams(vChars);
    
    for jj = 1:length(n1)-1
       tempChar = hLine(1:size(hLine,1),f1(jj):s1(jj+1));
    end
end

%% rename files
output = dir(outputDir);
realFiles = output(not([output.isdir]));
numFiles = length(realFiles);

testData = fopen('rashiCharsText.txt','r');
data = fscanf(testData,'%c');
fclose(testData);
for ii = 1:numFiles
   
   oldFileName = realFiles(ii).name;
   oldFileNum = str2num(oldFileName(5:find(oldFileName == '.',1)-1));
   tempFileName = char([int2str(oldFileNum) 'c' data(oldFileNum) '_'  '.png']);
   movefile([outputDir '/' realFiles(ii).name],['rashiCharsNew/' tempFileName]); 
end

%% classify



