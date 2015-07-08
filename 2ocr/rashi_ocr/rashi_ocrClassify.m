function [ predictions ] = rashi_ocrClassify( ims, rashi_weights, classes )
%RASHI_OCR Classifies Hebrew letters written in Rashi script.
%   RASHI_OCR(ims, rashi_weights, classes) accepts either an image or a
%   struct array containing multiple images in the 'im' field
%   (i.e. ims(1).im = image1; ims.im(2) = image2; ...)
%   rashi_weights contains a matrix containing the weights to be used for
%   the classification and classes contains a list of the classes from
%   which to choose.
%   Both rashi_weights and classes can be loaded from rashi_weights.mat
%   
%   The function returns the prediction from the classes list.

m = 80;
n = 64;
if isstruct(ims)
    X = zeros(length(ims),m*n);
    for i = 1:length(ims)
        im = ims(i).im;
        im = size_im(im,m,n);
        X(i,:) = im(:)';
    end
else
    im = size_im(ims,m,n);
    X = im(:)';
end
predictions = char(classes(predictOneVsAll(rashi_weights, X))');
end

function im = size_im(im,m,n)
    if(size(im,1) < m)
        im = [im; ones(m-size(im,1),size(im,2))];
    else
        im = im(1:m,:);
    end
    if(size(im,2) < n)
        im = [im ones(m,n-size(im,2))];
    else
        im = im(:,1:n);
    end
end
