%% train
clc; clear; close all;

type = 'tosfos';

%there are two dirs, gemaraTrainer and rashiTrainer
dafdirname = [type 'Trainer'];
dafdir = dir(dafdirname);
realFiles = dafdir(not([dafdir.isdir]));

statsTrain(type, dafdirname,realFiles)

%% classify
statsObj = open(['statsTrainedSet' type '.mat']);

mesechta = 'chullin';
capType = [upper(statsObj.type(1)) statsObj.type(2:end)];
dafdirname = ['results/cutout' capType '/' mesechta];
statdirname = ['../' statsObj.type '/' mesechta];
dafdir = dir(dafdirname);
realFiles = dafdir(not([dafdir.isdir]));

statsClassify(dafdirname,statdirname,realFiles,statsObj);