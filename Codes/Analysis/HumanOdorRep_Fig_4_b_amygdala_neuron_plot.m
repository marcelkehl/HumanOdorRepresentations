%-----------------------------------------------------------------------------------------
% Plot spike shape of example amygdala neuron
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   4b
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% load data
data_path  = fullfile(fileparts(fileparts(pwd)), 'Data'); 
addpath(fullfile(fileparts(pwd), 'Helper')) % add path to helper tools 
load(fullfile(data_path, 'Fig-4-b-amygdala-neuron-plot.mat'))

%% plot spike shape and density
fig = figure();
cba = HumanOdorRep_density_plot(spike_shapes);
title('Amygdala neuron')
set(findall(fig, '-property', 'FontSize'), 'FontSize', 14);
set(findall(fig, '-property', 'LineWidth'), 'LineWidth', 1.5);
fig.Position = [0 0 190 120];
fig.Children(2).Children(1).LineWidth = 0.2;
fig.Children(2).Children(2).LineWidth = 0.2;
fig.Children(2).Children(3).LineWidth = 0.5;

% save figure
exportgraphics(fig,fullfile(fileparts(fileparts(pwd)), 'Figures',...
    'Fig-4-amygdala-neuron-liked-density.pdf'), 'ContentType', 'vector')