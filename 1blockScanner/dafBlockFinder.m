%% fdfd
clc,clear, close all;
im=imread('daf.png');

SE = strel('rectangle',[16 16]);
%SE = strel('rectangle',[30 30]);
im_filt = imclose(1-im,SE);

im_filt(im_filt==1) = -1;
im_filt(im_filt==0) = 1;

colThresh = 5;
rowThresh = 5;

colMaxArray = zeros(2,size(im_filt,2));
rowMaxArray = zeros(2,size(im_filt,1));
colLines = [];
rowLines = [];

currColStreak = 1;
currRowStreak = 1;

preIm_filt = im_filt;
imshow(im_filt);

lineFinder(im_filt,'horiz',10,

%% max subarray
for col = 1:size(im_filt,2)
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
    
    colMaxArray(:,col) = [start;finish];
    if col > 1
        prevStart = colMaxArray(1,col-1);
        prevFinish = colMaxArray(2,col-1);
        if abs(start-prevStart) < colThresh && abs(finish-prevFinish) < colThresh
            currColStreak = currColStreak + 1;
        elseif currColStreak > 1
            lineLen = prevFinish-prevStart;
            colPos = round(col-1-currColStreak/2);
            colLines = [colLines; currColStreak lineLen prevStart prevFinish colPos];
            currColStreak = 1;
        end
    end
        
    im_filt(start:finish,col) = .5;
end

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

% thickThresh = 10;
% lenThresh = 40;
% for ii = 1:size(colLines,1)
%     if colLines(ii,1) > thickThresh && colLines(ii,2) > lenThresh
%         plot([colLines(ii,5) colLines(ii,5)],[colLines(ii,3) colLines(ii,4)],'r');
%     end
% end
% for ii = 1:size(rowLines,1)
%     if rowLines(ii,1) > thickThresh && rowLines(ii,2) > lenThresh
%         plot([rowLines(ii,3) rowLines(ii,4)],[rowLines(ii,5) rowLines(ii,5)],'m');
%     end
% end
%imshow(newIm_filt);

imwrite(im_filt,'daf_filt_6.png');


%% get rid of borders

