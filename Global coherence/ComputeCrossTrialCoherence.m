function [globalCoherence, eigenvectors] = ComputeCrossTrialCoherence(hilbdata)
    
    % Input: data trials as nrFreqs x nrChans x nrTimeSamples x nrTrials
    %
    % Output: global coherence-like measure but across all trials (Andres, Srivas & Iulia's coherence :D) 
    % as nrTimeSamples x nrFreqs and a cell array{nrTimeSamples}{nrFreqs} of eigenvectors
    %
    % Author: Iulia M. Comsa, imc31@cam.ac.uk, Jan 2015
    
    % initialise data dimensions
    nrFreqs = size(hilbdata, 1);
    nrChans = size(hilbdata, 2);
    nrTimeSamples = size(hilbdata, 3);
    nrTrials = size(hilbdata, 4);
    
    % initialise global coherence and eigenvectors (optional, for speed)
    globalCoherence = zeros(nrTimeSamples, nrFreqs);
    eigenvectors = cell(1,nrTimeSamples);
    
    % compute cross trial coherence at every time point
    for t = 1:nrTimeSamples
        
        crossTimeData = permute(squeeze(hilbdata(:,:,t,:)), [3 2 1]);
        [globalCoherence(t,:), eigenvectors{t}] = ComputeGlobalCoherence(crossTimeData, nrTrials);
        
    end

end