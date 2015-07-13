%% train
clc; clear; close all;

type = 'rashi';

%there are two dirs, gemaraTrainer and rashiTrainer
dafdirname = [type 'Trainer'];
dafdir = dir(dafdirname);
realFiles = dafdir(not([dafdir.isdir]));

statsTrain(type, dafdirname,realFiles)

%% classify
statsObj = open(['statsTrainedSet' type '.mat']);
capType = [upper(statsObj.type(1)) statsObj.type(2:end)];
mesechtas = dir('gemaraPics');
mesechtas = mesechtas([mesechtas.isdir]);
for ii = 3:length(mesechtas) %3 in order to skip '.' and '..'
    mesechta = mesechtas(ii).name

    dafdirname = ['results/cutout' capType '/' mesechta];
    statdirname = ['../' statsObj.type '/' mesechta];
    dafdir = dir(dafdirname);
    realFiles = dafdir(not([dafdir.isdir]));

    statsClassify(dafdirname,statdirname,realFiles,statsObj);
end