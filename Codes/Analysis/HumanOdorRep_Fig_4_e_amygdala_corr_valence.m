%-----------------------------------------------------------------------------------------
% Correlation of firing rate of odor-modulated amygdala neurons 
% with reference valence ratings
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   4e
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% laod data
data_path     = fullfile(fileparts(fileparts(pwd)),'Data');
load(fullfile(data_path,'Fig-4-e-amygdala-corr-valence.mat'))
load(fullfile(data_path,'odor_colors.mat'));

% Reference odor ratings obtained from Toet, A., Eijsman, S., Liu, Y. et al. 
% The Relation Between Valence and Arousal in Subjective Odor Experience. 
% Chem. Percept. 13, 141–151 (2020). 
% https://doi.org/10.1007/s12078-019-09275-7

%% plot Amygdala correlation
idx_no_control =[1 3:16]; % exclude odorless control
fig  = figure(); 
hold on

xx            = odor_info.valence(idx_no_control)';
yy            = mean(Am_mean_z_resp_fr(:,idx_no_control), 1)';
plt           = scatter(xx, yy, 30, "filled");
plt.CData     = odor_colors(idx_no_control,:);
lm            = fitlm(xx, yy);
xr            = linspace(min(xx), max(xx), 100)';
[y_fit, y_ci] = predict(lm, xr);
plot(xr, y_fit, 'black');
fill([xr; flipud(xr)], [y_ci(:,1); flipud(y_ci(:,2))], [0.2 0.2 0.2],...
    'FaceAlpha', 0.1, 'EdgeColor', 'none');
[r_temp, p_temp] = corr(xx, yy, 'Type', 'Spearman');
xlabel('valence')
ylabel('z-score (FR)')
title('Am')
xlim([-2.3 2.2]);
set(findall(fig, '-property', 'LineWidth'), 'LineWidth', 2);
set(findall(fig, '-property', 'FontSize'), 'FontSize', 16);
fig.Position = [0 0 160 200];
% save figure
exportgraphics(fig,fullfile(fileparts(fileparts(pwd)), 'Figures',...
              'Fig-4-e-amygdala-corr-valance.pdf'), 'ContentType', 'vector')

fprintf('\n\nOdor-modulated neurons in the amygdala showed a positive correlation\n')
fprintf('of firing rate with reference valence ratings of the odors across sessions.\n')
fprintf('Spearman correlation, Nodors=%i, r=%.2f, P=%.2f.\n',...
    numel(idx_no_control), r_temp, p_temp)