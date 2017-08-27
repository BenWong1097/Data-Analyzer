% FLEX_GRAPHER Takes in a plotting function’s name as a string and an 
%   array containing data. It asks which column data should be plotted 
%   and checks for invalid input.
function [] = flex_grapher(fName, data)
    if ~isempty(data)
        close all;
        cols = size(data, 2);
        choice = 1;
        %Make sure there are enough sets of data
        if cols > 0
            choice = -1;
            %Input validation
            while choice == -1
                fprintf('Which data do you want? (1 - %d): ',cols);
                userIn = input('');
                if (userIn >= 1 && userIn <= cols)
                    choice = userIn;
                else
                    e_print('Invalid input! Enter a number (1 - %d)');
                end
            end
        end
        %Plot data
        figure(1);
        clf;
        curCol = data(:,choice);
        curData = curCol';
        feval(fName, curData);
    else
        e_print('No data is loaded at the moment!\n');
    end
end