function [ success ] = readRashiTos(page, newPageNum, mesachta, type )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

success = 1;
orginPath = ['../1blockScanner/results/cutout' upper(type(1)) type(2:end) '/'];

outpath = ['../' type '/' mesachta '/' num2str(newPageNum) '_'];

path = [orginPath mesachta '/' mesachta  '_'  num2str(page) '.png'];

try
    pic = imread(path);
    hasPic = true;
catch
    disp([mesachta ' ' num2str(newPageNum) type ' Not on daf(?)']);
    hasPic = false;
end

if hasPic
    try

        rashi = logical(pic);
        text = rashi_ocr(rashi);
        lines = strsplit(text,'\n');
        lines = lines(2:end);
    catch
        disp([mesachta ' ' num2str(newPageNum) type ' failure in readRashiTos'])
        lines = [''];
        success = 0;
    end
else
    lines = [''];
end
textToFiles( outpath,lines )

end

