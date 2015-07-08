function [ globStatStructs,globWs,globSs ] = getLineStats( dafdirname, realFiles )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
globWs = [];
globSs = [];
globStatStructs = {};
start = 1;
for ii = start:length(realFiles)
    
    
   daf = imread([dafdirname '/' realFiles(ii).name]);
   
   try
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
       boolVerts = sum(hLine,1) >= size(hLine,1);
       [n1,s1,f1] = onestreams(boolVerts);
       %second pass
       boolVerts = n1 < 75;
       [n2,s2,f2] = onestreams(boolVerts);
       [~,lineInd] = max(n2);
       
       %try
       if ~isempty(lineInd)
           lineWs(jj) = abs(s1(f2(lineInd)+1)-f1(s2(lineInd)-1));
           lineStarts(jj) = f1(s2(lineInd)-1);
%        catch
       else
           lineWs(jj) = abs(s1(end)-f1(1));
           lineStarts(jj) = f1(1);
       end
       %figure;imshow(hLine);hold on;plot([lineStarts(jj) lineStarts(jj)+lineWs(jj)],[size(hLine,1)/2 size(hLine,1)/2],'m');hold off;
       %close all;
   end
   %hold off;
   globWs = [globWs lineWs];
   globSs = [globSs lineStarts];
   
   dafStatStruct = struct('widths',lineWs,'starts',lineStarts,'ys',lineYs,'name',realFiles(ii).name);
   globStatStructs(ii-start+1) = {dafStatStruct};
   catch e
      disp(['line stats failed for ' realFiles(ii).name]);  
   end
end

end

