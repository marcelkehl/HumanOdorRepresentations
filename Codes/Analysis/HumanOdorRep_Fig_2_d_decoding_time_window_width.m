%-----------------------------------------------------------------------------------------
% Decoding perfromance as a function of decoding time window lenght
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   2d
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% load data
data_path  = fullfile(fileparts(fileparts(pwd)), 'Data'); 
load(fullfile(data_path, 'Fig-2-d-decoding-time-window-width.mat'),...
    'decoding_results');
addpath(fullfile(fileparts(pwd), 'Helper')) % add path to helper tools 

% plot colors and labels
plot_colors  = [[232,152,138]; [130,213,151]; [202,157,219];...
                [126,199,213]; [215,173,103]]/255;
region_names = {'PC', 'Am', 'EC' ,'Hp', 'PHC'};
bin_width    = 50:50:4000;
n_odors      = 16;
n_regions    = size(region_names, 2);
pp           = nan(1, n_regions);

% print outputs
fprintf('\n\nPerformance of odor-identity decoding (mean ± SEM) as a function of the decoding time window beginning at odor onset,\n')
fprintf('using 200 neurons randomly drawn and 100 subsampling runs.\n')
fprintf('Horizontal bars indicate time intervals where decoding performance significantly exceeded chance\n')
fprintf('P<0.05, right-sided Wilcoxon signed rank against chance after Bonferroni correction;\n')
fprintf('Beginning of the sustained significant interval:\n') 

% plot results
fig = figure(); 
hold on
pvalues = nan(n_regions, numel(bin_width));
for iregion = 1:n_regions
    temp_data   = 100*vertcat(decoding_results.region(iregion).all_results{:})';
    
    % plot decoding performance as function of decoding-time-window length
    pp(iregion) = HumanOdorRep_plot_signals(temp_data, bin_width,...
                                            plot_colors(iregion,:), 'SEM');
    
    % calculate stats vs. chance level (6.25%)
    for ii=1:numel(bin_width)
        pvalues(iregion, ii) = signrank(temp_data(:, ii),...
            100/n_odors, 'tail', 'right');
    end
    
    % Bonferroni correction across all 80 time bins
    temp_sig_times = double((pvalues(iregion,:) < 0.05/80));
    temp_sig_times(temp_sig_times==0) = nan;
    for ii=1:numel(temp_sig_times)
        plot([bin_width(ii)-25, bin_width(ii)+25],...
             [4-2*iregion-temp_sig_times(ii),...
              4-2*iregion-temp_sig_times(ii)],...
             'HandleVisibility', 'off', 'Color' ,plot_colors(iregion, :))
    end
    sig_bins = pvalues(iregion,:) < 0.05/numel(bin_width);
    fprintf('%s: %i ms; ', region_names{iregion},...
        bin_width(min(strfind(sig_bins,[1 1 1]))));
end
fprintf('\n\n');
ylabel('Decoding accuracy [%]')
xlabel('Decoding window [ms]')
yline(100/n_odors, ':'); % chance level
xlim( [0, 4000]);
ylim( [-9,  85]);
title('Temporal dynamics');
set(findall(fig, '-property', 'FontSize'), 'FontSize', 18);
set(findall(fig, '-property', 'LineWidth'), 'LineWidth', 2);
fig.Position = [ 0 0 450 350];
exportgraphics(fig, fullfile(fileparts(fileparts(pwd)),...
    'Figures','Fig-2-d-decoding-time-window-width.pdf'),...
    'ContentType', 'vector')