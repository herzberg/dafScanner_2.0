clc, clear, close all;
ocrTitlesFile = fopen(['ocrTitles.txt'],'w');

path = 'gemtitles/';
files = dir(path);

for k = 3:length(files)
    filenames{k -2} = files(k).name;
end

filenames = natsort(filenames);

for k = 1:length(filenames) % start at 3 bc of . and ..
    file = filenames{k};
    
    mes = regexprep(file, '_[0-9]*\.png', '');
    daf = strrep(file, [mes '_'], '');
    daf = strrep(daf, '.png', '');
    place = [mes ',' daf];
    disp(place)
    
    fullName = [path file];
    block = imread(fullName);   
    ocrResults = ocr(block,'Language','Hebrew');
    recognizedText = ocrResults.Text;
    line = regexprep(recognizedText, '[\f\n\r]', '');
    encoded_str = unicode2native([place ',' line], 'UTF-8');
    fwrite(ocrTitlesFile, encoded_str, 'uint8');
    fprintf(ocrTitlesFile,'\n');
end

fclose(ocrTitlesFile);