%% fdfd
clc,clear, close all;
im=imread('daf.png');

SE = strel('rectangle',[10 10]);
%SE = strel('rectangle',[30 30]);
im_filt = imclose(1-im,SE);

%convert to -1s and 1s
im_filt(im_filt==1) = -1;
im_filt(im_filt==0) = 1;
    
%num of pixs that cols can diff in order to be considered the same line
colThresh = 3;
rowThresh = 3;

colMaxArray = zeros(2,size(im_filt,2));
rowMaxArray = zeros(2,size(im_filt,1));
colLines = []; % thickness, length, startY, finishY, x
rowLines = []; % thickness, length, startX, finishX, y

currColStreak = 1;
currRowStreak = 1;

preIm_filt = im_filt;
imshow(im_filt);

% max subarray
for col = 1:size(im_filt,2)
    %star max subarray
    maxsum = im_filt(:,col);
    runsum = maxsum;
    start = 1;
    finish = 1;
    ii = 1;
    for row = 1:size(im_filt,1)
       if im_filt(row,col) > runsum + im_filt(row,col)
           runsum = im_filt(row,col);
           ii = row;
       else
           runsum = runsum + im_filt(row,col);
       end
       if runsum > maxsum
           maxsum = runsum;
           start = ii;
           finish = row;
       end
    end
    %end max subarray
    
    %start line conpounding
    colMaxArray(:,col) = [start;finish];
    if col > 1
        prevStart = colMaxArray(1,col-1);
        prevFinish = colMaxArray(2,col-1);
        if abs(start-prevStart) < colThresh && abs(finish-prevFinish) < colThresh
            currColStreak = currColStreak + 1;
        elseif currColStreak > 1
            lineLen = prevFinish-prevStart;
            %get x for middle of line
            colPos = round(col-1-currColStreak/2);
            colLines = [colLines; currColStreak lineLen prevStart prevFinish colPos];
            currColStreak = 1;
        end
    end
    %end line conpounding
    
    %mark pixels as grey
    im_filt(start:finish,col) = .5;
end


%max sub array and combinering for row
for row = 1:size(im_filt,1)
    maxsum = im_filt(row,:);
    runsum = maxsum;
    start = 1;
    finish = 1;
    ii = 1;
    for col = 1:size(im_filt,2)
       if im_filt(row,col) > runsum + im_filt(row,col)
           runsum = im_filt(row,col);
           ii = col;
       else
           runsum = runsum + im_filt(row,col);
       end
       if runsum > maxsum
           maxsum = runsum;
           start = ii;
           finish = col;
       end
    end
    
    rowMaxArray(:,row) = [start;finish];
    if row > 1
        prevStart = rowMaxArray(1,row-1);
        prevFinish = rowMaxArray(2,row-1);
        if abs(start-prevStart) < rowThresh && abs(finish-prevFinish) < rowThresh
            currRowStreak = currRowStreak + 1;
        elseif currRowStreak > 1
            lineLen = prevFinish-prevStart;
            rowPos = round(row-1-currRowStreak/2);
            rowLines = [rowLines; currRowStreak lineLen prevStart prevFinish rowPos];
            currRowStreak = 1;
        end
    end
    
    im_filt(row,start:finish) = .5;
end

im_filt(im_filt==1) = 0;
im_filt(im_filt==0.5) = 1;


im_filt(im_filt == -1) = 0;
preIm_filt(preIm_filt == -1) = 0;

newIm_filt = im_filt & preIm_filt;
im_filt = newIm_filt; % jh added
figure;
imshow(im_filt);
hold on;
borderLen = 0.8*size(im_filt,2);
borderHei = 0.8*size(im_filt,1);
borderRows = rowLines(rowLines(:,2) > borderLen,:);
borderCols = colLines(colLines(:,2) > borderHei,:);
% [~,brMaxI] = max(diff(borderRows(:,5)));
% [~,bcMaxI] = max(diff(borderCols(:,5)));
% borderRows = [borderRows(brMaxI,:);borderRows(brMaxI+1,:)];
% borderCols = [borderCols(bcMaxI,:);borderCols(bcMaxI+1,:)];


for ii = 1:size(borderRows,1)
    plot([borderRows(ii,3) borderRows(ii,4)],[borderRows(ii,5) borderRows(ii,5)],'m');
end

for ii = 1:size(borderCols,1)
    plot([borderCols(ii,5) borderCols(ii,5)],[borderCols(ii,3) borderCols(ii,4)],'m');
end

thickThresh = 10;
lenThresh = 40;
for ii = 1:size(colLines,1)
    if colLines(ii,1) > thickThresh && colLines(ii,2) > lenThresh
        plot([colLines(ii,5) colLines(ii,5)],[colLines(ii,3) colLines(ii,4)],'r');
    end
end
for ii = 1:size(rowLines,1)
    if rowLines(ii,1) > thickThresh && rowLines(ii,2) > lenThresh
        plot([rowLines(ii,3) rowLines(ii,4)],[rowLines(ii,5) rowLines(ii,5)],'m');
    end
end
%imshow(newIm_filt);

imwrite(im_filt,'daf_filt_6.png');


%% get rid of borders

