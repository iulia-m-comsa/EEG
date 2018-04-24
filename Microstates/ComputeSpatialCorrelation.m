function spCorr = ComputeSpatialCorrelation(u,v)
% Computes the absolute value of the spatial correlation of two maps.
% u and v are nrChan x 1, both zero-mean.
%
% Author: Iulia M. Comsa, imc31@cam.ac.uk, Oct 2015

    spCorr = abs ( dot(u,v) / dot(norm(u),norm(v)) );

end

