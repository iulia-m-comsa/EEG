function classCoverage = ComputeClassCoverage(labels,nrClasses)
    % returns the percent of time covered by each class

    classCoverage = zeros(1,nrClasses);
    
    nrSamples = length(labels);
    
    for c = 1:nrClasses
        classCoverage(c) = sum(labels == c);
    end
    classCoverage = classCoverage / nrSamples * 100;
end
