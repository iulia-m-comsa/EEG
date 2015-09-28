function [freqtime, imfFreqtime, imfs] = ComputeHHT(data, freqs, samplingRate)
% Do Hilbert-Huang transform on data.
% Returns a freqtime matrix (nrsamples x nrfreqs-1).
% If data is not epoched, also returns the freqtime matrices for the IMFs.
%
% data dimensions are samples x epochs (i.e. dim2 can be 1)
% freqs is in Hz, e.g. 1:0.1:40 (must be monotonically increasing)
% freqs are binned as [1-1.1), [1.1 1.2) etc.
% highest freq point is the upper bound and is not counted
% samplingRate is in Hz
%
% Amplitudes are scaled according to frequency bin size
% and then converted to decibels.
%
% See also Imf2hht, emd
%
% Iulia M. Comsa, imc31@cam.ac.uk, June 2015

    nrEpochs = size(data,2); 
    nrSamples = size(data,1);
    nrFreqs = length(freqs);
    
    freqtime = zeros(nrFreqs-1, nrEpochs*(nrSamples));
    
    for e = 1:nrEpochs
        imfs = emd(data(:,e), 'MAXMODES', 10);
        fprintf('*** Epoch %d/%d\n',e, nrEpochs);
        fprintf('*** %d to %d\n', ((nrSamples)*(e-1)+1), (nrSamples)*e);
        [freqtime(:, ((nrSamples)*(e-1)+1) : (nrSamples)*e), imfFreqtime] = Imf2hht(imfs, freqs, samplingRate);
    end
    
    if nrEpochs ~= 1
        imfFreqtime = 'not available for epoched data';
        imfs = 'not available for epoched data';
    end
    
end
