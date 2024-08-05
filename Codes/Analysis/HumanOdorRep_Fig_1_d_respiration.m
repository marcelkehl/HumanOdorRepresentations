%-----------------------------------------------------------------------------------------
% Plot mean respiratory track locked to odor onset
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   1d
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% load data
data_path = fullfile(fileparts(fileparts(pwd)), 'Data'); 
load(fullfile(data_path,'Fig-1-d-respiration.mat'))
addpath(fullfile(fileparts(pwd),'Helper')) % add path to helper tools 

% plot mean respiratory track across recordings with respiration  (N = 13)
close all
fig = figure();
hold on

% plot 0-2 analysis window
patch([0 2 2 0], [-100 -100 100 100], [0.6 0.6 0.7],...
      'Facealpha', 0.05, 'Edgealpha',0);
% plot mean respiration +- SEM
HumanOdorRep_plot_signals(vertcat(resp.sessionmean),...
                          resp.time_axis, [0.9 0.2 0.3]); 
xline(0,  ':', 'LineWidth', 2, 'DisplayName', '');
yline(0, '--', 'LineWidth', 2, 'DisplayName', '');
xlim([-1.5, 3.5]);
ylim([-65 , 65 ]);
xlabel('t [s]');
ylabel('Respiration depth [AU]');
title('Odor-locked\newline  respiration');
fig.Position = [ 0 0 200 320];
set(findall(fig,'-property','FontSize'),'FontSize',24);
set(findall(fig,'-property','LineWidth'),'LineWidth',2);

% save figure
exportgraphics(fig,fullfile(fileparts(fileparts(pwd)),'Figures',...
    'Fig-1-d-respiration.pdf'),'ContentType','vector');