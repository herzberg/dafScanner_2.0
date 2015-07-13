clc, clear, close all;

type = 'gemara';
orginPath = ['../1blockScanner/results/cutout' upper(type(1)) type(2:end) '/'];
types = {'rashi', 'tosfos'};
mesachtas = dir(orginPath);
mesachtas = mesachtas([mesachtas.isdir]);
for k = 3:length(mesachtas) % start at 3 bc of . and ..
    disp('----------------------------------------------');
    mesachta = mesachtas(k).name

    path = [orginPath mesachta '/' ];
    pics = dir(path);
    pageNums = zeros(length(pics),1);
    for jj = 3:length(pics)
       pageNums(jj) = str2double(strrep(strrep(pics(jj).name,[mesachta '_'],''),'.png',''));
    end
    pageNums = pageNums(pageNums >0);
    startPage = min(pageNums)
    endPage = max(pageNums)
   
    for page=startPage:endPage
            newPageNum = page - startPage + 3
            
            %gemara
            type = 'gemara';
            orginPath = '../1blockScanner/results/cutoutGemara/'; 
            path = [orginPath mesachta '/' mesachta  '_'  num2str(page) '.png'];
            outpath = ['../gemara/' mesachta '/' num2str(newPageNum) '_'];
            block = imread(path);
            ocrResults = ocr(block,'Language','Hebrew');
            recognizedText = ocrResults.Text;
            lines = regexp(recognizedText, '[\f\n\r]', 'split');
            textToFiles( outpath,lines )
            
            %rashi/tosfos
            for typeI=1:size(types)
                type = types(typeI);
                orginPath = ['../1blockScanner/results/cutout' upper(type(1)) type(2:end) '/'];
            
                outpath = ['../' type '/' mesachta '/' num2str(newPageNum) '_'];

                path = [orginPath mesachta '/' mesachta  '_'  num2str(page) '.png'];
                try
                    rashi = logical(imread(path));
                    text = rashi_ocr(rashi);
                    lines = strsplit(text,'\n');
                    lines = lines(2:end);
                catch
                    display(['No ' type ' on daf (?)'])
                    lines = [''];
                end
                textToFiles( outpath,lines )
            
            end
            outpath = ['../gemara/' mesachta '/' num2str(newPageNum) '_'];

          

        
    end
end
