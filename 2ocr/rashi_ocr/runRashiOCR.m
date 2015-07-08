clc; clear; close all;
rashi = logical(imread('../../1blockScanner/results/cutoutRashi/brachos/brachos_18.png'));
text = rashi_ocr(rashi)