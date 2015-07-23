function [ startPage, endPage ] = getPages( type, mesachta )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    orginPath = makeOrginPath( type );
    path = [orginPath mesachta '/' ];
    pics = dir(path);
    pageNums = zeros(length(pics),1);
    for jj = 3:length(pics)
       pageNums(jj) = str2double(strrep(strrep(pics(jj).name,[mesachta '_'],''),'.png',''));
    end
    pageNums = pageNums(pageNums >0);
    startPage = min(pageNums);
    endPage = max(pageNums);
    

end

