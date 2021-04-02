
% Sensor Pattern Noise (SPN) is used to identify the source camera
% of multiple images provded. accuracy of identification is calculated
% after it is performed.


figure(1);

disp('========= Agfa 504');
reffiles = dir('SKY/Agfa_CD_504_0/*.JPG');
Agfa504ref = zeros(800,800);

for i = 1:length(reffiles)
    curr_name = reffiles(i).name;
    curr_image = double(rgb2gray(imread(['SKY/Agfa_CD_504_0/' curr_name])));
    denoised = wiener2(curr_image, [3 3]);
    spn = curr_image - denoised;
    [x, y] = size(spn);
    midX = ceil(x/2);
    midY = ceil(y/2);
    centralSPN = spn(midX-399:midX+400, midY-399:midY+400);
    Agfa504ref = Agfa504ref + centralSPN;
end

Agfa504ref = Agfa504ref * (1/length(reffiles));
% subplot(2,3,1);
imagesc(Agfa504ref);
colormap('gray');
title('AGFA DC-504');

centeredAgfa504 = Agfa504ref - mean(Agfa504ref);



disp('========= Agfa 830i');
reffiles = dir('SKY/Agfa_DC_830i_0/*.JPG');
Agfa830ref = zeros(800,800);

for i = 1:length(reffiles)
    curr_name = reffiles(i).name;
    curr_image = double(rgb2gray(imread(['SKY/Agfa_DC_830i_0/' curr_name])));
    denoised = wiener2(curr_image, [3 3]);
    spn = curr_image - denoised;
    [x, y] = size(spn);
    midX = ceil(x/2);
    midY = ceil(y/2);
    centralSPN = spn(midX-399:midX+400, midY-399:midY+400);
    Agfa830ref = Agfa830ref + centralSPN;
end

Agfa830ref = Agfa830ref * (1/length(reffiles));
% subplot(2,3,2);
figure(2);
imagesc(Agfa830ref);
colormap('gray');
title('AGFA DC-830i');

centeredAgfa830 = Agfa830ref - mean(Agfa830ref);



disp('========= Agfa 505x');
reffiles = dir('SKY/Agfa_Sensor505-x_0/*.JPG');
Agfa505ref = zeros(800,800);

for i = 1:length(reffiles)
    curr_name = reffiles(i).name;
    curr_image = double(rgb2gray(imread(['SKY/Agfa_Sensor505-x_0/' curr_name])));
    denoised = wiener2(curr_image, [3 3]);
    spn = curr_image - denoised;
    [x, y] = size(spn);
    midX = ceil(x/2);
    midY = ceil(y/2);
    centralSPN = spn(midX-399:midX+400, midY-399:midY+400);
    Agfa505ref = Agfa505ref + centralSPN;
end

Agfa505ref = Agfa505ref * (1/length(reffiles));
% subplot(2,3,3);
figure(3);
imagesc(Agfa505ref);
colormap('gray');
title('AGFA Sensor 505-X');

centeredAgfa505 = Agfa505ref - mean(Agfa505ref);



disp('========= Agfa 530s');
reffiles = dir('SKY/Agfa_Sensor530s_0/*.JPG');
Agfa530ref = zeros(800,800);

for i = 1:length(reffiles)
    curr_name = reffiles(i).name;
    curr_image = double(rgb2gray(imread(['SKY/Agfa_Sensor530s_0/' curr_name])));
    denoised = wiener2(curr_image, [3 3]);
    spn = curr_image - denoised;
    [x, y] = size(spn);
    midX = ceil(x/2);
    midY = ceil(y/2);
    centralSPN = spn(midX-399:midX+400, midY-399:midY+400);
    Agfa530ref = Agfa530ref + centralSPN;
end

Agfa530ref = Agfa530ref * (1/length(reffiles));
% subplot(2,3,4);
figure(4);
imagesc(Agfa530ref);
colormap('gray');
title('AGFA Sensor 530s');

centeredAgfa530 = Agfa530ref - mean(Agfa530ref);



disp('========= Cannon 70');
reffiles = dir('SKY/Canon_Ixus70_0/*.JPG');
canon70ref = zeros(800,800);

for i = 1:length(reffiles)
    curr_name = reffiles(i).name;
    curr_image = double(rgb2gray(imread(['SKY/Canon_Ixus70_0/' curr_name])));
    denoised = wiener2(curr_image, [3 3]);
    spn = curr_image - denoised;
    [x, y] = size(spn);
    midX = ceil(x/2);
    midY = ceil(y/2);
    centralSPN = spn(midX-399:midX+400, midY-399:midY+400);
    canon70ref = canon70ref + centralSPN;
