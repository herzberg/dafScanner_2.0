function [] = statsClassify( dafdirname, statdirname, realFiles, statsObj )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%stupid. find start num for mesechta
mesechtaStartNum = Inf;
for ii = 1:length(realFiles);
   tempName = realFiles(ii).name;
   startNumPos = find(tempName == '_',1)+1;
   endNumPos = find(tempName == '.',1)-1;
   fileNum = str2double(tempName(startNumPos:endNumPos));
   
   if fileNum < mesechtaStartNum
       mesechtaStartNum = fileNum;
   end
end



%rng(150);

% [idStartsPrime,cStartsPrime] = kmeans(cStarts,numStartCatsPrime,'Replicates',10);
% idStartsPrime = idStartsPrime + numStartCats;
% for ii = 1:numStartCats
%    idStarts(idStarts == ii) = idStartsPrime(ii); 
% end
% idStarts = idStarts - numStartCats;

%relabel classes numbers so that they are consistent

% nums = 1:length(cWidths);
% [~,sortedIds] = sort(cWidths);
% %s(s) gives you the inverse mapping. cool, right?!
% 
% newSortedIds = sortedIds(sortedIds);
% if isequal(newSortedIds,nums')
%     newSortedIds = sortedIds;
% end
% 
% sortedIds = newSortedIds + numWidthCats;
% for ii = 1:numWidthCats
%    idWidths(idWidths == ii) = sortedIds(ii);
% end
% idWidths = idWidths - numWidthCats;
% 
% nums = 1:numStartCatsPrime;
% [~,sortedIds] = sort(cStarts);
% 
% newSortedIds = sortedIds(sortedIds);
% if isequal(newSortedIds,nums')
%     newSortedIds = sortedIds;
% end
% sortedIds = newSortedIds + numStartCatsPrime;
% for ii = 1:numStartCatsPrime
%    idStarts(idStarts == ii) = sortedIds(ii); 
% end
% idStarts = idStarts - numStartCatsPrime;

firstTime = true;
if firstTime
    [globStatStructs,globWs,globSs] = getLineStats(dafdirname,realFiles);
    save('testStats.mat','globStatStructs','globWs','globSs');
else
    disp('WARNING: using old file for stats');
    testStats = open('testStats.mat');
    globWs = testStats.globWs;
    globSs = testStats.globSs;
    globStatStructs = testStats.globStatStructs;
end

idWidths = zeros(1,length(globWs));
idStarts = zeros(1,length(globWs));
for ii = 1:length(globWs)
    D = dist([globWs(ii) statsObj.cWidths']);
    [~, tempId] = min(D(1,2:end));
    idWidths(ii) = tempId;
    
    %assuming globWs and globSs are the same length
    D = dist([globSs(ii) statsObj.cStarts']);
    [~, tempId] = min(D(1,2:end));
    idStarts(ii) = tempId;
end


idCount = 0;

iwant = 30000;

for jj = 1:length(globStatStructs);
   tempStruct = globStatStructs{jj};
   numItems = length(tempStruct.widths);
   tempStruct.idWidths = idWidths(idCount+1:idCount+numItems);
   tempStruct.idStarts = idStarts(idCount+1:idCount+numItems);
   statsObj.globStatStructs(jj) = {tempStruct};
   idCount = idCount + numItems;
   
   %print to file
   
   startNumPos = find(tempStruct.name == '_',1)+1;
   endNumPos = find(tempStruct.name == '.',1)-1;
   fileNum = str2double(tempStruct.name(startNumPos:endNumPos)) - mesechtaStartNum + 3; %3 so that they match up with josh's numbering
   
   fileId = fopen([statdirname '/' int2str(fileNum) '_stats.txt'],'w');
   fprintf(fileId,[tempStruct.name ',%d,%d,%d\n'],[tempStruct.idWidths',tempStruct.idStarts',(1:numItems)']');
   fclose(fileId);
   
   %debug imshows below-------------
   if jj >= iwant-5
       daf = imread([dafdirname '/' tempStruct.name]);
       figure;imshow(daf);
       hold on;
       for kk = 1:numItems-1  %no clue why minus 1. apparently ys is one less than widths and starts
           if tempStruct.idWidths(kk) == 1
               color = 'r';
           elseif tempStruct.idWidths(kk) == 2
               color = 'm';
           elseif tempStruct.idWidths(kk) == 3
               color = 'b';
           else 
               color = 'g';
           end

           if tempStruct.idStarts(kk) == 1
               marker = 'o';
           elseif tempStruct.idStarts(kk) == 2
               marker = 'x';
           else 
               marker = '*';
           end

           plot([tempStruct.starts(kk) tempStruct.starts(kk)+tempStruct.widths(kk)],[tempStruct.ys(kk),tempStruct.ys(kk)],[color '-' marker]);

       end
       hold off;
   end
end

end

