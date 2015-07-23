clc, clear, close all;

%gittin 3,17
%brachos 16,19,22

gemdirname = '../1blockScanner/results/cutoutGemara';

%mesechta = 'brachos';
%dafnums = [3,16,19,18,22,21,4,5,6,7,8,9]; %brachos
%mesechta = 'kesubos';
%dafnums = [3,20,21,23,24,25,28,36,26,31,22,17,4,5,6]; %kesubos
mesechta = 'nedarim';
dafnums = [17,19,20,25,26,28,30,31,60,61,33,40,21,4,5,6,7];
%mesechta = 'shabbos';

for jj = 1:length(dafnums);
    dafnum = dafnums(jj);
    try
        dafOrig = ~imread([gemdirname '/' mesechta '/' mesechta '_' int2str(dafnum) '.png']);
    catch
        disp(['done at daf ' int2str(jj)]);
    end
    daf = imclose(dafOrig,strel('disk',3));


    found = false;
    for ii = 2:2
        gemnun = logical(imread(['nun' int2str(ii) '.png']));
        gemmem = logical(imread(['mem' int2str(ii) '.png']));
        %gemse = bwmorph(gemse,'skeleton');
        %gemse = bwmorph(gemse,'skeleton');
        dafn = imerode(daf,gemnun);
        dafm = imerode(daf,gemmem);
        if  sum(dafm(:)) > 0
            yo = bwconncomp(dafm);
            disp([mesechta ' ' int2str(dafnum) ' - mishna!!! - ' int2str(yo.NumObjects)]);
            
            
            found = true;
            break;
        end
    end
    
    if ~found
        disp([mesechta ' ' int2str(dafnum) ' - no mishna']);
    end
end