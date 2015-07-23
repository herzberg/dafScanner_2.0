clc, clear, close all;

gemdirname = '../1blockScanner/gemaraPics';
mesechtas = dir(gemdirname);
mesechtas = mesechtas([mesechtas.isdir]);
for mm = 11:length(mesechtas)
mesechta = mesechtas(mm).name

files = dir([gemdirname '/' mesechta]);
realFiles = files(not([files.isdir]));

startnum = str2double(realFiles(1).name(strfind(realFiles(1).name,'Page_')+5:strfind(realFiles(1).name,'.png')-1));

for ii = 1:length(realFiles)
  try  
    currnum = str2double(realFiles(ii).name(strfind(realFiles(ii).name,'Page_')+5:strfind(realFiles(ii).name,'.png')-1));
    
dafOrig = imread([gemdirname '/' mesechta '/' realFiles(ii).name]);
    [~,leftSideEnd] = findRLDaf(dafOrig,'l');
    [rightSideStart,~] = findRLDaf(dafOrig,'r');
    
    %cut off left and right crud
    daf = dafOrig(:,leftSideEnd:rightSideStart);

   
   top = getnthbigline(daf,1,1,4,1,100,round(size(daf,2)/2),10);
   bot = getnthbigline(daf,2,1,4,1,100,round(size(daf,2)/2),10);
   
   titlebar = daf(round((top(2)+top(1)/2)):round((bot(2)+bot(1)/2)),:);
   [n,s,f] = onestreams(sum(titlebar,1) == size(titlebar,1));
   
   nums = 1:length(n);
   [~,mind1] = max(n);
   [~,mind2] = max(n(nums ~= mind1));
   

   
   %figure;imshow(titlebar);
   
   dafhq = imread([gemdirname 'HQ/' mesechta '/' realFiles(ii).name]);
   xratio = size(dafhq,1)/size(dafOrig,1);
   yratio = size(dafhq,2)/size(dafOrig,2);
   
   %titlebarhq = dafhq(round((top(2)+top(1)/2)*yratio):round((bot(2)+bot(1)/2)*yratio),:);
   if mind2 >= mind1
       titlebarhq = dafhq(round((top(2)+top(1)/2)*yratio):round((bot(2)+bot(1)/2)*yratio),round((s(mind1)+n(mind1)/2+leftSideEnd)*xratio):round((s(mind2+1)+n(mind2+1)+leftSideEnd)*xratio));
       %titlebar = titlebar(:,round(s(mind1)+n(mind1)/2):round(s(mind2+1)+n(mind2+1)));
   else
       titlebarhq = dafhq(round((top(2)+top(1)/2)*yratio):round((bot(2)+bot(1)/2)*yratio),round((s(mind2)+n(mind2)/2+leftSideEnd)*xratio):round((s(mind1)+n(mind1)/2+leftSideEnd)*xratio));
       %titlebar = titlebar(:,round(s(mind2)+n(mind2)/2):round(s(mind1)+n(mind1)/2));
   end
   
   %figure;imshow(titlebarhq);
   imwrite(titlebarhq,['gemtitles/' mesechta '_' int2str(currnum-startnum+3) '.png']);
   %figure;imshow(daf);hold on;
   %plot([1 size(daf,2)],[top(2)+top(1)/2,top(2)+top(1)/2],'r');
   %plot([1 size(daf,2)],[bot(2)+bot(1)/2,bot(2)+bot(1)/2],'b');
   %hold off;
  catch
      break;
  end
end
end