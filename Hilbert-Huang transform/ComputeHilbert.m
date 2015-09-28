function [ampli, phase, freq] = ComputeHilbert(data, samplingRate)
% Hilbert transform on one dimensional data, given its sampling rate.
%
% Iulia M. Comsa, imc31@cam.ac.uk, June 2015

    hilbdata = hilbert(data);
    ampli = abs(hilbdata);
    phase = unwrap(angle(hilbdata));
    freq =  diff(phase) * samplingRate / (2*pi);

end