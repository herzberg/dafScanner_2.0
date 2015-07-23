%brachos 100...top line is wrong

%debug
%brachos: 73,91,115,123,124,126,133 (tos on bottom), 135,137
%brachosRash: 22,53 has bottom crud, 59, 70 (middle line in slighlty wrong
%brachosTos: 47,56
%place),113,116,123 (really bad)

%rh: 45,46, 72 (mid tosfos)
%rhTos: 18,46,57,72

%shabbos: 61
%shabbosRash: 22

%brachos perek breaks: 49b
%brachos: start = 18
%yevamos: start = 14
%avodah_zara = 8
%shabbos = 14
%eruvin = 14
%shekalim = 610
%nazir = 380

%problems
%   sometimes it goes down too far on right or left and screws up
%   eg: avodah_zara: 70a

%   sometimes the assumption that column width = row width for margins is
%   wrong eg avoda_zara: 2a

%   crashes on nazir 442. (33b) no surprise there

%hadran at end of page causes problems


%brachos 30a has no tos
%yev 69a
clc, clear, close all;

%debug
showGemContour = 0;
showRashContour = 0;
showTosContour = 0;
showCutouts = 0;

%35a,37b,48b
%inputs
mesechtas = dir('gemaraPics');
mesechtas = mesechtas([mesechtas.isdir]);
for k = 11:11 %length(mesechtas) % start at 3 bc of . and ..
disp('--------------------------------------------------------------------------------------------------------');
mesechtaName = mesechtas(k).name
disp('--------------------------------------------------------------------------------------------------------');
startScanDafStr = '2a';

realFiles = dir(['gemaraPics/' mesechtaName]);
realFiles = realFiles(not([realFiles.isdir]));
startMesDaf = Inf;
for l = 1:length(realFiles);
   tempName = realFiles(l).name;
   startNumPos = find(tempName == '_',2)+1;
   startNumPos = startNumPos(2);
   endNumPos = find(tempName == '.',1)-1;
   fileNum = str2double(tempName(startNumPos:endNumPos));
   if isnan(fileNum) %because of two word mesechta names
        startNumPos = find(tempName == '_',3)+1;
       startNumPos = startNumPos(3);
       endNumPos = find(tempName == '.',1)-1;
       fileNum = str2double(tempName(startNumPos:endNumPos)); 
   end
   
   if fileNum < startMesDaf
       startMesDaf = fileNum;
   end
end

numDafToScan = 1000;
startScanDaf = dafStr2Int(startScanDafStr) + startMesDaf;

botlines = zeros(1,numDafToScan);

