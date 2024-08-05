%-----------------------------------------------------------------------------------------
% Script to plot the fraction of odor-modulated neuron per recording session
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   1h
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% load data
data_path = fullfile(fileparts(fileparts(pwd)), 'Data'); 
load(fullfile(data_path, 'Fig-1-h-fraction-odor-modulated-neurons.mat'))
addpath(fullfile(fileparts(pwd), 'Helper')) % add path to helper tools 
region_names = {'PC', 'Am', 'EC', 'Hp', 'PHC'};
plot_colors  = [[232, 152, 138]; [130, 213, 151]; [202, 157, 219];...
                [126, 199, 213]; [215, 173, 103]] / 255;
rng('default');

%% plot results
close all
fig = figure();
hold on
fprintf('\nMean percentage of OM units across sessions: \n \n')
n_regions = size(odor_modulated_cells_per_session, 2);
pp        = nan(1, n_regions);
stats     = cell(1, n_regions);

for iregion = 1:n_regions
    temp_percentage = 100*odor_modulated_cells_per_session(:, iregion);
    % remove sessions without units in this brain region
    temp_percentage = temp_percentage(~isnan(temp_percentage)); 
    bar(2*iregion, mean(temp_percentage), 'Facecolor', 'none',...
        'EdgeAlpha', 0.4);
    swarmchart(2*iregion*ones(1, size(temp_percentage, 1)),...
        temp_percentage, 28, plot_colors(iregion, :), 'filled',...
               'MarkerFaceAlpha', 0.6, 'MarkerEdgeAlpha', 1);
    errorbar(2*iregion, mean(temp_percentage),...
        HumanOdorRep_std_error(temp_percentage), 'kx');
    [pp(iregion), ~, stats{iregion}]  = signrank(temp_percentage-5); % vs. 5% chance level
    HumanOdorRep_plot_sig_stars(2*iregion, pp(iregion), 83, 0);
end
yline(5,':')
title('Odor-modulated neurons')
ax            = gca;
ax.XTick      = 2:2:10;
ax.XTickLabel = region_names;
ylim([0, 90])
ylabel('Odor-modulated neurons [%]');
set(findall(fig, '-property', 'FontSize'), 'FontSize', 18);
set(findall(fig, '-property', 'LineWidth'), 'LineWidth', 2);
fig.Position = [0 0 330 370];

% save figure
exportgraphics(fig, fullfile(fileparts(fileparts(pwd)), 'Figures',...
    'Fig-1-h-fraction-odor-modulated-neurons.pdf'), 'ContentType', 'vector')

%% print stats
fprintf('Proportion of odor-modulated neurons per recording session subdivided by region (mean ± SEM).\n')  
fprintf('Neurons were classified as odor-modulated if firing rates significantly changed with odor identity based on an ANOVA. \n')
fprintf('Chance level indicated by horizontal dashed line. PC, Am, EC, and Hp host significant populations of odor-modulated neurons:\n')
for iregion =1:5
    temp_percentage = 100*odor_modulated_cells_per_session(:, iregion);
    % remove sessions without units in this brain region
    temp_percentage = temp_percentage(~isnan(temp_percentage)); 
    fprintf('%s: %2.3g±%.2g%%, N=%i, Z=%.2G, P=%.2g; \n', ...
        region_names{iregion}, mean(temp_percentage),...
        HumanOdorRep_std_error(temp_percentage),...
        sum(~isnan(temp_percentage)), stats{iregion}.zval,pp(iregion))
end