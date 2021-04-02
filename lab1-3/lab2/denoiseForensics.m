
% The program, given an input image containing periodic noise
% and a filter type, perform noise removal on the image using
% notch filter technique.
% run the program with halftone_evidence.png as input image.
% use 'ideal', 'btw' or 'gaussian' filterType.

function [] = denoiseForensics(inputImage, filterType)
halfEvidence = imread(inputImage);

PQ = paddedsize(size(halfEvidence));

F = fft2(halfEvidence, PQ(1), PQ(2));

F2 = abs(F);

F2 = log(1+F2);


[x, y] = size(F2);

figure(1);
subplot(1,1,1);
imshow(F2,[], 'InitialMagnification', 'fit');

G = F;

for i = 1:3
    for j = 1:y
        H = notch(filterType, PQ(1), PQ(2), 0.05*PQ(1), x*(i/4), j);
        G = G .* H;
    end
end

for i = 1:x
    for j = 1:3
        H = notch(filterType, PQ(1), PQ(2), 0.05*PQ(1), i, y*(j/4));
        G = G .* H;
    end
end

g = real(ifft2(G));
g = g(1:size(halfEvidence,1), 1:size(halfEvidence,2));

figure(2);
subplot(121);
imshow(halfEvidence);

subplot(122);
imshow(g,[]);

end
