% example of computing the HHT on an EEGLAB set

setname = '/imaging/sc03/Iulia/Sedation/sets/06-2010-anest 20100224 0939.mff_postclean.set';
channelIndex = 48; % channel index
freqs = 1:1:40;  % frequency bins

% load dataset
eeglabSet = pop_loadset(setname);
mydata = squeeze(eeglabSet.data(channelIndex,:,:));
mydata = mydata(:,1:2);

% do HHT transform
[freqtime, imfFreqtime, imfs] = ComputeHHT(mydata, freqs, eeglabSet.srate);

% plot HHT spectrum
figure; PlotHHT(freqtime, freqs, 'HHT binsize=1');

% if dataset is unepoched, plot IMF spectra
if iscell(imfFreqtime)
    for c = 1:length(imfFreqtime)
        figure;
        subplot(2,1,1);
        PlotHHT(imfFreqtime{c}, freqs, ['IMF #' num2str(c)]);
        subplot(2,1,2);
        plot(imfs(c,:));
    end
end