
% Watermark is insreted into the Lena's grayscale image
% using its DCT coefficients.

clearvars

lena = imread('lena512gray.pgm');

% SET THE N PARAMETER
n = 1500;

w = randn(n,1);

w = (w - mean(w)) / std(w);

lenaDCT = dct2(lena);

figure(1);
subplot(121);
imshow(lena);
title('Original Lena');

subplot(122);
imshow(lenaDCT);
title('DCT coefficients matrix');


[~, sortIndex] = sort(abs(lenaDCT(:)), 'desc');
[row, col] = ind2sub(size(lenaDCT), sortIndex(1:1+n));

h = zeros(n,1);
for i = 2:n+1
    h(i-1) = lenaDCT(row(i), col(i));
end

hCoef = h .* (1 + 0.1*w);

for i = 2:n+1
    lenaDCT(row(i),col(i)) = hCoef(i-1);
end

inverseLena = uint8(idct2(lenaDCT));

figure(2);
imshow(inverseLena);

ssimval = ssim(inverseLena, lena);
disp(ssimval);


