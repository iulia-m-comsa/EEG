
function [globalCoherence, firstEigenvectors] = ComputeGlobalCoherence(data, windowSize)
% Computes global coherence (as described in Observed Brain Dynamics, Mitra & Bokil 2007)
%
% Input:
% data is a 3D matrix:  nrTimeSamples x nrChans x nrFreqs
% windowSize is the number of samples to compute globalCoherence from (try
% to give a number that nrTimeSamples is divisible by - otherwise several
% time samples will be skipped at the end)
%
% Output:
% globalCoherence is a 2D matrix: nrWindows x nrFreqs
% (where nrWindows is the number of windows of the specified size fitting
% into the total number of time samples - leftovers will be skipped)
%
% Author: Iulia M. Comsa, imc31@cam.ac.uk, Nov 2014
    
    
    % data dimensions
    nrSamples = size(data, 1);
    nrChans = size(data, 2);
    nrFreqs = size(data, 3);
    
    % compute SVD for windows
    nrWindows = length(1:windowSize:(nrSamples + 1 - windowSize));
    eigenvectors = zeros(nrChans, nrChans, nrWindows, nrFreqs); 
    eigenvals = cell(nrWindows, nrFreqs);

    % The Math:
    % [u,s,v] = svd(x)
    % x*v == u*s
    %
    % in x, columns are chans and rows are time frames
    % in v, columns are eigenvectors of CX (I think - see refs)
    %
    % s is diagonal and contains singular values (square them to actually get CX eigenvalues)
    % sum of squared abs eigenvectors should be 1 (it is indeed)
    % i.e. sum(abs(windowedEigenvectors(:,1,18,94)).^2) == 1 (as per Cimenser et al. 2011)
   
    for f = 1:nrFreqs
        w = 1;
        for indexWindow = 1:nrWindows         
            crtX = data(w : w+windowSize-1, :, f);            
            [~,s,v] = svd(crtX); 
            eigenvals{indexWindow,f} = diag(s).^2;
            eigenvectors(:,:,indexWindow,f) = abs(v).^2;
            
            w = w + windowSize;
        end
    end

    % compute global coherence on windows
    globalCoherence = zeros(nrWindows, nrFreqs);
    firstEigenvectors = cell(nrWindows, nrFreqs);
    for f = 1:nrFreqs
        for t = 1:nrWindows
            if isnan(eigenvals{t,f})
                globalCoherence(t,f) = NaN;
                firstEigenvectors{t,f} = NaN;
            else
                globalCoherence(t,f) = max(eigenvals{t,f}) / sum(eigenvals{t,f});
                firstEigenvectors{t,f} = eigenvectors(:,1,t,f);
            end
        end
    end
    
end
