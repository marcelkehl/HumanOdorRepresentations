function pp = HumanOdorRep_ranksum(resp_trials, bsl_trial, response_interval, bsl_interval)
% simple ranksum test for responses
%-----------------------------------------------------------------------------------------
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------
    for ibsl = 1:numel(bsl_trial)
        bsl_fr(ibsl)   = sum(bsl_trial{ibsl}>=min(bsl_interval) & ...
            bsl_trial{ibsl}<=max(bsl_interval))/(abs(diff(bsl_interval))/1000);
    end
    
    for iresp = 1:numel(resp_trials)
        resp_fr(iresp) = sum(resp_trials{iresp}>=min(response_interval) &...
            resp_trials{iresp}<=max(response_interval))/(abs(diff(response_interval))/1000);
    end
    pp = ranksum(resp_fr,bsl_fr,'tail','right');
end