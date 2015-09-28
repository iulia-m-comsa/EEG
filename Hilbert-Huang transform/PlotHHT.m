function PlotHHT(freqtime, freqs, titlestr)
% Plots HHT given the output of ComputeHHT.

    %figure;
    imagesc(freqtime);
    title(titlestr); colorbar; xlabel('Time (samples)'); ylabel('Freq (Hz)');
    set(gca,'YDir','normal');
    set(gca,'YTickLabel',freqs(get(gca,'YTick')));

end

