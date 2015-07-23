function [ models,widths,numchars ] = trainOcrWidths ( trainingDir ) 
    files = dir(trainingDir);
    realFiles = files(not([files.isdir]));
    
    realCell= struct2cell(realFiles);
    statsFiles = realFiles(not(cellfun('isempty',strfind(realCell(1:5:end),'stats'))));
    mydafFiles = realFiles(not(cellfun('isempty',strfind(realCell(1:5:end),'daf.txt'))));
    
    count = 1;
    len = 1000;
    widths = zeros(1,len);
    numchars = zeros(1,len);
    
    for ii = 1:length(mydafFiles)
       mydaf = fopen([trainingDir '/' mydafFiles(ii).name],'r');
       stats = fopen([trainingDir '/' statsFiles(ii).name],'r');
       
       mline = fgets(mydaf);
       sline = fgets(stats);
       while ischar(mline) && ischar(sline)
           ssplit = strsplit(sline,',');
           w = str2double(ssplit(2));
           n = length(mline);
           
           if count > length(widths)
               widths = [widths zeros(1,len)];
               numchars = [numchars zeros(1,len)];
           end
           
           widths(count) = w;
           numchars(count) = n;
           
           count = count + 1;
           mline = fgets(mydaf);
           sline = fgets(stats);
       end
       fclose(mydaf);
       fclose(stats);
       
       
    end
    
    
    
    %get rid of extra zeros
    widths = widths(1:count-1);
    numchars = numchars(1:count-1);
    
    widths1 = widths;
    widths2 = widths;
    widths3 = widths;
    %play with the numbers so that class 1 is bad and class 2 is good
    widths1(widths1 == 3) = 2;
    widths1(widths1 == 1) = 3;
    widths1 = widths1 - 1;
    
    widths2(widths2 == 3) = 1;
    
    widths3(widths3 == 1) = 2;
    widths3 = widths3 - 1;
    
    
    
    model1 = fitcsvm(numchars',widths1','KernelScale','auto','Standardize',true);
    model2 = fitcsvm(numchars',widths2','KernelScale','auto','Standardize',true);
    model3 = fitcsvm(numchars',widths3','KernelScale','auto','Standardize',true);
    
    models = {model1,model2,model3};
end