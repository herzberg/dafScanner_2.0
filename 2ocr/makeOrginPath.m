function [ orginPath ] = makeOrginPath( type )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    orginPath = ['../1blockScanner/results/cutout' upper(type(1)) type(2:end) '/'];


end