imcloseCoef = -12;
for i=startScanDaf:startScanDaf+numDafToScan-1
    isAmudAlef = mod(i-startMesDaf,2) == 0;
    
    gemPointsR = []; %vector of points in gemoutline
    gemPointsL = [];
    
    %deal with zero in Page_ string problem
    zeroCat = '';
    if i < 10
        zeroCat = '00';
    elseif (i < 100) 
        zeroCat = '0';
    end
    s=strcat(['gemaraPics/' mesechtaName '/' mesechtaName '_Page_' zeroCat],num2str(i),'.png');
    try
        imOrig=imread(s);
    catch
        disp('scan completed (or the file you want doesnt exist)');
        break;
    end
    [~,leftSideEnd] = findRLDaf(imOrig,'l');
    [rightSideStart,~] = findRLDaf(imOrig,'r');
    
    %cut off left and right crud
    im = imOrig(:,leftSideEnd:rightSideStart);
    
    %% TOP AND BOTTOM LINES
    centerCol = round(size(im,2)/2);
    
    ttopline = getnthbigline(im,2,1,3,1,60,centerCol,0);
    topline = getnthbigline(im,3,1,3,1,60,centerCol,10);
    if isequal(topline,[-1,-1,-1]) %you couldn't find it. gemara is probably either left justified or right justified
        toplineL = getnthbigline(im,3,1,3,1,60,round(size(im,2)/4),10);
        toplineR = getnthbigline(im,3,1,3,1,60,round(3*size(im,2)/4),10);
        toplineL(toplineL == -1) = Inf;
        toplineR(toplineR == -1) = Inf;
        if toplineL(2) < toplineR(2)
            topline = toplineL;
        else 
            topline = toplineR;
        end
    end
    
    topHeight = round((topline(2)-ttopline(3))/2); %the height of the top portion where the vertical line b/w rash and tos is
    
    %lots of params. only look at 1/5 to 4/5 of daf width. only look
    %between top 2 lines.
    mid = getnthbigline(im,1,round(size(im,2)/5),5/4,2,topHeight,ttopline(3)+topHeight,10);
    
    
    hasTos = true; %does amud have tosfos?
    
    %one check to see if there's tosfos. check if there's no middle line.
    %if true, check if there's no tosline. if true hasTos = false
    tosLine = [-1,-1,-1];
    if isequal(mid,[-1,-1,-1])
        tosWindow = 30; %how long should your line be?
        if isAmudAlef
            startCol = round(size(im,2)/5);
            endDiv = 8/3; %before halfway mark so you don't pick up a weird rashi vert line in the middle
        else
            startCol = round(5*size(im,2)/8);
            endDiv = 5/4;
        end
        tosLine = getnthbigline(im,1,startCol,endDiv,2,tosWindow,topline(3)+tosWindow,10);
        if isequal(tosLine,[-1,-1,-1])
            hasTos = false;
        end
        %figure;imshow(im);hold on;plot([tosLine(2)+tosLine(1)/2,tosLine(2)+tosLine(1)/2],[topline(3),topline(3)+2*tosWindow]);hold off;
        %continue;
    end
    

    
    
    %check bottom 4 lines. if perek break, there should be a fourth line.
    disp(int2str(i));
    botline = getnthbigline(im,1,topline(3),1,1,60,centerCol,10);
    botlines(i) = botline(2);
    yo = getnthbigline(im,1,botline(3),1,1,60,centerCol,0);
    yoyo = getnthbigline(im,1,yo(3),1,1,60,centerCol,0);
    yoyoyo = getnthbigline(im,1,yoyo(3),1,1,60,centerCol,0);
    yoyoyoyo = getnthbigline(im,1,yoyoyo(3),1,1,60,centerCol,0);
    
    %figure;imshow(im);hold on; plot([1,size(im,2)],[botline(2)+botline(1)/2,botline(2)+botline(1)/2],'b');plot([1,size(im,2)],[yo(2)+yo(1)/2,yo(2)+yo(1)/2],'r');plot([1,size(im,2)],[yoyo(2)+yoyo(1)/2,yoyo(2)+yoyo(1)/2],'m');
    %plot([1,size(im,2)],[yoyoyo(2)+yoyoyo(1)/2,yoyoyo(2)+yoyoyo(1)/2],'m');
    %continue;    
    
    perekBreakHeight = 50;
    botYs = [yo(2),yoyo(2),yoyoyo(2)];
    diffBotYs = diff(botYs);
    %the second criteria checks that your other botlines aren't actually
    %consecutive lines of rabenu chananel or rashi or whatever
    if (yoyoyo(1) ~= -1 && yo(2)-botline(2) < perekBreakHeight) && sum(abs(diffBotYs(1)-diffBotYs) < 10) == 0
        botline = yoyo;
        yo = yoyoyo;
        %there's a perek break
    end
    

    

    start(i) = topline(2);
     %title('found the top of gemara')
    
    
    %plot(1:length(im),repmat(botline(2) + 0.05*botline(1),length(im)));
    try 
        [topleft, topright] = getRLCorners(im,topline,hasTos,isAmudAlef,imcloseCoef,tosLine);
        %for first daf of mesechta
        if i == startMesDaf
            botline = yoyoyo;
            yo = yoyoyoyo;
            topleft(1) = topleft(1)/2;
            topleft(3) = topleft(3) - topleft(1);
            topright(1) = topright(1)/2;
            topright(2) = topright(2) + topright(1);
        end
        topLeftPoint = [topleft(2) + (topleft(3)-topleft(2))/2,topline(2) + (topline(3)-topline(2))/2]; % get the avg of points
        topRightPoint = [topright(2) + (topright(3)-topright(2))/2,topline(2) + (topline(3)-topline(2))/2];
    catch e
        try
            [topleft, topright] = getRLCorners(im,topline,hasTos,isAmudAlef,2);
            topLeftPoint = [topleft(2) + (topleft(3)-topleft(2))/2,topline(2) + (topline(3)-topline(2))/2]; % get the avg of points
            topRightPoint = [topright(2) + (topright(3)-topright(2))/2,topline(2) + (topline(3)-topline(2))/2];
        catch e
            disp('daf scan failed could not find top line');
            continue;
        end
    end


    gemPointsR = [gemPointsR; topLeftPoint; topRightPoint];
    %plot([gemPointsR(end-1,1),gemPointsR(end,1)],[gemPointsR(end-1,2),gemPointsR(end,2)],'m');

    %% RIGHT EDGE
    try
        start = topline(3);
        [corn,dim,start,direction] = nextJunctionFinder(im,topright,start,2,'d',imcloseCoef);

        



        if corn(2) > botline(2) % already reached bottom line, no need to check for right protrusion
            cornPoint = [topright(2) + (topright(3)-topright(2))/2, corn(2) + (corn(3)-corn(2))/2];
            gemPointsR = [gemPointsR; cornPoint(1), botline(2) + 0.05*botline(1)];
            %plot([gemPointsR(end-1,1), gemPointsR(end,1)],[gemPointsR(end-1,2), gemPointsR(end,2)]);
            %disp('too far right')
        else 
            cornPointPrev = [topright(2) + (topright(3)-topright(2))/2,corn(2) + (corn(3)-corn(2))/2];
            %gemPointsR = [gemPointsR; cornPoint];
            %go right once
            %figure;imshow(im);hold on;plot([topRightPoint(1), cornPoint(1)],[topRightPoint(2), cornPoint(2)]);hold off;
            [corn2,dim2,start2,direction] = nextJunctionFinder(im,corn,start,dim,'r',imcloseCoef);
            %also check slightly above the corner and see if you can get
            %farther left b/c sometimes you go too far into the gemara text
            cornPrime = [corn(1) corn(2)-10 corn(3)-10];
            [corn3,dim3,start3,direction3] = nextJunctionFinder(im,cornPrime,start,dim,'r',imcloseCoef);
            
            cornPoint2 = [corn2(2) + (corn2(3)-corn2(2))/2, corn(2) + (corn(3)-corn(2))/2];
            cornPoint3 = [corn3(2) + (corn3(3)-corn3(2))/2, cornPrime(2) + (cornPrime(3)-cornPrime(2))/2];
            if cornPoint3(1) > cornPoint2(1) && abs(cornPoint3(1)-cornPointPrev(1)) > 30
                disp('extra right');
                cornPointPrev(2) = cornPrime(2) + (cornPrime(3)-cornPrime(2))/2;
                cornPoint = cornPoint3;
            else
                cornPoint = cornPoint2;
            end
            gemPointsR = [gemPointsR; topRightPoint; cornPointPrev];
            gemPointsR = [gemPointsR; cornPoint];

            %go down until botline
            gemPointsR = [gemPointsR; cornPoint(1), botline(2) + 0.05*botline(1)];
            %plot([gemPointsR(end-1,1),gemPointsR(end,1)],[gemPointsR(end-1,2),gemPointsR(end,2)]);
        end
    catch e
        disp('daf scan could not find right edge');
        continue;
    end
    
    %% LEFT EDGE
    try
        start = topline(3);
        [corn,dim,start,direction] = nextJunctionFinder(im,topleft,start,2,'d',imcloseCoef);

        
        
        %figure;imshow(im);hold on;
        %leeway as to when we say the left edge has reached the bottom line
        botlinebuffer = 2;
        if corn(2) >= botline(2)-botlinebuffer % already reached bottom line, no need to check for left protrusion
            cornPoint = [topleft(2) + (topleft(3)-topleft(2))/2,corn(2) + (corn(3)-corn(2))/2];
            gemPointsL = [gemPointsL; topLeftPoint; cornPoint(1), botline(2) + 0.05*botline(1)];
            %plot([gemPointsL(end-1,1), gemPointsL(end,1)],[gemPointsL(end-1,2), gemPointsL(end,2)]);
            %disp('too far left')
        else 
            cornPointPrev = [topleft(2) + (topleft(3)-topleft(2))/2,corn(2) + (corn(3)-corn(2))/2];
            %go left once
            %plot([gemPointsL(end-1,1),gemPointsL(end,1)],[gemPointsL(end-1,2),gemPointsL(end,2)]);
            [corn2,dim2,start2,direction] = nextJunctionFinder(im,corn,start,dim,'l',imcloseCoef);
            
            %also check slightly above the corner and see if you can get
            %farther left b/c sometimes you go too far into the gemara text
            cornPrime = [corn(1) corn(2)-20 corn(3)-20];
            [corn3,dim3,start3,direction3] = nextJunctionFinder(im,cornPrime,start,dim,'l',imcloseCoef);
            
            cornPoint2 = [corn2(2) + (corn2(3)-corn2(2))/2, corn(2) + (corn(3)-corn(2))/2];
            cornPoint3 = [corn3(2) + (corn3(3)-corn3(2))/2, cornPrime(2) + (cornPrime(3)-cornPrime(2))/2];
            if cornPoint3(1) < cornPoint2(1) && abs(cornPoint3(1)-cornPointPrev(1)) > 30
                disp('extra left');
                cornPointPrev(2) = cornPrime(2) + (cornPrime(3)-cornPrime(2))/2; %set to match cornPrime
                cornPoint = cornPoint3;
            else
                cornPoint = cornPoint2;
            end
            gemPointsL = [gemPointsL; topLeftPoint; cornPointPrev];
            gemPointsL = [gemPointsL; cornPoint];
            %plot([gemPointsL(end-2,1),gemPointsL(end-1,1)],[gemPointsL(end-2,2),gemPointsL(end-1,2)]);
            %plot([gemPointsL(end-2,1),gemPointsL(end,1)],[cornPrime(2),gemPointsL(end,2)]);
            %go down until botline
            gemPointsL = [gemPointsL; cornPoint(1), botline(2) + 0.05*botline(1)];
            %plot([gemPointsL(end-1,1),gemPointsL(end,1)],[gemPointsL(end-1,2),gemPointsL(end,2)]);
        end
    catch e
        disp('daf scan could not find left edge');
        continue;
    end
    
    %% GEMARA CONTOUR
    %flip left points so that we have a cnts contour
    gemContour = [gemPointsR; gemPointsL(end:-1:1,:)];
    %plot daf
    
    if showGemContour
        figure;imshow(im);
        %plot daf outline (hopefully it's good)
        hold on;
        for ii = 1:size(gemContour,1)-1
           plot([gemContour(ii,1),gemContour(ii+1,1)],[gemContour(ii,2),gemContour(ii+1,2)]); 
        end
        hold off;
    end

    %cutout last element becuase it's a repeat
    gemContour = gemContour(1:end-1,:);


    
    %% RASHI / TOSFOS CONTOURS

    
    secondbotY = yo(2)+yo(1)/2;
    
    
    
    rashContour = cutoutRashTos(im,0,isAmudAlef,gemPointsL,gemPointsR,secondbotY,topline,ttopline,botline,mid);
    if hasTos
        tosContour = cutoutRashTos(im,1,isAmudAlef,gemPointsL,gemPointsR,secondbotY,topline,ttopline,botline,mid);
    end
    
    if showRashContour
        figure;imshow(im);
        %plot daf outline (hopefully it's good)
        hold on;
        for ii = 1:size(rashContour,1)-1
           plot([rashContour(ii,1),rashContour(ii+1,1)],[rashContour(ii,2),rashContour(ii+1,2)]); 
        end
        hold off;
    end
    
    if showTosContour
        figure;imshow(im);
        %plot daf outline (hopefully it's good)
        hold on;
        for ii = 1:size(tosContour,1)-1
           plot([tosContour(ii,1),tosContour(ii+1,1)],[tosContour(ii,2),tosContour(ii+1,2)]); 
        end
        hold off;
    end
    
    
    %% CUT OUT THE SECTIONS!
    s=strcat(['gemaraPicsHQ/' mesechtaName '/' mesechtaName '_Page_' zeroCat],num2str(i),'.png');
    zeroCatPrime = '';
    if i-startMesDaf+3 < 10
        zeroCatPrime = '00';
    elseif (i-startMesDaf+3 < 100) 
        zeroCatPrime = '0';
    end
    
    zeroCatPrimePrime = '';
    if i-startMesDaf+3 < 10
        zeroCatPrimePrime = '0';
    elseif (i-startMesDaf+3 < 100) 
        zeroCatPrimePrime = '';
    end
    sprime = strcat(['gemaraPicsHQ/' mesechtaName '/' mesechtaName '_Page_' zeroCatPrime],num2str(i-startMesDaf+3),'.png');
    sprimeprime = strcat(['gemaraPicsHQ/' mesechtaName '/' mesechtaName '_Page_' zeroCatPrimePrime],num2str(i-startMesDaf+3),'.png');
    try 
        try
            imHq = imread(s);
        catch
            %in case hq is normalized daf and non-hq isn't...
            try
                imHq = imread(sprime);
            catch
                imHq = imread(sprimeprime);
            end
        end
        xratio = size(imHq,1)/size(imOrig,1);
        yratio = size(imHq,2)/size(imOrig,2);
        %gemara
        gemContour(:,1) = gemContour(:,1) + leftSideEnd - 1; %dont forget to offset by when you cutout rabanu chananel :(
        gemContour(:,1) = gemContour(:,1).*xratio;
        gemContour(:,2) = gemContour(:,2).*yratio;
        croppedGemara = cropBySectionContour(gemContour,imHq);
        str = ['./results/cutoutGemara/' mesechtaName '/' mesechtaName '_' int2str(i-startMesDaf+3) '.png'];
        imwrite(croppedGemara,str);
        if showCutouts
            figure;imshow(croppedGemara);
        end

        %rashi
        rashContour(:,1) = rashContour(:,1) + leftSideEnd - 1; %dont forget to offset by when you cutout rabanu chananel :(
        rashContour(:,1) = rashContour(:,1).*xratio;
        rashContour(:,2) = rashContour(:,2).*yratio;
        croppedRashi = cropBySectionContour(rashContour,imHq);
        str = ['./results/cutoutRashi/' mesechtaName '/' mesechtaName '_' int2str(i-startMesDaf+3) '.png'];
        imwrite(croppedRashi,str);
        if showCutouts
            figure;imshow(croppedRashi);
        end

        %tosfos
        if hasTos
            tosContour(:,1) = tosContour(:,1) + leftSideEnd - 1; %dont forget to offset by when you cutout rabanu chananel :(
            tosContour(:,1) = tosContour(:,1).*xratio;
            tosContour(:,2) = tosContour(:,2).*yratio;
            croppedTosfos = cropBySectionContour(tosContour,imHq);
            str = ['./results/cutoutTosfos/' mesechtaName '/' mesechtaName '_' int2str(i-startMesDaf+3) '.png'];
            imwrite(croppedTosfos,str);
            if showCutouts
                figure;imshow(croppedTosfos);
            end
        end
    catch e
        disp('you don"t have hq for this daf.. :(');
    end
end
end



