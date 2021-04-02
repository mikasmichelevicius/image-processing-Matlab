
% The program takes the Lena's grayscale image and inserts
% a watermark logo using the bitplane technique.

clearvars

lena = imread('lena512gray.pgm');

B0 = bitget(lena, 1)*2^7;
B2 = bitget(lena, 2)*2^7;
B7 = bitget(lena, 7)*2^7;
B8 = bitget(lena, 8)*2^7;

figure(2);
subplot(2,2,1);
imshow(B0,[]);
title('1st bit plane');
subplot(2,2,2);
imshow(B2,[]);
title('2nd bit plane');
subplot(2,2,3);
imshow(B7,[]);
title('7th bit plane');
subplot(2,2,4);
imshow(B8,[]);
title('8th bit plane');


watermark = imread('warwick512gray.pgm');

maxVal = max(max(watermark));
minVal = min(min(watermark));

disp(maxVal);
disp(minVal);
sumVals = double(maxVal)+double(minVal);
threshold = (sumVals)/2;

level = threshold/255;

binarized = imbinarize(watermark, level);

figure(1);
subplot(2,2,1);
imshow(binarized);
title(['Binarized image with threshold value ',num2str(threshold)]);

negative = im2uint8(imcomplement(binarized));
subplot(2,2,2);
imshow(negative);
title('Negative binary logo');


watermarkedImage = lena;
for i = 1:size(lena,1)
    for j = 1:size(lena,2)
        watermarkedImage(i,j) = bitset(lena(i,j), 1, negative(i,j));
    end
end

subplot(2,2,3);
imshow(watermarkedImage);
title('Watermarked Image');

ssimval = ssim(watermarkedImage, lena);

B1 = bitget(watermarkedImage, 1)*2^7;
B1bin = imbinarize(B1, 0.5);

disp(ssimval);

imwrite(watermarkedImage, 'lena_watermarked.jpg');

loaded_lena = imread('lena_watermarked.jpg');

B1compressed = bitget(loaded_lena, 1)*2^7;
B1binarized = imbinarize(B1compressed, 0.5);

subplot(2,2,4);
imshow(B1binarized);
title('Watermark after image compression');
