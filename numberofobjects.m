function [] = numberofobjects(img)
I=rgb2gray(imread(img));
figure(3),imshow(I);
[rows,cols] = size(I);
histogram = [];
histogram(256) = 0; % Initialize histogram array to 0s
N = rows*cols;
for x = 1 :rows ,   % Making histogram of image I
   for y= 1:cols ,
       pixel = I(x,y);
       histogram(pixel+1)=histogram(pixel+1)+1;
   end
end
for x = 1:256 , % Making Normalized Histogram
    histogram(x) = histogram(x)/N;
end
uT = 0;
for x = 1:256 , % Finding mean value of pixel value, uT
    uT = uT + x*histogram(x);
end
u = [];
w = [];
u(256) = 0;
w(256) = 0;
sum = 0;
sum_prob = 0;
for k = 1:256 , % Finding mean upto k values and cdf of histogram upto k values
    sum = sum + k*histogram(k);
    u(k) = sum;
    sum_prob = sum_prob + histogram(k);
    w(k) = sum_prob;
end
max = 0
Level = 1
for k = 1:255,  % Finding maximum k such that sigmab square is maximum at k
    sigsq = ((uT.*w(k)-u(k)).^2)./(w(k).*(1-w(k)));
    if max < sigsq,
        max = sigsq;
        Level = k;
    end
end
Level = Level/256;
D = im2double(I);   % Converts image to 0s and 1s with pixel threshold = Level
N0 = 0;
N1 = 0;
for x = 1:rows,
    for y = 1:cols,
        if D(x,y) < Level,
            N0 = N0 + 1;
        else
            N1 = N1 + 1;
        end
    end
end
SETL = 0;
SETH = 0;
if N0 > N1, % To make the background as black and foreground as white
    SETL = 0;
    SETH = 1;
else
    SETL = 1;
    SETH = 0;
end
for x = 1:rows,
    for y = 1:cols,
        if D(x,y) > Level,
            D(x,y) = SETH;
        else
            D(x,y) = SETL;
        end
    end
end
D2 = D;
white = 0;
r = 2;
for x = 1+r:rows-r,
    for y = 1+r:cols-r,
        white = 0;
        for x1 = x-r:x+r,
            for y1 = y-r:y+r,
                if D(x,y) == 1,
                    white = 1;
                end
            end
        end
        if white == 1,
            for x1 = x-r:x+r,
                for y1 = y-r:y+r,
                    D2(x1,y1) = 1;
                end
            end
        end
    end
end
figure(1), imshow(D2);
%subplot(1,2,1), imshow(D2);
cc = bwconncomp(D2)
labeled = labelmatrix(cc);
RGB_label = label2rgb(labeled, @copper, 'c', 'shuffle');
figure(2), imshow(RGB_label);
%subplot(1,2,2), imshow(RGB_label)%,'InitialMagnification','fit');
        
    



