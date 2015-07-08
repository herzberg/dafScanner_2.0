clc, clear, close all;
daf = imread('daf.png');
block = imread('tosBlock.png');
ocrResults = ocr(block,'Language','Hebrew');
recognizedText = ocrResults.Text;
lines = regexp(recognizedText, '[\f\n\r]', 'split');
text = '';
wordsPerLine = '';
charsPerWord = '';
dafTextFile = fopen('daf.txt','w');
dafNumWordsFile = fopen('dafNumWords.txt','w');
dafNumChars = fopen('dafNumChars.txt','w');
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
        disp('continuing');
        continue;
    end
    
    if ii == 1
        fprintf(dafTextFile,lines{ii});
        fprintf(dafNumWordsFile,num2str(size(words,2)));
        fprintf(dafNumChars,charsOnLine);
    else
        fprintf(dafTextFile,['\n' lines{ii}]);
        fprintf(dafNumWordsFile,['\n' num2str(size(words,2))]);
        fprintf(dafNumChars,['\n' charsOnLine]);
        %text = [text '\n' lines{ii}];
        %wordsPerLine = [wordsPerLine '\n' num2str(size(words,2))];
        %charsPerWord = [charsPerWord '\n' charsOnLine];
    end
    %disp(lines{ii});
    %disp(['Line ' num2str(ii) ' NumWords ' num2str(size(words,2))]);
end
fclose(dafTextFile);
fclose(dafNumWordsFile);
fclose(dafNumChars);