function [ text ] = rashi_ocr( rashi )
    load rashi_weights.mat
    
    %% segment rashi into chars
    hLines = sum(rashi,2) == size(rashi,2);
    [n,s,f] = onestreams(hLines);
    perc = 0.95;
    
    text = [];
    for ii = 1:length(n)-1
        hLine = rashi(f(ii):s(ii+1),1:size(rashi,2));
        vChars = sum(hLine,1) >= size(hLine,1)*perc;
        [n1,s1,f1] = onestreams(vChars);
        
        lineCharStruct = struct();
        
        for jj = 1:length(n1)-1
           tempCharIm = hLine(1:size(hLine,1),f1(jj):s1(jj+1));
           lineCharStruct(jj).im = tempCharIm;
        end
        lineChars = fliplr(rashi_ocrClassify(lineCharStruct,rashi_weights,classes));
        spaceWidths = fliplr(f1-s1);
        
        %% insert spaces
        try 
            [idw,cw] = kmeans(spaceWidths(2:end-1)',2);
            [~,spaceId] = max(cw);
            nums = 1:length(idw);
            isSpaceNums = nums(idw == spaceId);
            spaces = char(zeros(1,length(nums))+' ');


            ind = [1:length(lineChars) isSpaceNums];
            [~,ind] = sort(ind);
            joinedLineChars = [lineChars spaces];
            joinedLineChars = joinedLineChars(ind);

            if jj == 1
                text = joinedLineChars;
            else
                text = [text char(10) joinedLineChars];
            end
        catch e
            continue;
        end
    end
end

