function classDurations = ComputeClassDurations(labels, sample_ind, nrClasses)
% computes the duration, in samples, of each class

    classDurations = zeros(1,nrClasses);

    lastc = 0;
    duration = 0;
    crtDurations = cell(1,nrClasses);
    nrSamples = length(labels);
    
    for i = 1:nrSamples
        if duration == 0
            duration = 1;
            lastc = labels(i);
        elseif sample_ind(i) ~= sample_ind(i-1) + 1
            duration = 0;
        elseif lastc ~= labels(i)
            crtDurations{lastc} = [crtDurations{lastc} duration];
            duration = 1;
            lastc = labels(i);
        else
            duration = duration+1;
        end 
    end
    
    for c = 1:nrClasses
        classDurations(c) = mean(crtDurations{c});
    end
    
    classDurations(isnan(classDurations)) = 0;
end
