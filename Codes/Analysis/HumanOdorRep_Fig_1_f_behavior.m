%-----------------------------------------------------------------------------------------
% Script for behavioral analysis of the odor-rating and 
% odor-identification task
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   1f
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% load data
data_path = fullfile(fileparts(fileparts(pwd)), 'Data'); 
load(fullfile(data_path, 'Fig-1-f-behavior.mat'))
addpath(fullfile(fileparts(pwd), 'Helper')) % add path to helper tools 
load(fullfile(data_path, 'odor_colors.mat'));
load(fullfile(data_path, 'odor_names.mat'));
rng('default')

% plot Behavior
fig = figure;
hold on
odors_liked   = nanmean(stim_liked_percent); 
odors_correct = nanmean(stim_correct_percent);
% nan mean used as first session had no odorless control;

Nodors = numel(odors_liked);

% plot fraction of odors liked across sessions
sw = swarmchart(1*ones(1,Nodors),odors_liked,...
           80,[0.9 0.6 0.65], 'filled', 'MarkerFaceAlpha', 0.8,...
           'MarkerEdgeAlpha', 1, 'XJitterWidth', 0.3);
sw.CData = odor_colors;

% plot fraction of odors correctly identified across sessions
sw = swarmchart(2*ones(1,Nodors),odors_correct,...
           80, [0.6 0.9 0.65], 'filled', 'MarkerFaceAlpha', 0.8,...
           'MarkerEdgeAlpha', 1, 'XJitterWidth', 0.3);
sw.CData = odor_colors;

% add chance level as horizontal line
line([1.8,2.2], [25,25], 'Color', [0.3 0.3 0.3], 'Linestyle',':')

% add box plots
boxplot(vertcat(odors_liked', odors_correct'),...
        vertcat(zeros(Nodors,1), ones(Nodors,1)),...
        'Notch', 'off', 'Colors',[0 0 0], 'symbol', '')
  
ylim([0 100])
xlim([0.5 2.5])
xticks([1 2])
xticklabels({'Valence', 'Identity'});
ylabel('Odors liked or correct [%]')
fig.Position = [ 0 0 300 400];
ax=gca;
title('Behavior')
set(findall(fig, '-property', 'FontSize'), 'FontSize',22);
set(findall(fig, '-property', 'LineWidth'), 'LineWidth',2);

% save figure
exportgraphics(fig,fullfile(fileparts(fileparts(pwd)),...
               'Figures', 'Fig-1-f-behavior.pdf'), 'ContentType', 'vector')
hold off

fprintf('\n\nBehavioral performance for each odor averaged across all 27 sessions (box plots):\n')
fprintf('Odor ratings (left) and percentage of correctly identified odors (right).\n')
fprintf('The horizontal dashed line indicates chance level (25%%).\n')

% Output statistics
fprintf('Mean percent of odors liked: %.1f +- %.1f%% \n',...
    nanmean(stim_liked_percent(:)),...
    std(stim_liked_percent(~isnan(stim_liked_percent)))/...
    sqrt(numel(stim_liked_percent(~isnan(stim_liked_percent)))));

fprintf('Mean percent of odors correct: %.1f +- %.1f%% \n',...
    nanmean(stim_correct_percent(:)),...
    nanstd(stim_correct_percent(:))/...
    sqrt(numel(stim_correct_percent(~isnan(stim_correct_percent)))));

% The mean odor-identification performance was above chance across odors.
[pgroup,~,statsgroup] = signrank(nanmean(stim_correct_percent, 1), 25);
fprintf('\n Odors were correctly identified above chance across sessions (two-sided Wilcoxon signed-rank):\n\n')
fprintf('N=%i, Z=%.2G, P=%.2G;\n', numel(nanmean(stim_correct_percent,1)), ...
         statsgroup.zval, pgroup);

% All odors were recognized above chance
pp    = []; 
stats = [];
for iodor = 1:Nodors
    [pp(iodor), ~, stats{iodor}] = signrank(stim_correct_percent(:,iodor), 25); % 25% chance level
end

if min(pp) < 0.01
    fprintf('\nAll odors correctly identified above chance across sessions (P<0.01, Wilcoxon signed-rank):\n\n')
    for iodor = 1:Nodors
        fprintf('%s: N=%i, Z=%.2G, P=%.2G;\n',...
            stimnames(iodor), sum(~isnan(stim_correct_percent(:,iodor))),...
            stats{iodor}.zval,pp(iodor));
    end
end