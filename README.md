# Data Analyzer
The Data Analyzer utilizes MATLAB to extract statistics and generate graphs from data set(s). Made with input validation and the DRY principle in mind, the program was made as efficient and user-friendly as possible given my current capabilities.

# Getting Started
## Prerequisites
- [MATLAB](https://www.mathworks.com/products/matlab.html)
## Using the Data Analyzer program
- The files that are required to run the program are: _main.m_, _e_print.m_, and _flex_grapher.m_. In order to start the program, _main.m_ must be run.
	
- The user starts out on the main menu screen. To unlock most of its functionalities, a username and output file name must be set. In order to do this, the user must select options __1__ and __4__. When setting the output filename, the name provided _must not_ contain any special characters, since these would render an invalid filename on most operating systems. An extension _should not_ be provided as the output file will be a text file by default.
- The user must then load a data file by selecting options 2. Here, an extension must be provided in order to ensure that the correct input file is located.
## Functionalities:
- __Clearing Data__: As option __3__ of the main menu, the user may opt to clear all existing data. This will remove the username, input and output filename, and any loaded data from the workspace.
- __Plot histogram__: As option __5__ of the main menu, the user is given a choice to choose which column subset of the loaded data to be plotted into a histogram.
- __Plot histogram fit__: As option __6__ of the main menu, the user can choose which column subset of the loaded data to be plotted as a histogram. This functionality also plots a distribution curve onto the histogram.
- __Plot probability plots__: As option __7__ of the main menu, the user chooses which column subset of the loaded data to be plotted. The data chosen will be compared to the normal distribution. 
- __Regression of y on x__: As option __8__ of the main menu, the user is asked to choose which column subset of the load data is to act as the x and y values. The data is then plotted alongside a line derived from the polyfit function of MATLAB, with the degree of 1.
- __Find probability given x or z__: As option __9__ of the main menu, the user is asked which column subset of the loaded data is to be used. Before determining the p-value, the user is asked if the data being used is normally distributed. The user then has the option to input an x or z value to determine the probability associated with it. All of this input is then printed out along with the resulting probability.
- __Find x or z given probability__: As option __10__ of the main menu, the user is asked to choose a column subset from the loaded data to use. The user is then asked to judge if the data being used is normally distributed. A probability and a choice between finding x or z is then given. These inputs is then printed out with the resulting x or z value.
## External Functions:
- e_print.m: Takes in a string, and prints it in orange text, pausing afterwards. It allows the user to be aware of a warning/error due to generally invalid input.
- flex_grapher.m: Takes in a plotting function’s name as a string and an array containing data. It asks which column data should be plotted and checks for invalid input.

# Authors
- Benjamin Wong

# License
- This project is licensed under the [MIT License](/LICENSE.md)
