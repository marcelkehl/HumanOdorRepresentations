%-----------------------------------------------------------------------------------------
% Plot odor decoding performance per recording session
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   2e
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% load data
data_path    = fullfile(fileparts(fileparts(pwd)), 'Data');
addpath(fullfile(fileparts(pwd), 'Helper')) % add path to helper tools 
load(fullfile(data_path, 'Fig-2-e-decoding-per-session.mat'))
region_names = {'PC','Am','EC','Hp','PHC'};
plot_colors  = [[232,152,138]; [130,213,151]; [202,157,219];...
                [126,199,213]; [215,173,103]]/255;
            
%% Plot decoding per session
close all
fig = figure();
rng('default')
hold on
Nregions  = numel(region_names);
Nsessions = 27;

% Note decoding performance is set to NaN 
% if fewer than 2 neurons were recorded
for iregion = 1:Nregions
    results = decoding_results.region(iregion);
    % plot decoding performace per sessions
    swarmchart(2*iregion*ones(1,size(results.results,2)),...
        100*results.results,...
           40,plot_colors(iregion,:), 'filled',...
           'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha',0.2);
       
    % add error bar (SEM)
    results_no_nans = results.results(~isnan(results.results));
    errorbar(2*iregion,100*mean(results_no_nans),...
             100*HumanOdorRep_std_error(results.results), 'kx');
end
title('      Odor decoding \newlineper recording session')
yline(100/16, ':')
ax            = gca; 
ax.XTick      = 2:2:10; 
ax.XTickLabel = region_names;
ax.YLim       = [0, 41];
xlim([1,11])
ylabel('Decoding accuracy [%]');

% Stats over sessions
is_sig = nan(5, 27); % regions x sessions
for target_region = 1:Nregions
    results = decoding_results.region(target_region);
    % check for each region if decoding performance 
    % exceeds 95%-percentile of label permuted data
    for isession = 1:Nsessions
        temp_perm = results.permresults(isession, :);
        
        if isnan(results.results(isession))
            % no decoding performed
            is_sig(target_region, isession) = nan;
        else
            is_sig(target_region, isession) = ...
                results.results(isession) > prctile(temp_perm, 95);
        end
    end
end

% Test if significant number of sessions shows significant odor coding
% based on a binomial test 
fprintf(['Odor identity could be decoded significantly above chance ',...
    'across sessions in PC, Am, EC and Hp:\n'])
p         = 0.05;
ppSession = nan(1,5);

for iregion = 1:5
    % include only sessions for which decoding was performed
    N = sum(~isnan(is_sig(iregion,:)));
    k = nnz(is_sig(iregion,:) ==1);
    
    % binomial test
    % forcing a right sided test
    if k > N*p % found a larger count than expected by chance
        ppSession(iregion) = HumanOdorRep_myBinomTest(k, N, p, 'one');
    else % lower or equal count than expected by chance
        ppSession(iregion) = 1 - HumanOdorRep_myBinomTest(k-1, N, p, 'one');
    end
    
    % print results
    fprintf('%s: %i out of N=%i, P=%.2g;\n', ...
            region_names{iregion}, k, N, ppSession(iregion))
    HumanOdorRep_plot_sig_stars(2*iregion, ppSession(iregion), 31, 0);
end
fprintf('\n \n')
set(findall(fig, '-property', 'FontSize'), 'FontSize', 18);
set(findall(fig, '-property', 'LineWidth'), 'LineWidth', 2);
fig.Position = [0 0 250 350];

% save figure
exportgraphics(fig,fullfile(fileparts(fileparts(pwd)), 'Figures',...
    'Fig-2-e-decoding-per-session.pdf'), 'ContentType', 'vector')