function clean_tof_data(inputFile, outputFile)
    % If no input arguments are given, prompt the user to select a file
    if nargin < 1
        [file, path] = uigetfile('*.csv', 'Select the Input TOF CSV File');
        if isequal(file,0)
            error('No file selected.');
        end
        inputFile = fullfile(path, file);
    end
    
    % If no output filename is given, create a default one
    if nargin < 2
        outputFile = strrep(inputFile, '.csv', '_cleaned.csv');
    end

    % Load the CSV file
    raw_data = readmatrix(inputFile);

    % Ensure the data is not empty
    if isempty(raw_data)
        error('Error: Input TOF data file is empty.');
    end

    % Remove the first row and first column
    cleaned_data = raw_data(2:end, 2:end);

    % Save the cleaned data as a new CSV file
    writematrix(cleaned_data, outputFile);

    disp(['Cleaned TOF data saved to: ', outputFile]);
end
