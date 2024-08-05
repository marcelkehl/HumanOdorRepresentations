%-----------------------------------------------------------------------------------------
% Example raster plot of a human piriform neuron responding to odors
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   1g
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% load data
data_path = fullfile(fileparts(fileparts(pwd)),'Data'); 

load(fullfile(data_path,'Fig-1-g-piriform-odor-modulated-neuron.mat'))
addpath(fullfile(fileparts(pwd),'Helper')) % add path to helper tools 
load(fullfile(data_path,'odor_colors.mat'));
load(fullfile(data_path,'odor_names.mat'));
timeax    = -500:2500;    % define time axis
Nodors    = numel(stimnames);
Nodorreps = 8;

% calculate spike rate
[fr, sd, count]           = HumanOdorRep_firing_rate(trials, 0, max(timeax));

% sort trials acoring to spike rate
[stimids_sorted, idxsort] = sort(stimids);

% calculate response strength for each odor and sort responses
mean_count = nan(1,Nodors);
for ii=1:Nodors
    mean_count(ii) = mean(count(stimids == ii));    
end
[~,idx_fr_sorted]  = sort(mean_count, 'descend');

% sort trials
stim_ids_sorted    = repmat(idx_fr_sorted', 1, Nodorreps)';
stim_newids_sorted = repmat(1:Nodors, Nodorreps, 1);
sorted_trials      = cell(1, numel(stim_ids_sorted));
n_stims            = size(stim_ids_sorted, 1);
for ii=1:Nodors
    sorted_trials((ii-1)*n_stims+1 : ii*n_stims) =...
                trials(stimids == idx_fr_sorted(ii));
end

% plot raster
fig=figure('visible', 'on');
subplot(4, 3, 4:12)
hold on
HumanOdorRep_plot_raster(sorted_trials, timeax, stim_newids_sorted(:),...
    odor_colors(idx_fr_sorted, :));

% add odor names as y-Tick labels
ax            = gca;
ax.YTick      = 1/32: 1/Nodors: 31/32;
ax.YTickLabel = flip(stimnames(idx_fr_sorted));
x             = zeros(size(ax.YTick)) - 650;
text(x, ax.YTick, ax.YTickLabel, 'HorizontalAlignment', 'right',...
    'Color', [0.3 0.3 0.35]);
set(ax.XAxis, 'Visible', 'on');
set(ax.YAxis, 'Visible', 'off');
xlabel('t [ms]');      
ax.XColor = [0.3 0.3 0.35];
for ii = 1:Nodors
    % horizontal lines at the bottom denoting significant time windows
    text(-520, ax.YTick(end+1-ii), '\bullet', 'HorizontalAlignment',...
        'right', 'Color', odor_colors(idx_fr_sorted(ii), :), 'FontSize', 40);
end
ax.PositionConstraint = 'outerposition';
ax.Position           = ax.Position .* [2.2 1.0 0.85 1];

% add spike density plot 
splot = subplot(4, 3, 2:3);
hold on;
cba          = HumanOdorRep_density_plot(spike_waveform);
ax2          = gca;
ax2.Position = ax2.Position .* [1.05 1.05 0.7 0.65];
hold off;
title(sprintf('%s neuron', 'PC'))
set(findall(fig,'-property', 'FontSize'), 'FontSize', 14);
set(findall(fig,'-property', 'LineWidth'), 'LineWidth', 1.5);
fig.Position = [0 0 300 480];

% save figure
exportgraphics(fig,fullfile(fileparts(fileparts(pwd)),'Figures',...
    'Fig-1-g-piriform-odor-modulated-neuron.pdf'),'ContentType','vector')

% print stats
[~, ~, cc]       = HumanOdorRep_firing_rate(trials, 0, 2000);
% Note: z-scoring does not impact ANOVA results 
[pp, tbl, stats] = anova1(cc, stimids, 'off'); 
fprintf('\n\nRepresentative example of an odor-modulated neuron in the left PC.\n')
fprintf('Firing rate significantly changed in response to different odors\n')
fprintf('(one-way ANOVA of z-scored firing rates with odor identity, F(%i,%i)=%.3G, P=%.2G)\n',...
          numel(stats.gnames)-1, stats.df, tbl{2,5}, pp); 
      