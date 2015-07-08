function [ output_args ] = statClassify( mesechta, type )
%type = 'gemara', 'rashi' or 'tosfos'

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
start = 1;
for ii = start:length(realFiles)
   daf = imread([dafdirname '/' realFiles(ii).name]);
   constLeeway = 30; %pixels
   boolLines = sum(daf,2) >= size(daf,2)-constLeeway;
   [n,s,f] = onestreams(boolLines);
   
   heights = s(3:end-1)+n(3:end-1)/2 - (f(2:end-2) - n(2:end-2)/2);
   avgN = mean(n(2:end-1));
   heights = [s(2)-f(1)+avgN heights s(end)-f(end-1)+avgN];
   
   %low pass for line height
   minLineHeight = 20;
   bool = [0 heights < minLineHeight];
   n = n(~bool);
   s = s(~bool);
   f = f(~bool);
   
   lineWs = zeros(1,length(n)-1);
   lineYs = s(1:end-1)+n(1:end-1)/2;
   lineStarts = zeros(1,length(n)-1);
   
   daf = imclose(daf,strel('disk',2));
   daf = imopen(daf,strel('disk',8));
   %figure;imshow(daf);
   %hold on;
   for jj = 1:length(n)
       %plot([1 size(daf,2)],[s(jj)+n(jj)/2,s(jj)+n(jj)/2]);
       if jj < length(n)
           hLine = daf(round(f(jj)-n(jj)/2):round(s(jj+1)+n(jj+1)/2),:);
       else
           hLine = daf(round(f(jj)-n(jj)/2):end,:);
       end
       %(s(jj+1)+n(jj+1)/2) - (f(jj)-n(jj)/2);
       boolVerts = sum(hLine,1) == size(hLine,1);
       [n1,s1,f1] = onestreams(boolVerts);
       lineWs(jj) = abs(s1(end)-f1(1));
       lineStarts(jj) = f1(1);
      
       %figure;imshow(hLine);
   end
   %hold off;
   globWs = [globWs lineWs];
   globSs = [globSs lineStarts];
   
   dafStatStruct = struct('widths',lineWs,'starts',lineStarts,'ys',lineYs,'name',realFiles(ii).name);
   globStatStructs(ii-start+1) = {dafStatStruct};
   
end

save

end

