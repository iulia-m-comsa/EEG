function complexity_normalised = lzwNormalised(input, nr_shuffles)
% Returns the Lempel-Ziv-Welch complexity of the given input, normalised by
% the mean complexity of the shuffled input sequence.
% Input: input is an array containing 0s and 1s only.
%        nr_shuffles is an integer > 0 indicating the number of shuffles to
%        be performed.
% Output: normalised LZW complexity as a float.

    if nr_shuffles < 0
        error('nr_shuffles must be greater or equal to 0.');
    end
     
    complexity_orig = lzw(input);
    
    if nr_shuffles > 0
        rng('default');
        complexities_shuffled = zeros(1, nr_shuffles);
        len = length(input);
        parfor i = 1:nr_shuffles
            input_cpy = input;
            input_shuffled = input_cpy(randperm(len));
            complexities_shuffled(i) = lzw(input_shuffled);
        end
        complexity_normalised = complexity_orig / mean(complexities_shuffled);
    else
        complexity_normalised = complexity_orig;
    end
end
