function [fr, sd, count]= HumanOdorRep_firing_rate(trial, from, to)
%% function [fr sd count] = HumanOdorRep_firing_rate(trial, from, to)
% compute the mean (sd: standard deviation) firing rate (fr) in Hz for a cell array with spike-times 
% trial{1} = [-241 -290 390 ...], trial{2} = [-241 111 129...]
% from and to are times in ms denoting a period during which firing rate should be returned 
% e.g. baseline-firing from = -500 to 0 (ms)
%
%-----------------------------------------------------------------------------------------%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

    duration = abs(to - from) / 1000; % convert to seconds
    ntrials  = length(trial);
    count = nan(1, ntrials);
    for t = 1:ntrials
        count(t) = sum(trial{t} > from & trial{t} < to);
    end
    sd = std(count./duration);
    fr = sum(count)/ duration / ntrials;
end
