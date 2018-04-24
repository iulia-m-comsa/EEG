function classTransitions = ComputeClassTransitions(labels, sample_ind, nrClasses)    
% UNTESTED
% compute transition count for each class to each class

    classTransitions = zeros(nrClasses,nrClasses);
    for i = 2:nrSamples
        if (labels(s,i) ~= labels(s,i-1) && sample_ind(i) == sample_ind(i-1) + 1)
            classTransitions(labels(i-1),labels(i)) = classTransitions_awake(labels(i-1),labels(i)) + 1;
        end
    end
end