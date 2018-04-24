function [C, indices, gev, cvcrit, allCs] = ComputeMicrostates(eegdata, kvals)
% EEG data is a nrChan x nrSamples matrix
% data must be average-referenced
% kvals is an array, e.g. [4] or [2:8]
% picks best k by minimizing the cross-validation criterion (Murray et al. 2008)
%
% Author: Iulia M. Comsa, imc31@cam.ac.uk, Sep 2015

    if(length(size(eegdata)) > 2)
        error('Need nrChan x nrSamples (unepoched) data.');
    end
    
    % save gfp for raw data
    gfp = ComputeGFP(eegdata);
 
    % turn data into normalized column vectors
    eegdata = normc(eegdata);
    %eegdata = zscore(eegdata);

    % get templates
    [C, indices, gev, cvcrit, allCs] = pickBest(eegdata, kvals, gfp);
end

% pick best templates and number of templates for minimizing
% cross-validation criterion, using kmeans
function [bestSegmentation, bestIndices, gev, cvcrit, allSegmentations] = pickBest(data,kvals,gfp)
    bestSegmentation = NaN;
    cvcrit = NaN * ones(1,length(kvals));
    gev = NaN * ones(1,length(kvals));
    bestcvcrit = NaN;
    allSegmentations = cell(1,length(kvals));
    
    % test crossvalidation for each k
    for i = 1:length(kvals)
        
        fprintf('k=%d\n',kvals(i));
        
        nrIter = 1;
        crtC = cell(1,nrIter);
        crtindices = cell(1,nrIter);
        crtgev = zeros(1,nrIter);
        
        % do k-means
        parfor j = 1:nrIter
            [crtC{j},crtindices{j},crtgev(j)] = ComputeMicrostatesKmeans(data, kvals(i),gfp);
             % rows are observations
             
             %if isnan(crtC(1,1))
             %    j = j-1;
             %    continue;
             %end
             
             fprintf('*** Trial %d\n',j);
        end
        
        [~,maxgevind] = nanmax(crtgev);
        C = crtC{maxgevind};
        indices = crtindices{maxgevind};
        gev(i) = crtgev(maxgevind);
             
        C = C';
             
        % compute CV criterion 
        cvcrit(i) = ComputeCrossValidationCriterion(data, C, indices);
        
        % store if best so far
        if (isnan(bestcvcrit) || cvcrit(i) < bestcvcrit)
            bestSegmentation = C;
            bestcvcrit = cvcrit(i);
            bestIndices = indices;
        end
        
        allSegmentations{i} = C;
    end
    
    %hax = plotyy(kvals,cvcrit,kvals,gev);
    %xlabel('k values'); 
    %ylabel(hax(1),'CV criterion');
    %ylabel(hax(2),'GEV');
    %saveas(gcf,['GEV_CV_new.png']);
end

