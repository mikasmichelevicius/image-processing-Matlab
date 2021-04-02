
% The task of the program is to detect a common type of image forgery
% known as the copy-move forgery. The forgery detection is performed using
% Circular shift and match method. 


function circMatch()


originalImage = double(rgb2gray(imread('jeep.png')));
disp(size(originalImage));

lenaImg = imread('lena512gray.pgm');

    function S = imCshift(X, k, l)
        [x,y] = size(X);
        shiftedY = zeros(x,y);
        shifted = zeros(x,y);
        for i = 1:x
            for j = 1:y
                 ind = mod(j-l, y);
                 if ind == 0
                     ind = y;
                 end
                shiftedY(i,j) = X(i, ind);
            end
        end
        for j = 1:y
            for i = 1:x
                ind = mod(i-k, x);
                if ind == 0
                    ind = x;
                end
                shifted(i,j) = shiftedY(ind,j);
            end
        end
        S = shifted;
    end

    function d = simThresh(X,S,t)
        [x,y] = size(X);
        D = zeros(x,y);
        for i = 1:x
            for j = 1:y
                D(i,j) = abs(X(i,j) - S(i, j));
            end
        end
        d = D < t;
    end

lenaShifted1 = imCshift(lenaImg, 64, 64);
lenaShifted2 = imCshift(lenaImg, 128, 128);

figure(5);
subplot(1,2,1);
imagesc(lenaShifted1);
colormap('gray');
title('Shift Test: k=64, l=64');
subplot(1,2,2);
imagesc(lenaShifted2);
colormap('gray');
title('Shift Test: k=128, l=128');

figure(1);
imagesc(originalImage);
colormap('gray');
title('Original Image');

[dimX, dimY] = size(originalImage);
A = zeros(dimX, dimY);
SE = strel('diamond',5);

for k = 1:dimX/2
    disp(k);
    for l = 1:dimY/2
        shift = imCshift(originalImage, k, l);
        diff = simThresh(originalImage, shift, 5);
        eroded = imerode(diff, SE);
        dilated = imdilate(eroded,SE);
        A = or(A, dilated);
    end
end

figure(2);
imagesc(A);
colormap('gray');
title('Tampered Regions');

end
