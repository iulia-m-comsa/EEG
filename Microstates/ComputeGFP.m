function gfp = ComputeGFP(eegdata)
% Computes Global Field Power for the given EEG data.
% Input must be average-referenced.
% Input: nrChan x nrSamples
% Output: 1 x nrSamples
%
% Author: Iulia M. Comsa, imc31@cam.ac.uk, Sep 2015

    nrChan = size(eegdata,1);
    nrSamples = size(eegdata,2);
    
    gfp = NaN * ones(1,nrSamples);
    
    for t = 1:nrSamples
        gfp(t) = sqrt( sum(eegdata(:,t).^2) / nrChan );
    end

end