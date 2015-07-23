outpath = ['outBlankTest_'];
path= 'asddasfas'
try
    block = imread(path);   
catch
    block = [0];
    %disp([mesachta ' ' newPageNum 'No gemara on daf(?)'])
end
ocrResults = ocr(block,'Language','Hebrew');
recognizedText = ocrResults.Text;
lines = regexp(recognizedText, '[\f\n\r]', 'split');
textToFiles( outpath,lines );