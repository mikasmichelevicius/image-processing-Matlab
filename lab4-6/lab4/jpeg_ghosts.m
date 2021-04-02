
% The task of this program is, given an image, presented as a criminal
% evidence to detect whether the image is spliced (JPEG Ghost detection).
% Can detect image splicing on following images: splicedBeach.jpg,
% splicedBoat.jpg, splicedSoldier.jpg and splicedPlane.jpg.
% argument b is the size of b x b window used to average differences.
% minQ and maxQ are the min and max qualities tested, stepQ is the
% increment in qualities tested. 
% to run program - jpeg_ghosts(filename, 5, 1, 100, 10)


function diffImages = jpeg_ghosts(file, b, minQ, maxQ, stepQ)

file = imread(file);
figure(1);
imshow(file);
title('Original Image')

array_size = 0;
for s = minQ:stepQ:maxQ
    array_size = array_size + 1;
end

[dimx, dimy, ~] = size(file);

missingX = 0;
if mod(dimx,b) > 0
    missingX = b-mod(dimx,b);
end
missingY = 0;
if mod(dimy,b) > 0
    missingY = b-mod(dimy,b);
end
if missingX > 0
    cols = zeros(missingX,dimy,3);
    file = [file;cols];
end
if missingY > 0
    rows = zeros(dimx+missingX,missingY,3);
    file = [file,rows];
end

disp(size(file));

[sizeX, sizeY, ~] = size(file);
diffImages = zeros(sizeX-4, sizeY-4, array_size);
count = 1;
for j = minQ:stepQ:maxQ
        imwrite(file, 'compressed.jpg', 'jpg', 'quality', j);
        compressed = imread('compressed.jpg');
        
        disp("============ Quality "+j);
        
        for x = 1:(sizeX-4)
            for y = 1:(sizeY-4)
                delta1 = 0;
                delta2 = 0;
                delta3 = 0;
                for i = 1:3
                    
                    delta = 0;
                    for k = 0:(b-1)
                        for l = 0:(b-1)
                            delta = delta + (file(x+k,y+l,i) - compressed(x+k, y+l, i))^2;
                        end
                    end
                    delta = delta/(b^2);
                    
                    if i == 1
                        delta1 = delta;
                    end
                    if i ==2
                        delta2 = delta;
                    end
                    if i == 3
                        delta3 = delta;
                    end
                    
                end
                delta = (delta1 + delta2 + delta3)/3;
                diffImages(x,y,count) = delta;
            end
        end
        count = count + 1;
        

end

count = 1;
for i = minQ:stepQ:maxQ
    figure(count+1);
    imagesc(diffImages(:,:,count));
    axis image
    colormap('gray');
    title(['quality=',num2str(i)]);
    count = count + 1;
end

end
