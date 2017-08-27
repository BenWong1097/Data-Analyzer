% MAIN creates a text user interface with which the user
% uses to extract statistics from a data set as well as calculate
% probability of normal data dsitributions. This program is also able to
% draw graphs and outputs statisical information as well as queried
% information into an output file.
% 
% Scripts used in conjunction with MAIN: e_print.m, flex_grapher.m

%Clear everything and Initialize
clc;
clear;
data = [];
userName = '';
outputName = '';
dataFileName = '';
%Initiate Main Menu Loop
while true
    clc;
    %Acts as a placeholder for username
    tempName = 'User';
    if ~strcmp(userName, '');
        tempName = userName;
    end
    %Print out main menu
    fprintf('Enter a number, %s: \n', tempName);
    fprintf('1) Set username\n');
    fprintf('2) Load data file\n');
    fprintf('3) Clear data\n');
    fprintf('4) Set output filename\n');
    fprintf('5) Plot histogram\n');
    fprintf('6) Plot histogram fit\n');
    fprintf('7) Plot probability plots\n');
    fprintf('8) Regression of y on x\n');
    fprintf('9) Find probability given x or z\n');
    fprintf('10) Find x or z given probability\n');
    fprintf('11) EXIT\n');
    
    choice = input('','s');
    if isnan(choice)
        e_print('Invalid choice! Enter a number (1-11)\n');
        continue;
    end
    choice = str2num(choice);
    fprintf('\n');
    if isempty(choice)
        e_print('Invalid choice! Enter a number (1-11)\n');
    else
        switch choice
            case 1%Set username
                userName = input('Enter a username: ','s');
                fprintf('s%ss\n',userName);
                if ~(any(~isspace(userName)))
                    e_print('Username cannot be empty or just whitespace!\n');
                    userName = '';
                    continue;
                end
                fprintf('\n');
            case 2%Load data file
                if strcmp(userName,'')
                    e_print('A username is required before loading any data!');
                    continue;
                end
                if strcmp(outputName,'')
                    e_print('An output file name must be assigned!');
                    continue;
                end
                try
                    changeDataFile = '';
                    if ~strcmp(dataFileName,'')
                        %While the user hasn't entered y,Y,n,N
                        while (~strcmp(changeDataFile, 'y') && ~strcmp(changeDataFile, 'n'))
                            changeDataFile = input('A file is loaded already. Overwrite? (y/n): ', 's');
                        end
                    end
                    if strcmp(changeDataFile, 'y') || strcmp(changeDataFile, '')
                        dataFileName = input('Enter the name of the datafile: ','s');
                        data = load(dataFileName);
                    end
                    dataChoice = -1;
                    numCols = size(data,2);
                    %Input validation - dataChoice
                    while (dataChoice < 1 || dataChoice > numCols)
                        fprintf('Choose the data to generate statistics for (1-%d): ',numCols);
                        try
                            dataChoice = input('');
                        catch
                        end
                        fprintf('\n');
                        if (dataChoice < 1 || dataChoice > numCols)
                            e_print('An integer between (1-%d) must be inputted!',numCols);
                        end
                    end
                    outputID = fopen(outputName,'a');
                    selectedData = data(:,dataChoice);
                    meanData = mean(selectedData);
                    medianData = median(selectedData);
                    modeData = mode(selectedData);
                    countData = numel(selectedData);
                    varData = var(selectedData, countData > 30);
                    stdevData = std(selectedData, countData > 30);
                    minData = min(selectedData);
                    maxData = max(selectedData);
                    %Find maximum stat to format decimals
                    maxNum = max([meanData, medianData, modeData, varData, stdevData, minData, maxData]);
                    maxLength = num2str(length(sprintf('%.2f',maxNum)));
                    %Print output to file and command window
                    dataFormat = ['Mean\t= %0' maxLength '.2f\n'];
                    dataFormat = [dataFormat 'Median\t= %0' maxLength '.2f\n'];
                    dataFormat = [dataFormat 'Mode\t= %0' maxLength '.2f\n'];
                    dataFormat = [dataFormat 'Var\t\t= %0' maxLength '.2f\n'];
                    dataFormat = [dataFormat 'Stdev\t= %0' maxLength '.2f\n'];
                    dataFormat = [dataFormat 'Min\t\t= %0' maxLength '.2f\n'];
                    dataFormat = [dataFormat 'Max\t\t= %0' maxLength '.2f\n'];
                    dataFormat = [dataFormat 'Count\t= %d\n'];
                    dataFormatted = sprintf(dataFormat, meanData, medianData, modeData, varData, stdevData, minData, maxData, countData);
                    if (countData > 30)
                        dataFormatted = sprintf([dataFormatted '* Standard Deviation and Variance calculated as population\n']);
                    else
                        dataFormatted = sprintf([dataFormatted '* Standard Deviation and Variance calculated as sample\n']);
                    end
                    fprintf(dataFormatted);
                    fprintf(outputID, dataFormatted);
                    fclose(outputID);
                    e_print('');
                    pause;
                catch
                    e_print('Datafile was either empty, not found, or in a faulty format!');
                    dataFileName = '';
                end
            case 3%Clear data
                clear;
                data = [];
                userName = '';
                outputName = '';
                dataFileName = '';
                fprintf('Data cleared!\n');
                e_print('');
            case 4%Set output filename
                if strcmp(userName,'')
                    e_print('Custom username must be set!');
                else
                    %Only print error on n>1 loop
                    first = true;
                    while first | isempty(outputName) | regexp(outputName, '[/\?*:|"<>.]')
                        if ~first
                            e_print('Invalid name (contains special characters)\n');
                        end
                        first = false;
                        outputName = input('Enter a name for the output file (.txt): ','s');
                        fprintf('\n');
                    end
                    outputName = [outputName '.txt'];
                    outputID = fopen(outputName, 'a');
                    outputString = sprintf('\n[User]: %s\t[Date]: %s\n',userName, datetime('today'));
                    fprintf(outputString);
                    fprintf(outputID, outputString);
                    fclose(outputID);
                end
            case 5%Plot histogram
                flex_grapher('histogram', data);
            case 6%Plot histfit
                flex_grapher('histfit', data);
            case 7%Plot probplot
                flex_grapher('probplot', data);
            case 8%Plot regression plot
                if ~isempty(data) && size(data,2)>1
                    close all;
                    try
                        numCols = size(data,2);
                        fprintf('Choose the data to represent x (1-%d): ',numCols);
                        xNum = input('');
                        fprintf('\nChoose the data to represent y (1-%d): ',numCols);
                        yNum = input('');
                        fprintf('\n');
                    catch
                        e_print('An invalid input was detected for either x or y!');
                        continue;
                    end
                    %Check if x and y are valid columns
                    if xNum < 1 || yNum <0 || xNum > numCols || yNum > numCols
                        e_print('An integer between (1-%d) must be inputted!',numCols);
                        continue;
                    end
                    figure(1);
                    clf;
                    x = data(:,xNum);
                    y = data(:,yNum);
                    p = polyfit(x,y,1);
                    hold on;
                    plot(x, p(1)*x+p(2));
                    scatter(x, y);
                    hold off;
                else
                    e_print('Not enough data is loaded at the moment!\n');
                end
            case 9%Find probability given x or z
                if isempty(data)
                    e_print('No data loaded!');
                    continue;
                end
                dataChoice = -1;
                normalDist = '';
                
                %Input validation - normalDist
                while ~strcmp(normalDist, 'y') && ~strcmp(normalDist, 'n')
                    normalDist = lower(input('In your judgment, is the data normally distributed? (y\\n): ', 's'));
                end
                %Input validation - dataChoice
                while (dataChoice < 1 || dataChoice > numCols)
                    fprintf('Choose the data (1-%d): ',numCols);
                    try
                        dataChoice = input('');
                    catch
                    end
                    fprintf('\n');
                    if (dataChoice < 1 || dataChoice > numCols)
                        e_print('An integer between (1-%d) must be inputted!',numCols);
                    end
                end
                %Input validation - state (z or x)
                state = '';
                while ~strcmp(state,'z') && ~strcmp(state,'x')
                    state = input('Will you be giving x or z? (x,z): ','s');
                    fprintf('\n');
                    if ~strcmp(state,'z') && ~strcmp(state,'x')
                        e_print('Invalid input!');
                    end
                end
                p = 0;
                if strcmp(state,'z')
                    try
                        x = input('Enter a z value: ');
                        p = normcdf(x);
                    catch
                        e_print('Invalid input was given for z!');
                        continue;
                    end
                elseif strcmp(state,'x')
                    count = numel(data(:,dataChoice));
                    mu = mean(data(:,dataChoice));
                    stdev = std(data(:,dataChoice),count>30);
                    try
                        x = input('Enter an x value: ');
                        z = (x-mu)/stdev;
                        p = normcdf(z);
                    catch
                        e_print('Invalid input was given for x!');
                        continue;
                    end
                %What "else" could state be, Wilson?
                else
                    e_print('Shenanigans have caused an error!');
                    continue;
                end
