
% The program takes an input image and a reference image
% (color_cast.png, hist_ref.png) and performs an enhancement
% on the image based on histogram matching technique.


function [enhancedImage] = myHistMatch(inputImage, refImage)

inputImg = imread(inputImage);

histRef = imread(refImage);
figure(1);
subplot(1,2,1);
imshow(histRef);
title('Reference Image');


h = imhist(histRef);
normH = h/sum(h);
subplot(1,2,2);
bar(normH);
title('Normalized Histogram');

redCh = inputImg(:,:,1);
greenCh = inputImg(:,:,2);
blueCh = inputImg(:,:,3);

redH = imhist(redCh);
greenH = imhist(greenCh);
blueH = imhist(blueCh);
normRed = redH/sum(redH);
normGreen = greenH/sum(greenH);
normBlue = blueH/sum(blueH);

figure(2);

subplot(2,3,1);
bar(normRed);
title('before matching R channel.');

subplot(2,3,2);
bar(normGreen);
title('before matching G channel.');

subplot(2,3,3);
bar(normBlue);
title('before matching B channel.');

cumulativeRef = cumsum(normH);
% disp(size(cumulativeRef));

cumulativeRed = cumsum(normRed);
cumulativeGreen = cumsum(normGreen);
cumulativeBlue = cumsum(normBlue);

Mred = zeros(256,1,'uint8');
Mgreen = zeros(256,1,'uint8');
Mblue = zeros(256,1,'uint8');

for i = 1:256
    [~, indR] = min(abs(cumulativeRed(i) - cumulativeRef));
    [~, indG] = min(abs(cumulativeGreen(i) - cumulativeRef));
    [~, indB] = min(abs(cumulativeBlue(i) - cumulativeRef));
    Mred(i) = indR - 1;
    Mgreen(i) = indG - 1;
    Mblue(i) = indB - 1;
end

matchedRed = Mred(double(redCh)+1);
matchedGreen = Mgreen(double(greenCh)+1);
matchedBlue = Mblue(double(blueCh)+1);

redHM = imhist(matchedRed);
greenHM = imhist(matchedGreen);
blueHM = imhist(matchedBlue);
normRedM = redHM/sum(redHM);
normGreenM = greenHM/sum(greenHM);
normBlueM = blueHM/sum(blueHM);

subplot(2,3,4);
bar(normRedM);
title('after matching R channel.');

subplot(2,3,5);
bar(normGreenM);
title('after matching G channel.');

subplot(2,3,6);
bar(normBlueM);
title('after matching B channel.');

enhancedImage = cat(3, matchedRed, matchedGreen, matchedBlue);

figure(3);
subplot(2,2,1);
imshow(inputImg);
title('Input Image');

subplot(2,2,2);
imshow(enhancedImage);
title('Enhanced Image');


end
