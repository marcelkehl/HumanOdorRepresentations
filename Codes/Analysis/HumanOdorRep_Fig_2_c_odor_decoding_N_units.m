%-----------------------------------------------------------------------------------------
% Decoding performance as a function of the neuron count included in the
% analysis
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   2c
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% load data
data_path = fullfile(fileparts(fileparts(pwd)), 'Data'); 
load(fullfile(data_path, 'Fig-2-c-odor-decoding-N-units.mat'),...
    'decoding_results');
addpath(fullfile(fileparts(pwd), 'Helper')) % add path to helper tools 

% plot colors and labels
plot_colors  = [[232,152,138]; [130,213,151]; [202,157,219];...
                [126,199,213]; [215,173,103]]/255;
region_names = {'PC', 'Am', 'EC' ,'Hp', 'PHC'};

n_regions    = size(region_names, 2);
pp           = nan(1, n_regions);
temp_values  = nan(n_regions, 63);
n_odors      = 16;

% plot decoding performance as a function of the number of neurons
fig = figure();
hold on
for iregion = 1 : n_regions
    results     = decoding_results.region(iregion);
    
    % plot decoding performance as a fuction of the number of neurons
    % included in the decoding analysis
    pp(iregion) = HumanOdorRep_plot_signals(100*results.results',...
        results.nunits', plot_colors(iregion,:),'SEM');
    
    % calculate stats vs. chance level (6.25%)
    N_pop_sizes = size(results.results, 1);
    for ii=1:N_pop_sizes
        temp_values(iregion, ii) = signrank(100*results.results(ii, :),...
            100/n_odors, 'tail', 'right');
    end
    
    % Bonferroni correction across all bins
    temp_sig_sizes = double((temp_values(iregion, :) < 0.05 / N_pop_sizes));
    
    % plot line for neuron counts with significant decoding
    temp_sig_sizes(temp_sig_sizes == 0) = nan;
    for ii = 1 : N_pop_sizes
        % horizontal lines at the bottom denoting significant population
        % sizes
        plot([ii*10-5, ii*10+5], [6-2*iregion*temp_sig_sizes(ii),...
            6-2*iregion*temp_sig_sizes(ii)],...
             'HandleVisibility', 'off', 'Color', plot_colors(iregion,:))
    end
end
legend(pp,region_names, 'NumColumns', 2, 'Autoupdate', 'off')
legend('boxoff')   
ylabel('Decoding accuracy [%]')
xlabel('Number of neurons')
yline(100/n_odors, ':') % chance level
ylim([-6, 80])
title('Population size')
ax = gca;
set(findall(fig, '-property', 'FontSize'), 'FontSize', 18);
set(findall(fig, '-property', 'LineWidth'), 'LineWidth', 2);
fig.Position = [0 0 450 350];

% save figure
exportgraphics(fig, fullfile(fileparts(fileparts(pwd)), 'Figures',...
    'Fig-2-c-odor-decoding-N-units.pdf'), 'ContentType', 'vector')

% stats
fprintf('Performance of odor identity decoding (mean ± SEM) as a function of the number of neurons used in the analysis,\n')
fprintf('using 100 resample runs. Horizontal bars indicate neuron counts for which decoding performance significantly exceeded chance.\n')
fprintf('(P<0.05, right-sided Wilcoxon signed rank against chance after Bonferroni correction).\n')
for iregion = 1:n_regions
        fprintf('%s minimum population size with significant decoding: %i neurons \n', region_names{iregion},...
        decoding_results.region(iregion).nunits(find(temp_values(iregion,:) < 0.05/N_pop_sizes,1)));
end