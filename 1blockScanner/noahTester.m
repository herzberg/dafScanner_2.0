function [  ] = noahTester( mesechta,daf )

    gemTrain = open(['statsTrainedSetgemara.mat']);
    rashTrain = open(['statsTrainedSetrashi.mat']);
    tosTrain = open(['statsTrainedSettosfos.mat']);
    
    gemIm = imread(['results/cutoutGemara/' mesechta '/' mesechta '_' int2str(daf) '.png']);
    rashIm = imread(['results/cutoutRashi/' mesechta '/' mesechta '_' int2str(daf) '.png']);
    tosIm = imread(['results/cutoutTosfos/' mesechta '/' mesechta '_' int2str(daf) '.png']);
    
    gemStats = fopen(['../gemara/' mesechta '/' int2str(daf) '_statsFixed.txt'],'r');
    rashStats = fopen(['../rashi/' mesechta '/' int2str(daf) '_statsFixed.txt'],'r');
    tosStats = fopen(['../tosfos/' mesechta '/' int2str(daf) '_statsFixed.txt'],'r');
    
    


    

    megaDaf = cat(2,gemIm,rashIm,tosIm);
    offsets = [0,size(gemIm,2),size(gemIm,2)+size(rashIm,2)];
    trains = [gemTrain,rashTrain,tosTrain];
    stats = [gemStats,rashStats,tosStats];
    ims = cat(3,gemIm,rashIm,tosIm);
    hs = [46.7,40,40];
    colors = ['g','r','m'];
    startYs = zeros(1,3);
    for ii = 1:size(ims,3)
       bools = sum(ims(:,:,ii),2) >= size(ims(:,:,ii),2)*0.99;
       [~,~,f] = onestreams(bools);
       startYs(ii) = f(1);
    end
    
    
    figure;imshow(megaDaf);title([mesechta ' ' int2str(daf)]);
    figure;
    hold on;
    for ii = 1:length(trains)
        widths = trains(ii).cWidths;
        starts = trains(ii).cStarts;
        tline = fgets(stats(ii));
        while ischar(tline)
            splut = strsplit(tline,',');
            w = str2double(splut(2));
            s = str2double(splut(3));
            l = str2double(splut(4));
            
            tline = fgets(stats(ii));
            %if ischar(tline) %lets try skipping the last line...
                plot([starts(s),starts(s)+widths(w)],[-1*(hs(ii)*(l-1)+startYs(ii)),-1*(hs(ii)*(l-1)+startYs(ii))],colors(ii));    
            %end
        end        
    end
    hold off;

    %figure;imshow(imread(['gemaraPics/' mesechta '_' int2str(daf) '.png']));
    
end

