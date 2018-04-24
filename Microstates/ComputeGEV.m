function [gev,labels,spCorr,allSpCorr,classGev] = ComputeGEV(data, classes, gfp, smoothing)
% Computes the Global Explained Variance for the given data and segmentation.
% data is nrChan x nrSamples and must be average-referenced.
% classes is a segmentation nrChan x nrClasses.
% gfp is 1 x nrSamples global field power corresponding to data.
% smoothing is the number of samples to take into account when smoothing.
%
% Author: Iulia M. Comsa, imc31@cam.ac.uk, Oct 2015

    nrSamples = size(data,2);
    nrClasses = size(classes,2);
    
    % turn data into normalized column vectors
    data = normc(data);

    [labels, spCorr, allSpCorr] = LabelMicrostates(data,classes,smoothing);
    
    %figure;hist(abs(spCorr),100);
    
    gev = sum((gfp .* abs(spCorr')).^2) / sum(gfp.^2);
    
    classGev = zeros(1,nrClasses);
    for q = 1:nrClasses
        classGev(q) = sum((gfp .* abs(spCorr') .* (labels == q)').^2) / sum(gfp.^2);
    end

end