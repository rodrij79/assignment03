close all;
clear;
clc;

Rotor = [];
ratios = [];

for k = [2 3 5 6 7 9 10]
Irgb = imread(['impellers/rotor',sprintf('%2.2d',k), '.jpg']);
Ihsv = rgb2hsv(Irgb);
I = Ihsv(:,:,3);
BW = edge(I,'canny',0.3);

SE1 = strel('line',3,0);
SE2 = strel('line',3,90);
BW = imdilate(BW,[SE1 SE2]);
BWfill = imfill(BW,'holes');

[labels,number] = bwlabel(BWfill,8);

    
Istats = regionprops(labels,'basic','Centroid');
[values, index] = sort([Istats.Area],'descend');
[maxVal, maxIndex] = max([Istats.Area]);

x = Istats(maxIndex).BoundingBox(1);
y = Istats(maxIndex).BoundingBox(2);
w = Istats(maxIndex).BoundingBox(3);
h = Istats(maxIndex).BoundingBox(4);

radius = max(w,h)/2;
circleX = x+(w/2);
circleY = y+(h/2);

X = 0:(sqrt(numel(BWfill))-1);

circle = bsxfun(@(circleX, circleY) circleX.^2 + circleY.^2 < radius^2, X-circleX, X' - circleY);

sumInterval = sum(circle);
sumTotalPixels = sum(sumInterval);

airImage = circle - BWfill;

sumInterval = sum(airImage);
sumGapPixels = sum(sumInterval);

ratio = sumGapPixels / sumTotalPixels;

Rotor = [Rotor; k];
ratios = [ratios; ratio];
end


table = table(Rotor, ratios);
disp(table)