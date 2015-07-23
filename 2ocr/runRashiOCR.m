clc; clear; close all;
rashi = logical(imread('../1blockScanner/results/cutoutRashi/pesachim/pesachim_35.png'));
text = rashi_ocr(rashi)