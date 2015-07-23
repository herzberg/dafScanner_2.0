clc, clear, close all;

[models,widths,numchars] = trainOcrWidths('../rashi/brachos');

testnums = linspace(0,120,30);
results = zeros(1,length(testnums));

for jj = 1:length(testnums)
    scores = zeros(1,length(models));
    for ii = 1:length(models)
       [l,s] = predict(models{ii},testnums(jj));
       scores(ii) = scores(ii) + s(2);
    end
    
    [~,winner] = max(scores);
    if sum(scores) == 0
        winner = -1;
    end
    results(jj) = winner;

end

%% other stuff
close all;
offset = 30;
for ii = 1:5
   noahTester('pesachim',ii+offset) 
end