%-----------------------------------------------------------------------------------------
% Plot odor-identity decoding performance across regions
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   2b
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% load data
data_path  = fullfile(fileparts(fileparts(pwd)), 'Data'); 
save_path  = fullfile(fileparts(fileparts(pwd)), 'Figures');
addpath(fullfile(fileparts(pwd), 'Helper')) % add path to helper tools 
decoding_results_file = 'Fig-2-b-odor-deocoding.mat';

plot_title = 'Odor decoding';
plot_name  = 'Fig-2-b-odor-deocoding';
y_limits   = [0 80];
figsize    = [300 350];

HumanOdorRep_plot_decoding_results(data_path, decoding_results_file,...
    plot_title, plot_name, y_limits, save_path, figsize)
fprintf('\n \n')
