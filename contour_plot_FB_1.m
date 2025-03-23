function contour_plot_FB_1(plateThick, nLayers)
    %% User Inputs ------------------------------------------------------
    if nargin < 1, plateThick = 2.0; end  %Input Plate Thickness
    if nargin < 2, nLayers = 8; end       %Input Number of ply layers in the plate

    disp(['Plate Thickness: ', num2str(plateThick), ' mm']);
    disp(['Number of Layers: ', num2str(nLayers)]);

    %% Prompt User for File Type -----------------------------------------------
    fileType = input('Enter file type (mat/csv): ', 's');

    % Validate response
    while ~strcmp(fileType, 'mat') && ~strcmp(fileType, 'csv')
        disp('Invalid input. Please enter "mat" or "csv".');
        fileType = input('Enter file type (mat/csv): ', 's');
    end

    %% Choose File Type for Loading Data --------------------------------------
    if strcmp(fileType, 'mat')
        % Prompt User or Use Default File Paths for .MAT Files
        fileF = input('Enter Front .mat file path (or press Enter for default): ', 's');
        if isempty(fileF), fileF = 'MATLAB - EXAMPLE TOF FRONT DATA.mat'; end % Default

        fileB = input('Enter Back .mat file path (or press Enter for default): ', 's');
        if isempty(fileB), fileB = 'MATLAB - EXAMPLE TOF BACK DATA.mat'; end % Default

        % Load .MAT files
        matDataF = load(fileF);
        matDataB = load(fileB);

        fieldNamesF = fieldnames(matDataF);
        fieldNamesB = fieldnames(matDataB);

        dataF = matDataF.(fieldNamesF{1}); 
        dataB = matDataB.(fieldNamesB{1});

    elseif strcmp(fileType, 'csv')
        % Prompt User or Use Default File Paths for .CSV Files
        fileF = input('Enter Front .csv file path (or press Enter for default): ', 's');
        if isempty(fileF), fileF = 'cleaned_TOF_data_B4_FNew1703.csv'; end % Default

        fileB = input('Enter Back .csv file path (or press Enter for default): ', 's');
        if isempty(fileB), fileB = 'cleaned_TOF_data_B4_BNew1703.csv'; end % Default

        % Load .CSV files
        dataF = readmatrix(fileF);
        dataB = readmatrix(fileB);
    end

    % Validate TOF data
    if isempty(dataF) || isempty(dataB)
        error('Error: One or both TOF data files are empty.');
    end

    %% Prompt User for Plot Selection ------------------------------------------
    plot2D = input('Do you want the 2D Damage Group Plot? (yes/no): ', 's');
    plot3D_FB = input('Do you want the 3D Front & Back Damage Group Plots? (yes/no): ', 's');
    plot3D_Hybrid = input('Do you want the 3D Hybrid Plot? (yes/no): ', 's');
    plotnArea = input('Do you want to calculate area of damaged region? (yes/no):','s');

    % Convert to lowercase to handle variations (Yes/yes/YES → yes)
    plot2D = lower(plot2D);
    plot3D_FB = lower(plot3D_FB);
    plot3D_Hybrid = lower(plot3D_Hybrid);
    plotnArea = lower(plotnArea);

    % Normalize TOF Data to Plate Thickness 
    minTOF = min([dataF(:); dataB(:)], [], 'omitnan');
    maxTOF = max([dataF(:); dataB(:)], [], 'omitnan');

    % Normalize the damage groups to match ply thickness
    damLayersF = (dataF - minTOF) / (maxTOF - minTOF) * plateThick;
    damLayersB = (dataB - minTOF) / (maxTOF - minTOF) * plateThick; 
    
    % **Remove undamaged areas using a mask** 
    maskF = ~isnan(dataF);  
    maskB = ~isnan(dataB);  
    damLayersF(~maskF) = NaN;
    damLayersB(~maskB) = NaN;
    
    %% ** Generate 2D Damage Groups Plot with Proper Color Scaling **
    if strcmp(plot2D, 'yes')
        figure;
        imagesc(damLayersF, [0, plateThick]); % **Fix scale from
        colormap(jet(nLayers));
        colorbar;
        xlabel('Columns');
        ylabel('Rows');
        title('2D Damage Groups Plot with Layer Scaling');
        axis equal tight;
    end

    % **Discretize Data into Proper Horizontal Damage Layers** 
    numLayers = 0;  % Number of discrete horizontal layers
    minDataF = min(dataF(:), [], 'omitnan');
    maxDataF = max(dataF(:), [], 'omitnan');
    minDataB = min(dataB(:), [], 'omitnan');
    maxDataB = max(dataB(:), [], 'omitnan');

    % Create layer edges and assign data points
    layerEdgesF = linspace(minDataF, maxDataF, numLayers + 1);
    layerEdgesB = linspace(minDataB, maxDataB, numLayers + 1);

    % Compute midpoints for layers (actual Z-values)
    layerCentersF = (layerEdgesF(1:end-1) + layerEdgesF(2:end)) / 2;
    layerCentersB = (layerEdgesB(1:end-1) + layerEdgesB(2:end)) / 2;

    %% **Extract Data in the Valid Range (change if needed - user)** 
    maskF = (dataF >= 0) & (dataF <= 15);  % Select values within range
    maskB = (dataB >= 0) & (dataB <= 15);  % Select values within range
    %damLayersF(damLayersF == 0) = NaN;
    %damLayersB(damLayersB == 0) = NaN;

    %% Generate Segmented 3D Damage Groups Front Plot (Figure 2) 
    if strcmp(plot3D_FB, 'yes')
        figure;
        hold on;
        [x, y] = meshgrid(1:size(damLayersF, 2), 1:size(damLayersF, 1));
    
        % Extract X, Y, Z values where data is valid
        x = x(maskF);
        y = y(maskF);
        z = damLayersF(maskF); % Assign Z values
    
        if isempty(x)
            error('No data points found for plotting. Check filtering conditions.');
        end
    
        % Scatter plot for better 3D segmentation
        scatter3(x, y, damLayersF(maskF), 2, damLayersF(maskF), 'filled');
        colormap(jet(nLayers));
        colorbar;
        clim([0, plateThick]); % ** Fixes color bar range**
        xlabel('Column');
        ylabel('Row');
        zlabel('Damage Group');
        title('Front-3D Segmented Damage Groups');
        grid on;
        view(3);
        axis tight;
        zlim([0, plateThick]);  % Set Z-axis limits from 0 to total thickness
        hold off;

    %% Generate Segmented 3D Damage Groups Back Plot (Figure 3) 
        figure;
        hold on;
        [a, b] = meshgrid(1:size(damLayersB, 2), 1:size(damLayersB, 1));
    
        % Extract X, Y, Z values where data is valid
        a = a(maskB);
        b = b(maskB);
        c = damLayersB(maskB); % Assign Z values

        if isempty(a)
            error('No data points found for plotting. Check filtering conditions.');
        end
    
        % Scatter plot for better 3D segmentation
        scatter3(a, b, c, 2, c, 'filled');
    
        colormap(jet(nLayers));
        colorbar;
        clim([0, plateThick]);
        xlabel('Column');
        ylabel('Row');
        zlabel('Damage Group');
        title('Back-3D Segmented Damage Groups');
        grid on;
        view(3);
        axis tight;
        zlim([0, plateThick]);  % Set Z-axis limits from 0 to total thickness
        hold off;
    end
    %% **Generate Hybrid-Corrected 3D Segmented Damage Groups Plot**
    if strcmp(plot3D_Hybrid, 'yes')
        %% Normalize TOF Data to Plate Thickness 
        minTOF_F = min(dataF(:), [], 'omitnan'); % Min TOF of Front
        maxTOF_F = max(dataF(:), [], 'omitnan'); % Max TOF of Front
        minTOF_B = min(dataB(:), [], 'omitnan'); % Min TOF of Back
        maxTOF_B = max(dataB(:), [], 'omitnan'); % Max TOF of Back
    
        % Find Midpoint of Both Scans in Z
        midZ_F = (maxTOF_F + minTOF_F) / 2;
        midZ_B = (maxTOF_B + minTOF_B) / 2;
    
        % Compute True Z-Shift
        shift_Z = (midZ_F / 2 + midZ_B / 2) / 2;

        midRow_F = round(size(damLayersF, 1) / 2);
        midCol_F = round(size(damLayersF, 2) / 2);
    
        midRow_B = round(size(damLayersB, 1) / 2);
        midCol_B = round(size(damLayersB, 2) / 2);
    
        % Extracting the true center values
        center_F = [midCol_F, midRow_F, midZ_F];  % Fix for Z midpoint
        center_B = [midCol_B, midRow_B, midZ_B];  % Fix for Z midpoint

        % Compute required shifts
        shift_X = center_F(1) - center_B(1);
        shift_Y = center_F(2) - center_B(2);    
    
        % Shift the back scan to align with the front scan
        X_B_shifted = a + shift_X;
        Y_B_shifted = b + shift_Y;
        Z_B_shifted = c + shift_Z;
    
        %% ** Generate Final 3D Hybrid Plot with Alignment Fixes**
        figure;
        hold on;
        scatter3(x, y, z, 5, z, 'filled'); % **Front Scan**
        scatter3(X_B_shifted, Y_B_shifted, Z_B_shifted, 5, Z_B_shifted, 'filled'); % **Aligned Back Scan**
        colormap(jet(nLayers));
        colorbar;
        clim([0, plateThick]);
        xlabel('Column');
        ylabel('Row');
        zlabel('Damage Group');
        title('Hybrid-3D Segmented Damage Groups (Merged)');
        grid on;
        view(3);
        axis tight;
        zlim([0, plateThick]);    
        hold off;
    end

    %% **Determine Area of Damaged Region and Binary Mask Image Plot**
    if strcmp(plotnArea, 'yes')

    % Ask for Sample Dimensions -----------------------------------------
    sampleLength = input('Enter the sample length in mm (Columns): '); 
    sampleWidth  = input('Enter the sample width in mm (Rows): ');

    % Ask for Upper and Lower Threshold Bound for Damage Area Calculation ------
    lowerThresholdBound = input('Enter the lower threshold bound for defining damage region: ');
    upperThresholdBound = input('Enter the upper threshold bound for defining damage region: ');

    % Define Damaged Regions Using the Thresholds
    damageMask = (damLayersF >= lowerThresholdBound) & (damLayersF <= upperThresholdBound);  

    % Compute Pixel Size for Area Measurement
    numCols = size(dataF, 2); % Number of Columns (X-Axis)
    numRows = size(dataF, 1); % Number of Rows (Y-Axis)

    pixelSizeX = sampleLength / (numCols - 1); % mm per pixel (X-axis)
    pixelSizeY = sampleWidth / (numRows - 1);  % mm per pixel (Y-axis)
    pixelArea = pixelSizeX * pixelSizeY;  % mm² per pixel

    % Display Binary Mask for User to Select Damage Region Using Freehand Tool
    fig = figure;
    imshow(damageMask, 'InitialMagnification', 'fit'); % Display mask
    colormap(gray); % Set grayscale colormap
    title('Draw the damage boundary region for Damaged Area');
    axis on;
    hold on;

    % **Enable Zoom, Pan, and Freehand Drawing**
    zoom on; % Enable zooming
    pan on;  % Enable panning

    % **Create a Zoom Control Slider**
    uicontrol('Style', 'text', 'String', 'Zoom:', 'Position', [10, 40, 50, 20]);
    zoomSlider = uicontrol('Style', 'slider', 'Min', 1, 'Max', 5, 'Value', 1, ...
                           'Position', [60, 40, 150, 20], ...
                           'Callback', @(src, event) zoom(fig, get(src, 'Value')));

    % **Use Freehand Selection for Damage Region**
    h = drawfreehand('Color', 'r', 'LineWidth', 1.5);
    roiMask = createMask(h);  % Convert drawn shape into a binary mask

    % Ensure mask dimensions match the original data size
    roiMask = roiMask(1:numRows, 1:numCols);

    % Compute Damage Area Within the Freehand Selection
    selectedPixels = sum(roiMask(:));  % Count selected pixels
    damageArea = selectedPixels * pixelArea;  % Convert pixel count to mm²

    % Display Results
    disp(['Damage Area (User-Defined Freehand Region, Thresholded): ', num2str(damageArea), ' mm²']);
    disp(['Lower Threshold Bound: ', num2str(lowerThresholdBound)]);
    disp(['Upper Threshold Bound: ', num2str(upperThresholdBound)]);

    % Overlay Selected Region on Binary Mask
    hold on;
    visboundaries(roiMask, 'Color', 'r', 'LineWidth', 1.5);
    hold off;
    end
end