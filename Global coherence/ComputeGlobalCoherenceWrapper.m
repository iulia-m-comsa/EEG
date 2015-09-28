
% data dimensions (data is nrFreqs x nrChans x nrTimeSamples x nrTrials)
nrFreqs = size(hilbdata, 1);
nrChans = size(hilbdata, 2);
nrTimeSamples = size(hilbdata, 3);
nrTrials = size(hilbdata, 4);

% global coherence parameter (give a number that divides nrTimeSamples!)
globalCoherenceWindowSize = 10;

% initialise global coherence (optional, for speed)
globalCoherence = zeros(nrTimeSamples/globalCoherenceWindowSize, nrFreqs, nrTrials);

% loop through trials
for trial = 1:nrTrials
    trialData = permute(hilbdata(:,:,:,trial),[3 2 1]); % trial data with dimension order changed to nrTimeSamples x nrChans x nrFreqs 
    globalCoherence(:,:,trial) = ComputeGlobalCoherence(trialData, globalCoherenceWindowSize); % call global coherence function
end