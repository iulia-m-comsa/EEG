function [freqtime, imfFreqtime, hilbdata_ampli, hilbdata_freq] = Imf2hht(imfs, freqs, samplingRate)
% Computes the HHT given the IMFs (a matrix with rows of imfs, as emd.m outputs),
% including residue (which will not be used).
%
% Returns the total freqtime map and the individual maps for each IMF.
%
% freqs is in Hz, e.g. 1:0.1:40 (must be monotonically increasing)
% freqs are binned as [1 1.1), [1.1 1.2) etc.
% highest freq point is the upper bound and is not counted
% samplingRate is in Hz
%
% Amplitudes are converted to decibels.
%
% Iulia M. Comsa, imc31@cam.ac.uk, June 2015

    % check params
    if any(diff(freqs) <= 0)
        error('Freqspec must be monotonically increasing');
    end

    % init
    nrDims = size(imfs,1)-1;
    nrSamples = size(imfs,2);
    hilbdata_ampli = zeros(nrDims,nrSamples);
    hilbdata_freq = zeros(nrDims,nrSamples-1);

    % do Hilbert transform on each imf
    for c = 1:nrDims 
        [hilbdata_ampli(c,:), ~, hilbdata_freq(c,:)] = ComputeHilbert(imfs(c,:), samplingRate);
    end

    % save a little space
    hilbdata_ampli = single(hilbdata_ampli); 
    hilbdata_freq = single(hilbdata_freq); 
    
    % make time-frequecy map for summing the hilberted imfs
    minfreq = freqs(1); 
    maxfreq = freqs(end);
    nrFreqs = length(freqs);
    freqtime = zeros(nrFreqs-1,nrSamples);
    
    imfFreqtime = cell(1,nrDims);

    for c = 1:nrDims

        % convert hilbdata_freq(c,:) to a vector of map freq (y) indices
            cfreqs = (hilbdata_freq(c,:));
            outofboundsIndices = [find(cfreqs < minfreq) find(cfreqs >= maxfreq)];
            if ~isempty(outofboundsIndices)
                %fprintf(['Warning: ' num2str(length(outofboundsIndices)) ' samples in component ' num2str(c) ' have frequencies outside the frequencies parameter\n']);
            end
            cfreqs(outofboundsIndices) = NaN;
            cfreqs = arrayfun(@(x) smartNaN(find(freqs<=x,1,'last')) , cfreqs);
        % end

        % amplitudes corresponding to frequencies
        cvals = (hilbdata_ampli(c,2:end));
        cvals(isnan(cfreqs)) = 0;
        cfreqs(isnan(cfreqs)) = 1;
        
        % scale amplitudes
        %binsizes = freqs(cfreqs+1) - freqs(cfreqs);
        %cvals = cvals ./ binsizes;

        % compute indices to add amplitures to in the timefreq matrix
        indices = sub2ind(size(freqtime),cfreqs,2:nrSamples);

        % add amplitudes for current imf at one frequency per time point
        freqtime(indices) = freqtime(indices) + cvals;
        
        % store vals
        imfFreqtime{c} = zeros(nrFreqs-1,nrSamples);
        imfFreqtime{c}(indices) = cvals;
        
    end
    
    % convert to db
    freqtime = mag2db(freqtime);
    for c = 1:nrDims
        imfFreqtime{c} = mag2db(imfFreqtime{c});
    end
    
end

function x = smartNaN(x)
% returns x if x is not empty, NaN otherwise
    if isempty(x)
        x = NaN;
    end       
end

