# Non-Destructive-Inspection-of-Impact-Damage-in-Carbon-Fibre-Reinforced-Composites

MATLAB Ultrasonic C-Scan Post-Processing Tool by Agash Ananthakumaran

This MATLAB script, contour_plot_FB_1.m, is designed to process ultrasonic Time-of-Flight (TOF) data from Carbon Fibre Reinforced Polymer (CFRP) samples to visualise and quantify internal delamination damage. It supports both .csv and .mat TOF data files, and can produce:

1. 2D damage group plots

2. 3D segmented plots of front and back scans
   
4. Hybrid 3D merged visualisation combining both scans
   
6. Freehand-drawn thresholded damage area analysis using a binary mask
   

## Code 1: Interim Code to remove unneccessary information from dataset (Optional):

IMPORTANT: In this MATLAB script, the user is expected to use when a unneccesary rows and columns of data is present from raw TOF data files which is required to be omitted as there could be automation errors within the contour_plot_FB_1.m file which will perform the volumetric segmentation. If the user wishes to edit the raw TOF file on their own, please feel free to review the content from Code 2 onwards!

Please note it is only limited to process .csv file formats (common delimited formats)

### Steps and Instructions:
1. In this script, it is expected for the user to review the raw file initially and choose which form of content is expected to be removed. Currently the code has been set to remove the first row (Row 1) and first column (Column A1) from the .csv data file as the USL Software data acquisition at Queen's Building Basement Laboratory at University of Bristol produces raw files in such manner as shown in the figure below for B4 (Front Scan):

![image](https://github.com/user-attachments/assets/1e6f11cb-ffcd-4e0a-8071-2f0087d4cbe5)


2. In line 25, the user can make amendments to the rows and columns to be removed accordingly or create additional input prompts as required.

3. By default, if no output file name is provided, the script creates its default name with the '_cleaned.csv' and saves in the folder.Therefore, if it is expected to make a specific filename, please quote it in line 13 or make amendments after initial output file has been saved.

4. Click 'Run' and the input file is prompted. Once the input file is selected, MATLAB command window displays the output filename and in the case of B4(Front) file used, the .csv file looks like this once saved as shown below:


