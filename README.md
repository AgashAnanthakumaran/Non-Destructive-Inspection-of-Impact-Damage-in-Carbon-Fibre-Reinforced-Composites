# Non-Destructive-Inspection-of-Impact-Damage-in-Carbon-Fibre-Reinforced-Composites

MATLAB Ultrasonic C-Scan Post-Processing Tool by Agash Ananthakumaran.

This code was created of MATLAB 2024b and as per current limited testing, it was understood the scripts work successfully from version 2023b onwards. It is expected to install the following tooboxes on MATLAB:

1. Image Processing Toolbox
2. Curve Fitting Toolbox
3. Parallel Computing Toolbox (Optional - To run multiple files with front/back scans)

This MATLAB script, contour_plot_FB_1.m, is designed to process ultrasonic Time-of-Flight (TOF) data from Carbon Fibre Reinforced Polymer (CFRP) samples to visualise and quantify internal delamination damage. It supports both .csv and .mat TOF data files, and can produce:

1. 2D damage group plots
2. 3D segmented plots of front and back scans
3. Hybrid 3D merged visualisation combining both scans
4. Freehand-drawn thresholded damage area analysis and damaged area
   

## Code 1: Interim Code to remove unneccessary information from dataset (Optional):

IMPORTANT: In this MATLAB script, the user is expected to use when a unneccesary rows and columns of data is present from raw TOF data files which is required to be omitted as there could be automation errors within the contour_plot_FB_1.m file which will perform the volumetric segmentation. If the user wishes to edit the raw TOF file on their own, please feel free to review the content from Code 2 onwards!

Please note it is only limited to process .csv file formats (common delimited formats)

### Steps and Instructions:
1. In this script, it is expected for the user to review the raw file initially and choose which form of content is expected to be removed. Currently the code has been set to remove the first row (Row 1) and first column (Column A1) from the .csv data file as the USL Software data acquisition at Queen's Building Basement Laboratory at University of Bristol produces raw files in such manner as shown in the figure below for B4 (Front Scan):

![image](https://github.com/user-attachments/assets/1e6f11cb-ffcd-4e0a-8071-2f0087d4cbe5)


2. In line 25, the user can make amendments to the rows and columns to be removed accordingly or create additional input prompts as required.

3. By default, if no output file name is provided, the script creates its default name with the '_cleaned.csv' and saves in the folder.Therefore, if it is expected to make a specific filename, please quote it in line 13 or make amendments after initial output file has been saved.

4. Click 'Run' and the input file is prompted. Once the input file is selected, MATLAB command window displays the output filename and in the case of B4(Front) file used, the .csv file looks like this once saved as shown below:

![image](https://github.com/user-attachments/assets/17a8a130-8000-4e42-a23a-531452770626)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


## Code 2: Main Code to generate 2D Damage Plot, 3D Volumetric Front & Back scans and 3D Hybrid Merged Scan:

IMPORTANT: This MATLAB script is limited to the functionality for .csv (preferred) and .mat file formats only. Before the use of this script, it is expected to know the thickness dimension of the composite sample used, the number of layers within the thickness, file folders of input TOF data files and filenames, expectations of the code and valid TOF data range of specific application and use.

Please note it is expected to know the file path and ensure the current working directory is being processed with the script and input data files.

### Steps and Instructions:

#### 1. INPUTS (Before 'Run'):
1. Line 3: Composite sample Thickness in mm (plateThick)
2. Line 4: Number of Layers in Whole Number  (nLayers)
3. Line 109: Valid TOF data range for front scan
4. Line 110: Valid TOF data range for back scan
5. Line 111: Decide whether to rule out complex numbers to 0 from dataset of front scan
6. Line 112: Decide whether to rule out complex numbers to 0 from dataset of back scan

#### 2. Click 'Run'

→ Once 'Run' is clicked there will be prompts on the command window as follows:
![image](https://github.com/user-attachments/assets/42ac72b4-069b-4799-bc64-06f8aae686c3)

→ In this case, the post-processing activity of sample B4 will be processed. Since B4 is in .csv format, 'csv' will be typed in as follows. Please note it is case-sensitive.
 
→ Once file file is provided in, the following prompts will involve the input dataset files for both front and back scans as follows.  Moreover, there are default front and back scans embedded within the script for trial use and at this stage please input the filenames of front and back scans as follows:
![image](https://github.com/user-attachments/assets/93fb446d-7fa3-4d37-81ca-a710cf50f3ac)

Any errors/discrpencies in the file names will lead to an error messsage being displayed, and in this case, it is expected to re-run the script automatically and input the filenames again.

→ The next stage involves the following options below and it is expected to type in either 'yes' or 'no'. Please note that this is not case sensitive!
1. 2D damage group plots
2. 3D segmented plots of front and back scans
3. Hybrid 3D merged visualisation combining both scans
4. Freehand-drawn thresholded damage area analysis and damaged area
   
![image](https://github.com/user-attachments/assets/ef4e0567-82fe-47d8-85c0-5ee0e412aede)

* If 'NO' was selected to any of above prompts. The expectation is that the MATLABscripts will proceed to the next stage of the plot generation
  
* If 'YES' was selected to 2D damage Group plot for B4. The expected output is:
  
  ![image](https://github.com/user-attachments/assets/91d410f2-93e7-49a4-bd24-a5007e1fe01e)

* If 'YES' was selected to 3D Front and Back scan plots for B4. The expected outputs are:

Front Scan:

  ![image](https://github.com/user-attachments/assets/d2a6c3e2-10a6-4b7a-b664-2c2387ee4975)

Back Scan:

  ![image](https://github.com/user-attachments/assets/beb21241-21cf-4bb9-b190-b97f8068bc61)

* If 'YES' was selected to 3D Hybrid Voumetric Segmentation (Merged) plot for B4. The expected output is:
  
  ![image](https://github.com/user-attachments/assets/3c452da1-3cf0-46e7-87c4-da2cc96f574e)

* If 'YES' was selected to  plot for B4. The expected output on the command window tab is:
1. Enter the sample length in mm (Numerical Value Only). In B4 it is 130
2. Enter the sample length in mm (Numerical Value Only). In B4 it is 130

The threshold bound range of the plate thickness is the range where the range of the damage area is distinguished from the non-damaged region. In B4, consider the layers between 1.5 and 2.0 would help to differentiate the middle region of damage being captured from the volumetric vertical view of a back scan of B4 as follows: 

![image](https://github.com/user-attachments/assets/95ce51a2-4312-40d6-b000-8496eec039f9)

3. Enter the lower threshold bound of damage region ( Numerical Value within the range of plateThick). In this case, 1.5 was selected.
4. Enter the upper threshold bound of damage region ( Numerical Value within the range of plateThick). In this case, 2.0 was selected.

![image](https://github.com/user-attachments/assets/c4c12989-de09-4a8d-8244-7617814ce548)

5. It is expected for the user to define and draw the damaged region of interest to determine the damage area in (mm²). A zoom feature is provided at the bottom left corner of the plot as shown the figure below which helps to zoom in and out of the sample of front view and provide a more accurate drawing of the damage region.

![image](https://github.com/user-attachments/assets/6d4f0d6c-6d82-4e0b-99a6-c6149ca2f3c7)

6. Once the drawing on the image above is completed, the MATLAB automatically processes, and the numerical value of the damaged area is represented on the command window as represented below, along with upper and lower threshold bounds used:

![image](https://github.com/user-attachments/assets/9a31b870-f26b-4071-8af1-da6728f1fce5)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Code 3: Code to determine the damage region and area using Alicona Profile-form technique:

IMPORTANT: This MATLAB script is limited to the functionality for image files only. Before the use of this script, it is expected to know the file path and ensure the current working directory is being processed with the script and input image files.

It is expected to have a reference length within the image to be captured for pixel size, and failure to do so may result in inaccuracies/ failure to process the script.

### Steps and Instructions:

#### 1. INPUTS (Before 'Run'):

1. In Line 6: Please enter the filename of the image as follows. In this case, it is 'B4 Alicona.png' as shown below:

![image](https://github.com/user-attachments/assets/9626ba8a-0219-4291-8eb5-f0ce68ad1ea3)

The reference dimension for scale bar represents the length ratio of the image for pixel length and determination of pixel area. This helps to dinstinguish between damaged area and undamaged area pixels for calculation and the function 'binary scale' detects the scale bar with the grey image and converts to the aspect roatio respectively.

2. If the example from Agash's data at University of Bristol is being used, then please update the 'reference_length_mm' and click 'Run'
   
 or
 
3. Please update thescale bar detection lines 21 and 24 with 'binary scale' and 'props' based on the reference dimension provided within the image.

#### 2. Click 'Run'

→ Once 'Run' is clicked there will be an image prompt to draw the damage region as follows:

![image](https://github.com/user-attachments/assets/3880ab7c-76f0-49d2-b259-d757128fb012)

→ In this case, the post-processing activity of sample B4 will be processed. The user is expected to draw the boundary like this as shown:

![image](https://github.com/user-attachments/assets/05edf712-ec80-4c6f-b199-df6ff3c3f8fb)

 
→ Once the boundary is drawn and provided in, the following step will involve the output the damage boundary chosen as follows:

![image](https://github.com/user-attachments/assets/1c39e779-edc5-449e-bc41-2e881c2e47f4)

Any errors/discrpencies in the images/boundary regions will lead to an error messsage being displayed, and in this case, it is expected to re-run the script automatically and input the filenames of image again.

→ The final stage displays the number of pixels of damage area chosen, the scale factor used and finally the damaged area in (mm²) as shown below as follows:

![image](https://github.com/user-attachments/assets/64cd80b0-eac4-49cd-adb9-0d1f3a588d7b)


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


