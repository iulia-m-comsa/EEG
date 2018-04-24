function [complexity, dictionary] = lzw(input)
% Computes the Lempel-Ziv-Welch complexity.
% Input: an array containing a sequence of 0s and 1s.
% Output: the complexity as the number of words in the dictionary computed 
% according to the LZW algorithm, and the dictionary of words.

    if (~isequal(unique(input), [0 1]) && ...
        ~isequal(unique(input), [0]) && ...
        ~isequal(unique(input), [1]))
        error('Input must be an array containing 0s and/or 1s only.');
    end

    dictionary = containers.Map({'0', '1'}, {true, true});
    
    s = 1;
    e = 2;
    subsequence = sprintf('%d',input(s));
    
    while e <= length(input)
        subsequence = sprintf('%s%d', subsequence, input(e));
        if ~dictionary.isKey(subsequence)
            dictionary(subsequence) = true;
            s = e;
            subsequence = sprintf('%d',input(s));
        end
        e = e+1;
    end

    complexity = dictionary.length;
end
