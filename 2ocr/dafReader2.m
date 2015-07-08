clc, clear, close all;
%rashi
orginPath = '../1blockScanner/results/cutoutRashi/'; 

mesachta = 'brachos';
startPage = 18;
endPage = 138;
for page=startPage:endPage
    newPageNum = page - startPage + 3
    outpath = ['../rashi/' mesachta '/' num2str(newPageNum) '_'];

    path = [orginPath mesachta '/' mesachta  '_'  num2str(page) '.png'];
    try
        rashi = logical(imread(path));
        text = rashi_ocr(rashi);
        lines = strsplit(text,'\n');
        lines = lines(2:end);
    catch
        display('No rashi on daf (?)')
        lines = [''];
    end
    textToFiles( outpath,lines )
   
end

%%
clc, clear, close all;
%gemara
orginPath = '../1blockScanner/results/cutoutGemara/'; 


mesachta = 'brachos';
startPage = 18;
endPage = 138;
for page=startPage:endPage
    newPageNum = page - startPage + 3
    outpath = ['../gemara/' mesachta '/' num2str(newPageNum) '_'];

    path = [orginPath mesachta '/' mesachta  '_'  num2str(page) '.png'];
    block = imread(path);
    ocrResults = ocr(block,'Language','Hebrew');
    recognizedText = ocrResults.Text;
    lines = regexp(recognizedText, '[\f\n\r]', 'split');

    textToFiles( outpath,lines )
   
end