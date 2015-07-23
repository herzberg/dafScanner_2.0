clc, clear, close all;

diary('ocr.log');
diary on;
type = 'gemara';
orginPath = makeOrginPath( type );
types = {'rashi', 'tosfos'};
mesachtas = dir(orginPath);
mesachtas = mesachtas([mesachtas.isdir]);
for k = 3:length(mesachtas) % start at 3 bc of . and ..
    disp('----------------------------------------------');
    mesachta = mesachtas(k).name;
    disp(mesachta)
    
    startPages = zeros(3,1);
    endPages = zeros(3,1);
    [ startPages(1), endPages(1) ] = getPages( 'gemara', mesachta );
    [ startPages(2), endPages(2) ] = getPages( 'gemara', mesachta );
    [ startPages(3), endPages(3) ] = getPages( 'gemara', mesachta );
    startPage = min(startPages);
    endPage = max(endPages);
    disp(['startPage = ' num2str(startPage)]);
    disp(['endPage = ' num2str(endPage)]); 
    
    for page=startPage:endPage
        newPageNum = page - startPage + 3;
        disp(['newPageNum = ' num2str(newPageNum)]);
            
        %gemara commented so noah can run this...
%         orginPath = '../1blockScanner/results/cutoutGemara/'; 
%         path = [orginPath mesachta '/' mesachta  '_'  num2str(page) '.png'];
%         outpath = ['../gemara/' mesachta '/' num2str(newPageNum) '_'];
%         try
%             block = imread(path);   
%         catch
%             block = [0];
%             disp([mesachta ' ' num2str(newPageNum) 'gemara' ' Not on daf(?)']);
% 
%         end
%         ocrResults = ocr(block,'Language','Hebrew');
%         recognizedText = ocrResults.Text;
%         lines = regexp(recognizedText, '[\f\n\r]', 'split');
%         textToFiles( outpath,lines );

        %rashi and tosfos
        readRashiTos(page, newPageNum, mesachta, 'rashi');
        readRashiTos(page, newPageNum, mesachta, 'tosfos');

        
    end
end

dairy off
