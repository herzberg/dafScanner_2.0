function [  ] = textToFiles( outpath,lines )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes 
    dafTextFile = fopen([outpath 'daf.txt'],'w');
    dafNumWordsFile = fopen([outpath 'dafNumWords.txt'],'w');
    dafNumChars = fopen([outpath 'dafNumChars.txt'],'w');
    
    blankLineCount = 0;
    for ii = 1:size(lines,2)
        words = regexp(lines{ii},' ','split');
        charSum = 0;
        for jj = 1:size(words,2)
            word = words{jj};
            numChars = size(word,2);
            charSum = charSum + numChars;
            if jj == 1
               charsOnLine = num2str(numChars);
            else
                charsOnLine = [charsOnLine ',' num2str(numChars)];
            end
        end
        %to check if line is valid, make sure there are chars
        
        if charSum == 0
            blankLineCount = blankLineCount +1;
            continue;
        end

        if ii == 1
            encoded_str = unicode2native(lines{ii}, 'UTF-8');
            fwrite(dafTextFile, encoded_str, 'uint8');
            %fprintf(dafTextFile,lines{ii});
            fprintf(dafNumWordsFile,num2str(size(words,2)));
            fprintf(dafNumChars,charsOnLine);
        else
            encoded_str = unicode2native([10 lines{ii}], 'UTF-8');
            fwrite(dafTextFile, encoded_str, 'uint8');
            %fprintf(dafTextFile,['\n' lines{ii}]);
            fprintf(dafNumWordsFile,['\n' num2str(size(words,2))]);
            fprintf(dafNumChars,['\n' charsOnLine]);
            %text = [text '\n' lines{ii}];
            %wordsPerLine = [wordsPerLine '\n' num2str(size(words,2))];
            %charsPerWord = [charsPerWord '\n' charsOnLine];
        end
        %disp(lines{ii});
        %disp(['Line ' num2str(ii) ' NumWords ' num2str(size(words,2))]);
    end
    
    if(blankLineCount)
       %blankLineCount
    end
    fclose(dafTextFile);
    fclose(dafNumWordsFile);
    fclose(dafNumChars);

end

