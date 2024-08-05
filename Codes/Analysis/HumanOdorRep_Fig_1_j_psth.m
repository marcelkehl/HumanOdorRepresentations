%-----------------------------------------------------------------------------------------
% Peri-stimulus time histograms for odor-modulated neurons compared to 
% other neurons
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   1j
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% laod data
data_path    = fullfile(fileparts(fileparts(pwd)), 'Data');
load(fullfile(data_path, 'Fig-1-j-psth.mat'))
region_names = {'PC', 'Am', 'EC', 'Hp', 'PHC'};

% Plot PSTH
fig = figure(); clf;
hold on
n_regions = size(z_om_units, 2);
all_ax = cell(1, n_regions);
for iregion = 1:n_regions    
    all_ax{iregion} = subplot(1,n_regions,iregion);
    hold on
    % odor-modulated vs other units in this region
    om_region    = all_sitenumbers==iregion &   logical(is_sig_cell);
    other_region = all_sitenumbers==iregion &  ~logical(is_sig_cell);
    
    % get 2d arrays: n_units x 200 time points
    om_data    = vertcat(psth_all.his_count_all_z{om_region'});
    other_data = vertcat(psth_all.his_count_all_z{other_region'});
    
    % remove units with insufficient baseline spikes 
    om_data    = om_data(~isnan(sum(om_data,2)),:); 
    other_data = other_data(~isnan(sum(other_data,2)),:); 

    bar(psth_all.bin_center, mean(om_data), 'FaceAlpha', 0.7,...
        'FaceColor',[0.80, 0.3, 0.05]);
    bar(psth_all.bin_center, mean(other_data), 'FaceAlpha', 0.7,...
        'FaceColor',[0.4, 0.4, 0.4]);
    
    if iregion ==n_regions
        legend("odor-modulated", "other", 'AutoUpdate', 'off',...
            'Location', 'best')
    end
    
    % plot settings
    xline(0 ,':')
    title(sprintf('%s', region_names{iregion}));
    xlim([-1000, 4000]);
    ylim([-0.5, 2.5]);
    ax = gca;
    ax.XTick = [0, 1000, 2000, 3000];
    ax.XTickLabel = ["0", "1", "2", "3"];
    if iregion==1
        ylabel('z-score (FR)')
    elseif iregion==3
        xlabel('t [s]')
    end
    hold off
end
set(findall(fig, '-property', 'FontSize'), 'FontSize', 14);
set(findall(fig, '-property', 'LineWidth'), 'LineWidth', 1.5);
fig.Position = [0, 0, 880, 220];

% save figure
exportgraphics(fig, fullfile(fileparts(fileparts(pwd)), 'Figures',...
    'Fig-1-psth.pdf'), 'ContentType', 'vector')

%% Print stats
[p_mean_z_fr_om]   = nan(1, n_regions);
stats_template     = struct('zval', [], 'signedrank', []);
stats_mean_z_fr_om = repmat(stats_template, 1, n_regions);
for iregion = 1:n_regions
    [p_mean_z_fr_om(iregion),    ~, stats_mean_z_fr_om(iregion)] =...
        signrank(z_om_units{iregion});
end

fprintf(['\n\nPeristimulus time histogram (PSTH) for all odor-',...
    'modulated neurons (red)\ncompared to other recorded neurons ',...
    '(grey) iacross regions (50 ms bins).\n'])
fprintf(['Odor-modulated neurons exhibited increased firing in all ',...
    'regions except PHC\n(Wilcoxon signed-rank of z-scored firing rates',...
    ' (0–2s) against zero,\n'])
for iregion = 1:n_regions
    fprintf('%s: N=%i, Z=%.2G, P=%.2g;\n', region_names{iregion},...
        sum(~isnan(z_om_units{iregion})),...
        stats_mean_z_fr_om(iregion).zval, p_mean_z_fr_om(iregion))
end

fprintf('\n\n')