%               Printing output
                output = sprintf('Data file: %s\nColumn: %d\n', dataFileName, dataChoice);
                output = sprintf([output 'Finding probability given %s:\n\t%s: %.3f\n\tp: %.3f\n'], state, state, x, p);
                output = sprintf([output '\tNormally Distributed: %s\n'], normalDist);
                outputID = fopen(outputName,'a');
                fprintf(outputID, output);
                fclose(outputID);
                fprintf(output);
                e_print('');
            case 10%Find x or z given probability
                if isempty(data)
                    e_print('No data loaded!');
                    continue;
                end
                
                dataChoice = -1;
                normalDist = '';
                %Input validation - dataChoice
                while (dataChoice < 1 || dataChoice > numCols)
                    fprintf('Choose the data (1-%d): ',numCols);
                    try
                        dataChoice = input('');
                    catch
                    end
                    fprintf('\n');
                    if (dataChoice < 1 || dataChoice > numCols)
                        e_print('An integer between (1-%d) must be inputted!',numCols);
                    end
                end
                
                %Input validation - normalDist
                while ~strcmp(normalDist, 'y') && ~strcmp(normalDist, 'n')
                    normalDist = lower(input('In your judgment, is the data normally distributed? (y\\n): ', 's'));
                    if ~strcmp(normalDist, 'y') && ~strcmp(normalDist, 'n')
                        e_print('Enter y or n!');
                    end
                end
                
                p = -1;
                %Input validation - p
                while (p < 0 || p > 1)
                    try
                        p = input('Enter a probability [0,1]: ');
                    catch
                    end
                    if (p<0 || p >1)
                        e_print('Input must be between 0 and 1!');
                        continue;
                    end
                    fprintf('\n');
                    %Input validation - state (x or z)
                    state = '';
                    while ~strcmp(state,'z') && ~strcmp(state,'x')
                        state = input('Finding x or z? (x,z): ','s');
                        fprintf('\n');
                        if ~strcmp(state,'z') && ~strcmp(state,'x')
                            e_print('Invalid input!');
                        end
                    end
                    
                    count = numel(data(:,dataChoice));
                    mu = mean(data(:,dataChoice));
                    stdev = std(data(:,dataChoice),count>30);
                    x = norminv(p, mu, stdev);
                    z = norminv(p, 0, 1);
                    xzOut = 0;
                    %Decide whether to print x or z
                    if strcmp(state,'z')
                        xzOut = z;
                    else
                        xzOut = x;
                    end
%                   Printing output
                    output = sprintf('Data file: %s\nColumn: %d\n', dataFileName,dataChoice);
                    output = sprintf([output 'Finding ' state ', given probability:\n\t' state ': %.3f\n'], xzOut);
                    output = sprintf([output '\tNormally Distributed: %s\n'], normalDist);
                    outputID = fopen(outputName,'a');
                    fprintf(outputID, output);
                    fclose(outputID);
                    fprintf(output);
                    e_print('');
                end
            case 11%Exit
                clc;
                fprintf('Exiting...\n');
                break;
            otherwise
                e_print('Invalid choice! Enter a number (1-11)]');
        end
    end
end