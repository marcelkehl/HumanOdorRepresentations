%-----------------------------------------------------------------------------------------
% Cross-modal decoding of stimulus identity, trained on odors and tested on images
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   5f
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% load data
data_path  = fullfile(fileparts(fileparts(pwd)), 'Data'); 
save_path  = fullfile(fileparts(fileparts(pwd)), 'Figures');

addpath(fullfile(fileparts(pwd), 'Helper')) % add path to helper tools 
decoding_results_file = 'Fig-5-f-odor-to-image-decoding';

plot_title = 'Odor-to-image decoding';
plot_name  = 'Fig-5-f-odor-to-image-decoding';
y_limits   = [0 18];
HumanOdorRep_plot_decoding_results(data_path, decoding_results_file,...
                                   plot_title, plot_name, y_limits, save_path)
fprintf('\n \n')