
% Main lossy steps of JPEG compression are performed by using
% DCT coefficients of the image and removing coefficients below
% antidiagonal on the whole image or on a block-by-block basis.
% Also the quantization is performed using two Quantization matrices.
% SSIM and MSE values are calculated between the original and compressed
% images, as well as compression ratio for each image.

originalLena = double(imread('lena512gray.pgm'));

lenaDCT = dct2(originalLena);
sizeOriginal = nnz(lenaDCT);

figure(1);
subplot(1,2,1);
imagesc(log(abs(lenaDCT)));
colormap(jet);
title('Lena DCT Matrix');

lenaDCT = rot90(lenaDCT,1);
lenaDCT = tril(lenaDCT);
lenaDCT = rot90(lenaDCT,3);

sizeReduced = nnz(lenaDCT);

subplot(1,2,2);
imagesc(log(abs(lenaDCT)));
colormap(jet);
title('Modified DCT Matrix');
recLena = idct2(lenaDCT);


disp("================");
disp("2D DCT on the entire image");
compRatio = sizeOriginal/sizeReduced;
disp("Compression Ratio: "+compRatio);

figure(2);
subplot(1,2,1);
imagesc(recLena);
colormap('gray');
title('Reconstructed Lena');

[ssimval, ssimmap] = ssim(recLena, originalLena);
mse = immse(recLena, originalLena);

disp("SSIM: "+ssimval);
disp("MSE: "+mse);



lenaBlocks = mat2cell(originalLena, 8*ones(1,size(originalLena,1)/8),8*ones(1,size(originalLena,2)/8));

[x, y] = size(lenaBlocks);
nonZero = 0;
for i = 1:x
    for j = 1:y
        block = dct2(cell2mat(lenaBlocks(i,j)));
        
        block = rot90(block,1);
        block = tril(block);
        
        block = rot90(block,3);
        
        nonZero = nonZero + nnz(block);
        
        lenaBlocks(i,j) = {block};
    end
end

for i = 1:x
    for j = 1:y
        block = idct2(cell2mat(lenaBlocks(i,j)));
        lenaBlocks(i,j) = {block};
    end
end



lenaBlocks = cell2mat(lenaBlocks);
subplot(1,2,2);
imagesc(lenaBlocks);
colormap('gray');
title('Reconstructed Block-by-Block');

disp("================");
disp("2D DCT n a block-by-block basis");
blockCompRatio = sizeOriginal/nonZero;
disp("Block Compression Ratio: "+blockCompRatio);

[ssimval2, ssimmap2] = ssim(lenaBlocks, originalLena);
mse2 = immse(lenaBlocks, originalLena);

disp("SSIM: "+ssimval2);
disp("MSE: "+mse2);



load('qtables.mat');

quant50Blocks = mat2cell(originalLena, 8*ones(1,size(originalLena,1)/8),8*ones(1,size(originalLena,2)/8));
quantNum = 0;
for i = 1:x
    for j = 1:y
        block = dct2(cell2mat(quant50Blocks(i,j)));
        block = round(block);
        block = floor(block ./ Q50);
        quantNum = quantNum + nnz(block);
        quant50Blocks(i,j) = {block};
    end
end

for i = 1:x
    for j = 1:y
        block = idct2(cell2mat(quant50Blocks(i,j)));
        quant50Blocks(i,j) = {block};
    end
end

quantReconstructed = cell2mat(quant50Blocks);
figure(5);
subplot(1,2,1);
imagesc(quantReconstructed);
colormap('gray');
title('Reconstructed Q50');

disp("================");
disp("Quantized with Q50");
blockCompRatio = sizeOriginal/quantNum;
disp("Block Compression Ratio: "+blockCompRatio);

[ssimval3, ~] = ssim(quantReconstructed, originalLena);
mse3 = immse(quantReconstructed, originalLena);

disp("SSIM: "+ssimval3);
disp("MSE: "+mse3);



quant90Blocks = mat2cell(originalLena, 8*ones(1,size(originalLena,1)/8),8*ones(1,size(originalLena,2)/8));
quantNum = 0;
for i = 1:x
    for j = 1:y
        block = dct2(cell2mat(quant90Blocks(i,j)));
        block = round(block);
        block = floor(block ./ Q90);
        quantNum = quantNum + nnz(block);
        quant90Blocks(i,j) = {block};
    end
end

for i = 1:x
    for j = 1:y
        block = idct2(cell2mat(quant90Blocks(i,j)));
        quant90Blocks(i,j) = {block};
    end
end

quant90Reconstructed = cell2mat(quant90Blocks);
subplot(1,2,2);
imagesc(quant90Reconstructed);
colormap('gray');
title('Reconstructed Q90');

disp("================");
disp("Quantized with Q90");
blockCompRatio = sizeOriginal/quantNum;
disp("Block Compression Ratio: "+blockCompRatio);

[ssimval3, ssimmap3] = ssim(quant90Reconstructed, originalLena);
mse3 = immse(quant90Reconstructed, originalLena);

disp("SSIM: "+ssimval3);
disp("MSE: "+mse3);



