%-----------------------------------------------------------------------------------------
% Population sparseness of odor-modulated neurons across the PC & MTL
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   3a
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% load data
data_path  = fullfile(fileparts(fileparts(pwd)), 'Data'); 
load(fullfile(data_path, 'Fig-3-a-population-sparseness.mat'),...
    'population_sparseness')
addpath(fullfile(fileparts(pwd), 'Helper')) % add path to helper tools 

% plot colors and labels
plot_colors  = [[232,152,138]; [130,213,151];...
                [202,157,219]; [126,199,213]]/255;
region_names = {'PC', 'Am', 'EC' ,'Hp'};
load(fullfile(data_path, 'odor_colors.mat'));
odor_colors(2,:) = [];  % remove odorless control (stim 2)
Nregions = numel(region_names);

%% plot results
rng(1000, 'twister') % for reproducibility
fig = figure();
hold on
for iregion = 1:Nregions
    
    % population sparseness: brain regions x odors
    % plot population sparseness for each odor (excluding neutral, odor ID 2)
    temp_sparseness =  population_sparseness(iregion,[1 3:16]);
    sw = swarmchart(2*ones(1,numel(temp_sparseness))*iregion,...
                   temp_sparseness, 32, [0.4 0.3 0.8],...
                   'filled', 'MarkerFaceAlpha', 0.8, 'MarkerEdgeAlpha', 1);
    sw.CData = odor_colors;
    
    % add errorbar 
    errorbar(2*iregion, mean(temp_sparseness),...
             HumanOdorRep_std_error(temp_sparseness), 'kx')
end

xlim([0.5 8.5]);
ylabel('Sparseness index')
ax            = gca;
ax.XTick      = 2:2:8; 
ax.XTickLabel = region_names;
set(findall(fig, '-property', 'FontSize'), 'FontSize', 18);
set(findall(fig, '-property', 'LineWidth'), 'LineWidth', 2);
title('Population sparseness');
fig.Position = [0 0 280 300];

% save figure
exportgraphics(fig, fullfile(fileparts(fileparts(pwd)),...
               'Figures', 'Fig-3-a-population-sparseness.pdf'),...
               'ContentType', 'vector')
hold off

%% print stats
[p, tbl, stats] = anova1(population_sparseness(1:numel(region_names), ...
                         [1 3:16])', [], 'off');
mm              = multcompare(stats, 'Display', 'off');
sig_diff_idx    = find( mm(:,6) < 0.05);
fprintf('\n\nPopulation sparseness index across regions for each of the 15 odors.\n')
fprintf('Sparseness of odor coding significantly differed across regions.\n')
fprintf('ANOVA: F(%i,%i)=%.3G P=%.2G\n\n',tbl{2,3}, tbl{3,3}, tbl{2,5},p)
fprintf('PC exhibited a less sparse odor code than MTL regions\n')
fprintf('P<0.001 for all pairwise comparisons, following Tukey’s honestly significant difference procedure:\n') 

for ii = 1:size(mm,1)
    fprintf('%s vs %s, P=%.2G\n', region_names{mm(ii,1)},...
        region_names{mm(ii,2)}, mm(ii,6))
end