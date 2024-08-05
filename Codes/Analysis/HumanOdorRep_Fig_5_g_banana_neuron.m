%-----------------------------------------------------------------------------------------
% Plot multimodal banana neuron
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   5g
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% load data
data_path  = fullfile(fileparts(fileparts(pwd)), 'Data');
save_path  = fullfile(fileparts(fileparts(pwd)), 'Figures');

load(fullfile(data_path,'Fig-5-g-banana-neuron'))
addpath(fullfile(fileparts(pwd), 'Helper')) % add path to helper tools 

% plot banana neuron and calculate statistics
HumanOdorRep_plot_multimodal_neuron(unitdata, data_path, save_path)