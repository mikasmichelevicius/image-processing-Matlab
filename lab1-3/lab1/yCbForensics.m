% The program takes a raw image of 4:2:0 format. The task asks
% to find out which video recorder was used to shoot the video
% based on the downsampling methods for each recorder. 
% Suspect A subsampled chroma component is average of 2x2 blocks
% Suspect B subsampled chroma component is average of two leftmost samples of 2x2 block
% Suspect C subsampled chroma component is average of two rightmost samples of 2x2 block
% Suspect D subsampled chroma component is topleft chroma sample of 2x2 block


function [suspectID, nblocks] = yCbForensics(videoframe)
col = 1920;
row = 1080;
row2 = row/2;
col2 = col/2;

fid = fopen(videoframe, 'r');
if fid == -1
  error('Cannot open file: %s', 'kimono1_1920x1080_150_10bit_420.raw');
end
data = fread(fid, row*col+2*row2*col2,'uint16');
y = data(1:row*col);
cb = data(row*col+1:row*col+row2*col2);
cr = data(row*col+row2*col2+1:row*col+2*row2*col2);
y = reshape(y,[row col]);
cb = reshape(cb,[row2 col2]);
cr = reshape(cr,[row2 col2]);

figure(1);

subplot(221);
imagesc(y); colormap('gray');
title(['Component Y (',num2str(col),'x',num2str(row),')']);


subplot(222);
imagesc(cb); colormap('gray');
title(['Component Cb (',num2str(col2),'x',num2str(row2),')']);


subplot(223);
imagesc(cr); colormap('gray');
title(['Component Cr (',num2str(col2),'x',num2str(row2),')']);



rowDist = [2 * ones(1, row2), mod(row, row2)];
colDist = [2 * ones(1, col2), mod(col, col2)];
if rowDist(end) == 0; rowDist(end) = []; end
if colDist(end) == 0; colDist(end) = []; end
blockMat = mat2cell(y, rowDist, colDist);

yA = cellfun(@mean2, blockMat, 'UniformOutput',false);
yA = cellfun(@floor, yA, 'UniformOutput',false);
yA = cell2mat(yA);

yB = cellfun(@mean, blockMat, 'UniformOutput',false);
yB = cellfun(@floor, yB, 'UniformOutput',false);
yB = cellfun(@(x) x(1), yB, 'UniformOutput',false);
yB = cell2mat(yB);

yC = cellfun(@mean, blockMat, 'UniformOutput',false);
yC = cellfun(@floor, yC, 'UniformOutput',false);
yC = cellfun(@(x) x(2), yC, 'UniformOutput',false);
yC = cell2mat(yC);

yD = cellfun(@(x) x(1,1), blockMat, 'UniformOutput',false);
yD = cell2mat(yD);

blockRows = floor(row2/8);
remRows = rem(row2,8);
blockRows = blockRows + 1;
[~, colss] = size(cb);
zerorow = zeros(1,colss);
cb = [cb;repmat(zerorow,4,1)];
yA = [yA;repmat(zerorow,4,1)];
yB = [yB;repmat(zerorow,4,1)];
yC = [yC;repmat(zerorow,4,1)];
yD = [yD;repmat(zerorow,4,1)];
rowDist8 = [8*ones(1, blockRows), rem(row2+remRows, 8)];
blockCols = floor(col2/8);
colDist8 = [8*ones(1,blockCols), rem(col2, 8)];
if rowDist8(end) == 0; rowDist8(end) = []; end
if colDist8(end) == 0; colDist8(end) = []; end
cbBlocks = mat2cell(cb, rowDist8, colDist8);
yAblocks = mat2cell(yA, rowDist8, colDist8);
yBblocks = mat2cell(yB, rowDist8, colDist8);
yCblocks = mat2cell(yC, rowDist8, colDist8);
yDblocks = mat2cell(yD, rowDist8, colDist8);



a = size(cbBlocks,1);
b = size(cbBlocks,2);

errA = 0;
errB = 0;
errC = 0;
errD = 0;

for i = 1:a
    for j = 1:b
        corA = corr2(cell2mat(cbBlocks(i,j)), cell2mat(yAblocks(i,j)))^2;
        corB = corr2(cell2mat(cbBlocks(i,j)), cell2mat(yBblocks(i,j)))^2;
        corC = corr2(cell2mat(cbBlocks(i,j)), cell2mat(yCblocks(i,j)))^2;
        corD = corr2(cell2mat(cbBlocks(i,j)), cell2mat(yDblocks(i,j)))^2;
        [~, argmax] = max([corA, corB, corC, corD]);
        if argmax == 1
            errA = errA + 1;
        elseif argmax == 2
            errB = errB + 1;
        elseif argmax == 3
            errC = errC + 1;
        elseif argmax == 4
            errD = errD + 1;
        end
    end
end

[~, argmax] = max([errA, errB, errC, errD]);
if argmax == 1
    disp(['Suspect with id A is guilty with ',num2str(errA),' highest correlated blocks.']);
    suspectID = 'A';
    nblocks = errA;
elseif argmax == 2
    disp(['Suspect with id B is guilty with ',num2str(errB),' highest correlated blocks.']);
    suspectID = 'B';
    nblocks = errB;
elseif argmax == 3
    disp(['Suspect with id C is guilty with ',num2str(errC),' highest correlated blocks.']);
    suspectID = 'C';
    nblocks = errC;
elseif argmax == 4
    disp(['Suspect with id D is guilty with ',num2str(errD),' highest correlated blocks.']);
    suspectID = 'D';
    nblocks = errD;

ids = ['A','B','C','D'];
countblocks = [errA, errB, errC, errD];
for i = 1:4
    if i ~= argmax
        disp(['Suspect ',ids(i),' - ',num2str(countblocks(i)),' blocks.']);
    end
end
end
