clc; clear; close all;
rashi = logical(imread('../../1blockScanner/results/cutoutRashi/brachos/brachos_59.png'));
text = rashi_ocr(rashi)