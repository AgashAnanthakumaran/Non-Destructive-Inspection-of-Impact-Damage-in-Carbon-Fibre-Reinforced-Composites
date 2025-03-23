clear all;
close all;
clc;

% Read the image
image = imread(['B3 Alicona.png']); % Ensure the file is in the same directory
imshow(image);
title('Draw a Freehand Spline Around the Damaged Area');
h = drawfreehand('Color', 'r', 'LineWidth', 2); % Manually select the damaged region

% Create a mask from the freehand selection
damageMask = createMask(h);

% Compute damaged area in pixels
damage_area_pixels = sum(damageMask(:));

% Convert image to grayscale for scale bar detection
grayImage = rgb2gray(image);

% Detect scale bar (assumes white bar in bottom left)
binaryScale = grayImage > 200; % Identify white regions

% Find scale bar properties
props = regionprops(binaryScale, 'BoundingBox', 'Area');
scale_bar_length_pixels = 0;

for i = 1:length(props)
    bbox = props(i).BoundingBox;
    aspect_ratio = bbox(3) / bbox(4); % Width/Height ratio
    if aspect_ratio > 5 && bbox(2) > size(image, 1) * 0.8 % Ensure it's at the bottom
        scale_bar_length_pixels = bbox(3); % Width of the scale bar
        break;
    end
end

% Known reference length (5.000 mm)
reference_length_mm = 5.000;

% Compute scale factor (mm per pixel)
scale_factor = reference_length_mm / scale_bar_length_pixels;

% Convert damage area to mm²
damage_area_mm2 = damage_area_pixels * (scale_factor ^ 2);

% Display results
disp(['Manually Selected Damage Area (Pixels): ', num2str(damage_area_pixels)]);
disp(['Scale Factor (mm per pixel): ', num2str(scale_factor)]);
disp(['Damage Area (mm²): ', num2str(damage_area_mm2)]);

% Show the selected damaged area
figure;
imshow(image);
hold on;
visboundaries(damageMask, 'Color', 'r', 'LineWidth', 2);
title('Manually Selected Damage Area');
