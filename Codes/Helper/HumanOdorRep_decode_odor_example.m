%---------------------------------------------------------------------------------
% Example script for the decoding analysis performed with the Neural
% Decoding Toolbox (NDT) by Ethan M. Meyers
%
% Meyers, E. The neural decoding toolbox. Front. Neuroinformatics 7, (2013).
%
% Code based on the tutorial NDT tutorial:
% https://readout.info/tutorials/introduction-tutorial/
% 
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
%---------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% add path to Neural Decoding Toolbox
% addpath('Path_to_NDT/ndt.1.0.4');

%% data path 
data_path  = fullfile(fileparts(fileparts(fileparts(which('HumanOdorRep_decode_odor_example')))),...
                      'Data');
start_path = pwd;
% go to data directory
cd(data_path);

% settings for decoding analysis
settings.N_units_to_use  = 200;
settings.num_cv_splits   = 8;
settings.Nresample       = 10;
settings.lable_to_use    = 'odorID'; 
settings.bin_width       = 2000;
settings.step_size       = 2000;
settings.timeaxis        = 0:2000;
% speed up the example by using 50 subsampling runs
settings.N_perm          = 50;
settings.region_names    = {'PC','Am','EC','Hp','PHC'};
Nregions                 = numel(settings.region_names);

% initialize Neural Decoding Toolbox 
% NDT random generator leading minor variations of outcomes
add_ndt_paths_and_init_rand_generator() 


%% run decoding analysis across anatomical target region
for target_region = 1:Nregions
    
    target_region_name = settings.region_names{target_region};
    
    % load binned neuronal firing
    binned_format_file_name = ['Fig-2-b-binned-' target_region_name '.mat'];
    load(binned_format_file_name)
    N_units = numel(binned_data);
    
    %% decoding on real data
    % loop over subsampling runs
    for isubsample = 1:settings.N_perm
        
        fprintf('%s: run %i of %i\n',...
            target_region_name, isubsample, settings.N_perm);
        
        % generate decoding structure
        ds = basic_DS(binned_format_file_name, ...
                      settings.lable_to_use, settings.num_cv_splits);
        
        % randomly subsample neurons
        ds.sites_to_use = randperm(N_units, settings.N_units_to_use);
        
        % create a feature preprocessor that z-score normalizes each neuron
        the_feature_preprocessors{1} = zscore_normalize_FP;
        
        % create the CL object
        the_classifier = max_correlation_coefficient_CL;
        
        % create the CV object
        the_cross_validator = standard_resample_CV(ds, the_classifier,...
                                                   the_feature_preprocessors);
        
        % suppress command line outputs to increase performance
        the_cross_validator.display_progress.zero_one_loss     = 0;
        the_cross_validator.display_progress.resample_run_time = 0;
        
        % set how many times the outer 'resample' loop is run
        the_cross_validator.num_resample_runs = settings.Nresample;
        
        % skip cross-temporal decoding
        the_cross_validator.test_only_at_training_times = 1;
        
        % run the decoding analysis
        temp_results = the_cross_validator.run_cv_decoding;
        
        % save decoding results (mean across resample runs & CV splits)
        decoding_results.region(target_region).results(isubsample)  = ...
              mean(squeeze(mean(temp_results.ZERO_ONE_LOSS_RESULTS.decoding_results, 1)));
    end 

    %% decoding on label permutated data
    % loop over subsampling runs
    for isubsample = 1:settings.N_perm
        
        fprintf('%s: permutation %i of %i\n',...
            target_region_name,isubsample, settings.N_perm);

        % generate decoding structure
        ds = basic_DS(binned_format_file_name,...
                      settings.lable_to_use, settings.num_cv_splits);
        
        % randomly subsample neurons
        ds.sites_to_use = randperm(N_units, settings.N_units_to_use);
        
        % randomly shuffled the labels before running the docding
        ds.randomly_shuffle_labels_before_running = 1;
        
        % create a feature preprocessor that z-score normalizes each neuron
        the_feature_preprocessors{1} = zscore_normalize_FP;
        
        % create the CL object
        the_classifier = max_correlation_coefficient_CL;
        
        % create the CV object
        the_cross_validator = standard_resample_CV(ds, the_classifier,...
                                                   the_feature_preprocessors);
 
        % suppress command line outputs to increase performance
        the_cross_validator.display_progress.zero_one_loss     = 0;
        the_cross_validator.display_progress.resample_run_time = 0;
        
        % set how many times the outer 'resample' loop is run
        the_cross_validator.num_resample_runs = settings.Nresample;
        
        % skip cross-temporal decoding
        the_cross_validator.test_only_at_training_times = 1;
        
        % run the decoding analysis
        temp_results = the_cross_validator.run_cv_decoding;
        
        % save decoding of label permutated data (mean across resample runs & CV splits)
        decoding_results.region(target_region).permresults(isubsample)  = ...
              mean(squeeze(mean(temp_results.ZERO_ONE_LOSS_RESULTS.decoding_results, 1)));
    end 
end

%% save decoding results
save_file_name = fullfile(data_path,'Example_decoding');
% NDT random generator leads to minor variations of outcomes
save(save_file_name, 'decoding_results', '-v7.3');
cd(start_path);


% plot the results
save_path  = fullfile(fileparts(data_path), 'Figures');
addpath(fullfile(fileparts(pwd), 'Helper')) % add path to helper tools 
decoding_results_file = 'Example_decoding.mat';

plot_title = 'Odor decoding';
plot_name  = 'Example_decoding';
y_limits   = [0    80];
figsize    = [300 350];

HumanOdorRep_plot_decoding_results(data_path, decoding_results_file,...
    plot_title, plot_name, y_limits, save_path, figsize)
fprintf('\n \n')


