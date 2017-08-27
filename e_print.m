% E_PRINT Takes in a string, and prints it in orange text, pausing
%   afterwards. It allows the user to be aware of a warning/error due
%   to generally invalid input
function s = e_print(sin)
    s = ['[' 8 sin ']' 8];
    %Print the error
    fprintf(s);
    %Print pause message
    fprintf(['[' 8 '\nPress any key to continue...\n' ']' 8]);
    pause;
end