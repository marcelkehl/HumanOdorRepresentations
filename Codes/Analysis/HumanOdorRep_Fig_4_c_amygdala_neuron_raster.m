%-----------------------------------------------------------------------------------------
% Raster plot of amygdala neuron responding stronger 
% to odors rated as liked vs. disliked
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   4c
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% laod data
data_path     = fullfile(fileparts(fileparts(pwd)), 'Data');
load(fullfile(data_path, 'Fig-4-c-amygdala-neuron-raster.mat'))
region_names  = {'PC','Am','EC','Hp','PHC'};
color_liked   = [0.15 0.85 0.15];
color_dislike = [0.5 0.5 0.8];
time_axis     = -2000:3000;

% plot results
fig = figure();
hold on

% plot raster using two different colors (liked vs. disliked)
ax1 = subplot(7, 1, 1:5);
ppr = HumanOdorRep_plot_raster([tr_liked, tr_not_liked], time_axis,...
                               [ones(1,numel(tr_liked)),...
                                2*ones(1,numel(tr_not_liked))],...
                                [color_liked; color_dislike], 2);
ppr.Children(1).Color = [0.6 0.6 0.6];

% plot PSTH
ax2 = subplot(7,1,6:7);
hold on
% liked
errorbar(-1500:1000:2500, mean(trial_fr_liked),...
         std(trial_fr_liked)./sqrt(size(trial_fr_liked, 1)), 'Color', color_liked);
% disliked
errorbar(-1500:1000:2500, mean(trial_fr_not_liked),...
         std(trial_fr_not_liked)./sqrt(size(trial_fr_liked,1)),'Color', color_dislike);

% plot settings
xlim([min(time_axis), max(time_axis)])
legend("liked", "disliked", 'Location', 'northwest', 'box', 'off')
xlabel('t [ms]')
ylabel('FR [Hz]')
set(findall(fig, '-property', 'FontSize'), 'FontSize', 18);
set(findall(ax2, '-property', 'LineWidth'), 'LineWidth', 2);
set(findall(ax1, '-property', 'LineWidth'), 'LineWidth', 4);
fig.Position = [0 0 390 450];

% save figure
exportgraphics(fig,fullfile(fileparts(fileparts(pwd)),'Figures',...
    'Fig-4-c-amygdala-neuron-raster.pdf'), 'ContentType', 'vector')
hold off

% print stats
[~, ~, counts_liked]    = HumanOdorRep_firing_rate(tr_liked,     0, 2000);
[~, ~, counts_disliked] = HumanOdorRep_firing_rate(tr_not_liked, 0, 2000);
[p, ~, stats]           = ranksum(counts_liked, counts_disliked);
fprintf('This neuron differentially increases firing in response to liked vs. disliked odors.\n')
fprintf('Wilcoxon rank-sum, N=%i vs. %i, Z= %2.1f, P=%.2G, z-scored firing rates 0-2 s after odor onset.\n\n',...
         numel(tr_liked), numel(tr_not_liked), stats.zval, p);
 