end

canon70ref = canon70ref * (1/length(reffiles));
% subplot(2,3,5);
figure(5);
imagesc(canon70ref);
colormap('gray');
title('Canon IXUS 70');

centeredCanon70 = canon70ref - mean(canon70ref);



disp('========= Cannon 55');
reffiles = dir('SKY/Canon_Ixus_55_0/*.JPG');
canon55ref = zeros(800,800);

for i = 1:length(reffiles)
    curr_name = reffiles(i).name;
    curr_image = double(rgb2gray(imread(['SKY/Canon_Ixus_55_0/' curr_name])));
    denoised = wiener2(curr_image, [3 3]);
    spn = curr_image - denoised;
    [x, y] = size(spn);
    midX = ceil(x/2);
    midY = ceil(y/2);
    centralSPN = spn(midX-399:midX+400, midY-399:midY+400);
    canon55ref = canon55ref + centralSPN;
end

canon55ref = canon55ref * (1/length(reffiles));
% subplot(2,3,6);
figure(6);
imagesc(canon55ref);
colormap('gray');
title('Canon IXUS 55');

centeredCanon55 = canon55ref - mean(canon55ref);


names = ["AGFA DC-504" "AGFA DC-830i" "AGFA Sensor 505-X" "AGFA Sensor 530s" "Canon IXUS 55" "Canon IXUS 70"];

n = 7;
ind504 = 1;
ind803 = 1;
ind505 = 1;
ind530 = 1;
ind70 = 1;
ind55 = 1;
list504 = strings(n);
list830 =strings(n);
list505 = strings(n);
list530 = strings(n);
list70 = strings(n);
list55 = strings(n);

testfiles = dir('TestRand/*.JPG');
for i = 1:length(testfiles)
    corrCoef = ones(1,6);
    test_name = testfiles(i).name;
    test_image = double(rgb2gray(imread(['TestRand/' test_name])));
    denoised = wiener2(test_image, [3 3]);
    spn = test_image - denoised;
    [x, y] = size(spn);
    midX = ceil(x/2);
    midY = ceil(y/2);
    centralSPN = spn(midX-399:midX+400, midY-399:midY+400);
    centeredSPN = centralSPN - mean(centralSPN);
    
    corrCoef(1) = corr2(centeredAgfa504, centeredSPN);
    corrCoef(2) = corr2(centeredAgfa830, centeredSPN);
    corrCoef(3) = corr2(centeredAgfa505, centeredSPN);
    corrCoef(4) = corr2(centeredAgfa530, centeredSPN);
    corrCoef(5) = corr2(centeredCanon70, centeredSPN);
    corrCoef(6) = corr2(centeredCanon55, centeredSPN);
    
    [~, max_ind] = max(corrCoef);
    
    if max_ind == 1
        list504(ind504) = test_name;
        ind504 = ind504+1;
    end
    if max_ind == 2
        list830(ind803) = test_name;
        ind803 = ind803+1;
    end
    if max_ind == 3
        list505(ind505) = test_name;
        ind505 = ind505+1;
    end
    if max_ind == 4
        list530(ind530) = test_name;
        ind530 = ind530+1;
    end
    if max_ind == 5
        list70(ind70) = test_name;
        ind70 = ind70+1;
    end
    if max_ind == 6
        list55(ind55) = test_name;
        ind55 = ind55+1;
    end
    
end
disp(" ");
disp("Test image        Class");
disp("______________________");
for i = 1:length(list504)
    if strlength(list504(i)) > 3
        disp(list504(i)+ "   AGFA DC-504");
    end
end
disp("______________________");
for i = 1:length(list830)
    if strlength(list830(i)) > 3
        disp(list830(i) + "   AGFA DC-830i");
    end
end
disp("______________________");
for i = 1:length(list505)
    if strlength(list505(i)) > 3
        disp(list505(i) + "   AGFA Sensor 505-X");
    end
end
disp("______________________");
for i = 1:length(list530)
    if strlength(list530(i)) > 3
        disp(list530(i) + "   AGFA Sensor 530s");
    end
end
disp("______________________");
for i = 1:length(list70)
    if strlength(list70(i)) > 3
        disp(list70(i) + "   Canon IXUS 70");
    end
end
disp("______________________");
for i = 1:length(list55)
    if strlength(list55(i)) > 3
        disp(list55(i) + "   Canon IXUS 55");
    end
end
