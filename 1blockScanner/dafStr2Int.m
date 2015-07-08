function [ dafInt ] = dafStr2Int( dafStr )

side = dafStr(end);
dafNum = str2num(dafStr(1:end-1));

sideBonus = 0;
if isequal(side,'b')
    sideBonus = 1;
end

dafInt = (dafNum-2)*2 + sideBonus;

end

