function [labels, spCorr, allSpCorr] = LabelMicrostates(data,classes,smoothing)
% Labels the data with the highest spatially correlated class.
% data is nrChan x nrSamples.
% classes is nrChan x nrClasses.
% smoothing is the number of samples to consider on each side of the
% current samples for smoothing.
% 
% Outputs: 
% labels: 1 x nrSamples indices denoting the assigned class for each sample
% spCorr: 1 x nrSamples spatial correlation of sample with assigned class.
% allSpCorr: nrSamples x nrClasses
%
% Author: Iulia M. Comsa, imc31@cam.ac.uk, Oct 2015

    % init
    nrSamples = size(data,2);
    nrClasses = size(classes,2);
    nrChans = size(data,1);
    
    % pre-compute all orthdistances
    orthDist = zeros(nrSamples, nrClasses);
    for t = 1:nrSamples
        for c = 1:nrClasses
            orthDist(t,c) = norm(data(:,t))^2 - dot(classes(:,c),data(:,t))^2;
        end
    end
    
    % do assignment
    allSpCorr = data' * classes; % because norms are all 1
    [~, labels] = max(abs(allSpCorr),[],2);
    
    % same thing:
    [orthMins,labels0] = min(orthDist,[],2);
    if (~isequal(labels0,labels))
        warning('Sp corr and orth dist produces different labels');
    end
    
    % compute e from Pascual's paper (1995)
    e = mean(orthMins);
    
    % smoothing
    if smoothing > 0
          
        b = smoothing; % nr samples to look at on either side of current point
        lambda = 1/(b*2+1); % penalty parameter
        epsilon = 0.000001;
        maxIter = 1000;
        
        newlabels = labels;
        lastcvc = 0;%ComputeCrossValidationCriterion(data,classes,origlabels);
        it = 0;
        while(1)

            classCount = zeros(1,nrClasses);
            newCorr = zeros(1,nrClasses);

            for t = b+1:nrSamples-b % for each sample
                t1 = t-b;
                t2 = t+b;

                % compute count of neighbour classes
                for c = 1:nrClasses
                    classCount(c) = sum(labels(t1:t2) == c);
                end

                % compute spatial correlation including penalty
                for c = 1:nrClasses
                    newCorr(c) = orthDist(t,c) / (2*e);

                    newCorr(c) = newCorr(c) - lambda*classCount(c);
                end

                % pick best class
                [~, newlabels(t)] = min(newCorr);    
            end

            difcnt = sum(labels ~= newlabels);
            labels = newlabels;

            % compute new CVC
            cvc = ComputeCrossValidationCriterion(data,classes',newlabels);

            % test end condition
            it = it + 1;
            if (it > maxIter || abs(cvc-lastcvc) <= epsilon*cvc)
                break;
            else
                lastcvc = cvc;
                fprintf('it %d: %d labels changed.\n',it,difcnt);
            end
        end
    end

    spCorr = allSpCorr( ((labels-1)*size(allSpCorr,1))' + (1:(size(allSpCorr,1))) )';
    
%     % compute max cvc
%     sigma = 0;
%     for t = 1:nrSamples
%         sigma = sigma + norm(data(:,t))^2;
%     end
% 
%     sigma = sigma / (nrSamples * (nrChans-1));
%     
%     cvc0 = sigma * ( (nrChans-1) / (nrChans-1-nrClasses) )^2;
%     R = 1 - cvc/cvc0;
end