function [classes, labels, gev] = ComputeMicrostatesKmeans(data,k,gfp)
% data is a nrChan x nrSamples matrix
% data must be average-referenced and normalised
% k is the number of classes
% gfp is a 1 x nrSamples gfp corresponding to data
%
% Output: 
% classes: nrChan x nrClasses best classes found
% gev: global explained variance by these classes
%
% Author: Iulia M. Comsa, imc31@cam.ac.uk, Oct 2015

    nrSamples = size(data,2);
    
    % turn data into normalized column vectors
    % data = normc(data);
    
    % pick k maps randomly
    rng('shuffle');
    classes = data(:,randperm(nrSamples,k));
    
    % set end criterion
    epsilon = 0.000000001;
    
    finished = 0;
    gev = [NaN];
    iter = 0;
    
    while (finished ~= 1 && iter < 1000)
        
        iter = iter+1;
        
        % compute spatial correlation between all classes and all samples
        [gev(end+1),labels] = ComputeGEV(data, classes, gfp, 0);
        
        % test and save GEV
        if (abs(gev(end-1) - gev(end)) < epsilon)
            finished = 1;
        else
            % refine each class using assigned samples
            for c = 1:k
                crtSamples = data(:,labels == c);
                crtPCA = pca(crtSamples');
                if(size(crtPCA,2) == 0)
                    classes = NaN;
                    labels = NaN;
                    gev = 0;
                    warning('class training error');
                    return;
                end
                classes(:,c) = crtPCA(:,1);
            end
        end
        
        fprintf('Iteration %d\n',iter);
        
    end
    
    if (iter == 1000)
       warning('Failed to converge in 1000 iterations');
    end
    
    % plot GEV evolution throughout training
%     figure;
%     plot(0:iter,gev);
%     xlabel('Iteration'); ylabel('GEV');
    
    % only save final GEV
    gev = gev(end);
    
end