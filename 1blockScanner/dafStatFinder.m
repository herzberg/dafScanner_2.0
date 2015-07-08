clc;clear;close all;
%doing good. keep it up. need to break up large lines and combine small
%lines


mesechta = 'yevamos';
type = 'rashi'; %could be 'gemara', 'rashi' or 'tosfos'
capType = [upper(type(1)) type(2:end)];

dafdirname = ['results/cutout' capType '/' mesechta];
statdirname = ['../' type '/' mesechta];
dafdir = dir(dafdirname);
realFiles = dafdir(not([dafdir.isdir]));

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


globWs = [];
globSs = [];
globStatStructs = {};
start = 58+5;
for ii = start:start
   dafOrig = imread([dafdirname '/' realFiles(ii).name]);
   %get rid of small blips and then open so that lines are easier to find
   
   if isequal(type,'gemara')
       daf = imclose(dafOrig,strel('disk',3));
       daf = imopen(daf,strel('disk',10));
       perc = 0.99;
       amt = 0;
   else
       %daf = imclose(dafOrig,strel('disk',3));
       %daf = imopen(daf,strel('disk',7));
       daf = dafOrig;
       perc = 0.99;
       amt = 0;
   end
   
   boolLines = sum(daf,2) >= size(daf,2)*perc - amt;
   [n,s,f] = onestreams(boolLines);
   
   [ids,cs] = kmeans(n(2:end-1)',4,'Start',zeros(4,1));
   [~,badId] = min(cs);
   ids = [0; ids]; %append 0 so that it's now same size as n,s,f b/c you truncated it in kmeans
   n = n(ids ~= badId);
   s = s(ids ~= badId);
   f = f(ids ~= badId);
   
   lineWs = zeros(1,length(n)-1);
   lineYs = s(1:end-1)+n(1:end-1)/2;
   lineStarts = zeros(1,length(n)-1);
   
   %get missing lines
   heights = s(3:end-1)+n(3:end-1)/2 - (f(2:end-2) - n(2:end-2)/2);
   avgN = mean(n(2:end-1));
   heights = [s(2)-f(1)+avgN heights s(end)-f(end-1)+avgN];
   
   [hi,hc] = kmeans(heights',2,'Start',zeros(2,1));
   [~,bigi] = max(abs(hc - (mean(heights)+std(heights))));
   
   bigInds = hi == bigi;
   bigHeights = heights(bigInds);
   normHeight = mean(heights(~bigInds));
   multHeights = round(bigHeights/normHeight);

   nums = 1:length(n);
   bigNums = nums(bigInds);
   
   justSawSmallLine = false; %b/c small lines come in pairs, skip second one
   for kk = 1:length(bigHeights)
      if bigNums(kk) == 1 %off by one error
          multHeights(kk) = multHeights(kk)+1;
      end
      
      %if a small line, cut out the second one (they should always come in
      %pairs)
      if multHeights(kk) <= 1
         if ~justSawSmallLine 
             s = [s(1:bigNums(kk)) s(bigNums(kk)+2:end)];
             f = [f(1:bigNums(kk)) f(bigNums(kk)+2:end)];
             justSawSmallLine = true;
             bigNums(kk+1:end) = bigNums(kk+1:end) - 1; % update indexes bc you just changed things
         else
             justSawSmallLine = false;
         end
      else
          s = [s(1:bigNums(kk)), s(bigNums(kk)+1)-(multHeights(kk)-1:-1:1)*normHeight, s(bigNums(kk)+1:end)];
          f = [f(1:bigNums(kk)), f(bigNums(kk)+1)-(multHeights(kk)-1:-1:1)*normHeight, f(bigNums(kk)+1:end)];
          bigNums(kk+1:end) = bigNums(kk+1:end)+multHeights(kk)-1;
      end
   end
   n = f-s;
   
   figure;imshow(daf);
   hold on;
   for jj = 1:length(n)
       plot([1 size(daf,2)],[s(jj)+n(jj)/2,s(jj)+n(jj)/2]);
       if jj < length(n)
           hLine = daf(round(f(jj)-n(jj)/2):round(s(jj+1)+n(jj+1)/2),:);
       else
           hLine = daf(round(f(jj)-n(jj)/2):end,:);
       end
       %(s(jj+1)+n(jj+1)/2) - (f(jj)-n(jj)/2);
       boolVerts = sum(hLine,1) == size(hLine,1);
       [n1,s1,f1] = onestreams(boolVerts);
       lineWs(jj) = s1(end)-f1(1);
       lineStarts(jj) = f1(1);
      
       %figure;imshow(hLine);
   end
   globWs = [globWs lineWs];
   globSs = [globSs lineStarts];
   
   dafStatStruct = struct('widths',lineWs,'starts',lineStarts,'ys',lineYs,'name',realFiles(ii).name);
   globStatStructs(ii-start+1) = {dafStatStruct};
   hold off
   
   %figure;stem(heights(1:end));
end
%% classify
% clc; close all;
% 
% 
% 
% if isequal(type,'gemara')
%     numWidthCats = 3;
%     numStartCats = 4;
%     numStartCatsPrime = 2;
% else
%     numWidthCats = 3;
%     numStartCats = 6;
%     numStartCatsPrime = 3;
% end
% [idWidths,cWidths] = kmeans(globWs',numWidthCats,'Start',zeros(numWidthCats,1));
% 
% %first classify into 4 cats to deal with amud alef and bet. then classify
% %classification into 2 cats to find amud alef and bet
% [idStarts,cStarts] = kmeans(globSs',numStartCats,'Start',zeros(numStartCats,1));
% [idStartsPrime,cStartsPrime] = kmeans(cStarts,numStartCatsPrime,'Start',zeros(numStartCatsPrime,1));
% idStartsPrime = idStartsPrime + numStartCats;
% for ii = 1:numStartCats
%    idStarts(idStarts == ii) = idStartsPrime(ii); 
% end
% idStarts = idStarts - numStartCats;
% 
% %relabel classes numbers so that they are consistent
% nums = 1:length(cWidths);
% [~,sortedIds] = sort(cWidths);
% sortedIds = sortedIds + numWidthCats;
% for ii = 1:numWidthCats
%    idWidths(idWidths == ii) = sortedIds(ii);
% end
% idWidths = idWidths - numWidthCats;
% 
% nums = 1:numStartCatsPrime;
% [~,sortedIds] = sort(cStartsPrime);
% sortedIds = sortedIds + numStartCatsPrime;
% for ii = 1:numStartCatsPrime
%    idStarts(idStarts == ii) = sortedIds(ii); 
% end
% idStarts = idStarts - numStartCatsPrime;
% 
% 
% 
% 
% 
% idCount = 0;
% 
% iwant = 18;
% 
% for jj = 1:iwant%length(globStatStructs);
%    tempStruct = globStatStructs{jj};
%    numItems = length(tempStruct.widths);
%    tempStruct.idWidths = idWidths(idCount+1:idCount+numItems);
%    tempStruct.idStarts = idStarts(idCount+1:idCount+numItems);
%    globStatStructs(jj) = {tempStruct};
%    idCount = idCount + numItems;
%    
%    %print to file
%    startNumPos = find(tempStruct.name == '_',1)+1;
%    endNumPos = find(tempStruct.name == '.',1)-1;
%    fileNum = str2double(tempStruct.name(startNumPos:endNumPos)) - mesechtaStartNum + 3; %3 so that they match up with josh's numbering
%    %fileId = fopen([statdirname '/' int2str(fileNum) '_stats.txt'],'w');
%    %fprintf(fileId,[tempStruct.name ',%d,%d,%d\n'],[tempStruct.idWidths,tempStruct.idStarts,(1:numItems)']');
%    %fclose(fileId);
%    
%    %debug imshows below-------------
%    if jj >= iwant
%        daf = imread([dafdirname '/' tempStruct.name]);
%        figure;imshow(daf);
%        hold on;
%        for kk = 1:numItems
%            if tempStruct.idWidths(kk) == 1
%                color = 'r';
%            elseif tempStruct.idWidths(kk) == 2
%                color = 'g';
%            elseif tempStruct.idWidths(kk) == 3
%                color = 'b';
%            else 
%                color = 'm';
%            end
% 
%            if tempStruct.idStarts(kk) == 1
%                marker = 'o';
%            elseif tempStruct.idStarts(kk) == 2
%                marker = 'x';
%            else 
%                marker = '*';
%            end
% 
%            plot([tempStruct.starts(kk) tempStruct.starts(kk)+tempStruct.widths(kk)],[tempStruct.ys(kk),tempStruct.ys(kk)],[color '-' marker]);
% 
%        end
%        hold off;
%    end
%end