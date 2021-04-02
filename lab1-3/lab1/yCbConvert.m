% % % EXERCISE 1
% Basic Image processing operations are performed in this program.
% Conversions are performed on Lena's image and separated into 
% different color components.

clearvars

I = imread('lena512color.tiff');

redChannel = I(:, :, 1);
greenChannel = I(:, :, 2);
blueChannel = I(:, :, 3);

figure(1);

subplot(2,2,1);
imagesc(I); colormap('gray');
title('Original Image');

subplot(2,2,2);
imagesc(redChannel); colormap('gray');
title('Red Channel');

subplot(2,2,3);
imagesc(greenChannel); colormap('gray');
title('Green Channel');

subplot(2,2,4);
imagesc(blueChannel); colormap('gray');
title('Blue Channel');


scaleFactors = [0.299,0.587,0.114;-0.1687,-0.3313,0.5;0.5,-0.4187,-0.0813];

sizeImg = size(I);

ycbcrImg = reshape(double(I),sizeImg(1)*sizeImg(2),3)*scaleFactors';

ycbcrImg(:,2) = ycbcrImg(:,2)+128;
ycbcrImg(:,3) = ycbcrImg(:,3)+128;

ycbcrImg = reshape(uint8(ycbcrImg), size(I));

y = ycbcrImg(:,:,1);
cb = ycbcrImg(:,:,2);
cr = ycbcrImg(:,:,3);

figure(2);
subplot(2,2,1);
imagesc(ycbcrImg); colormap('gray');
title('YCbCr');

subplot(2,2,2);
imagesc(y); colormap('gray');
title('Component Y');

subplot(2,2,3);
imagesc(cb); colormap('gray');
title('Component Cb');

subplot(2,2,4);
imagesc(cr); colormap('gray');
title('Component Cr');
