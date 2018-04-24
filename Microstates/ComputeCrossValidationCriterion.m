function cvcrit = ComputeCrossValidationCriterion(data,T,indices)

% Computes the cross-validation criterion
% using the formula from Murray et al. 2008
% given:
% data - nrChan x nrSamples, average-referenced, normalized 
% T - classes (template maps), i.e. T(1,:) is the first class
% indices - 1 x nrSamples, classification of data into template maps
%
% Author: Iulia M. Comsa, imc31@cam.ac.uk, Sep 2015

    n = size(data,1);
    q = size(T,1);
    nrSamples = size(data, 2);
    
    
    if(length(indices) ~= nrSamples || size(T,2) ~= n || ~isequal(unique(indices)', 1:q))
        error('Check parameter dimensions.');
    end

    sigma = 0;
    for t = 1:nrSamples
        sigma = sigma + norm(data(:,t))^2 - dot(T(indices(t),:), data(:,t))^2;
    end
    
    sigma = sigma / (nrSamples * (n-1));
    
    cvcrit = sigma * ( (n-1) / (n-1-q) )^2;

end