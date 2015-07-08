function [] = statsTrain( type, dafdirname, realFiles )
%type = 'gemara', 'rashi' or 'tosfos'




[globStatStructs,globWs,globSs] = getLineStats(dafdirname,realFiles);

if isequal(type,'gemara')
    numWidthCats = 3;
    numStartCats = 2;
else
    numWidthCats = 3;
    numStartCats = 3;
end

[~,cWidths] = kmeans(globWs',numWidthCats,'Replicates',20);
cWidths = sort(cWidths);

%first classify into 4 cats to deal with amud alef and bet. then classify
%classification into 2 cats to find amud alef and bet
[idStarts,cStarts] = kmeans(globSs',numStartCats,'Replicates',20);
cStarts = sort(cStarts);


save(['statsTrainedSet' type '.mat'],'cStarts','cWidths','globStatStructs','type');

end

