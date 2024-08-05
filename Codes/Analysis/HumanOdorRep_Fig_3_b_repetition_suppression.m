%-----------------------------------------------------------------------------------------
% Repetition suppression of neuronal responses to repeated odor presentations
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   3b
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% load data
data_path  = fullfile(fileparts(fileparts(pwd)), 'Data'); 
load(fullfile(data_path, 'Fig-3-b-repetition-suppression.mat'))
addpath(fullfile(fileparts(pwd), 'Helper')) % add path to helper tools 

% plot colors and labels
plot_colors  = [[232,152,138]; [130,213,151]; [202,157,219];...
                [126,199,213]; [215,173,103]]/255;
region_names = {'PC', 'Am', 'EC', 'Hp'};

%% calculate response slopes across 8 odor presentations
z_response_mat = rep_data.z_response_mat;
% number of odor modulated neurons
n_units        = size(z_response_mat, 1);
resp_slopes    = nan(size(z_response_mat, 1), 1);
for iunit = 1:n_units
    % linear regression for response strength across 8 repetitions
    pfit = polyfit(1:8, z_response_mat(iunit,:), 1);
    resp_slopes(iunit) = pfit(1);
end

%% plot results per odor presentation and region  
fig = figure(); 
hold on
[all_ax, reg_slope, stats_slope] = deal(cell(numel(region_names),1));
pslope                           = nan(numel(region_names),1);

for iregion = 1:numel(region_names)
    all_ax{iregion} = subplot(1, numel(region_names), iregion);
    hold on
    
    cell_inds = rep_data.region_idx == iregion;
    % plot mean and errorbars
    ee = errorbar(1:8, mean(z_response_mat(cell_inds, :)),...
                  std(z_response_mat(cell_inds, :))./sqrt(sum(cell_inds)),...
                 'Color', plot_colors(iregion, :));
             
    yline(0, "--")
    if iregion == 1
        ylabel('z-score (FR)') 
        xlabel('Odor presentation')
    end
    title({sprintf('%s', region_names{iregion})})
    ax        = gca;
    ax.XTick  = 2:2:8;
    ylim([-0.3 2.5])
    
    % test all slopes per region vs. constant response (i.e., slope of 0)
    reg_slope{iregion} = resp_slopes(cell_inds);
    [pslope(iregion), ~, stats_slope{iregion}]   = signrank(reg_slope{iregion});
    
    % plot inlay with bar chart of slopes
    inner_temp_position = [all_ax{iregion}.Position(1)+0.75*all_ax{iregion}.Position(3),...
                           all_ax{iregion}.Position(2)+0.75*all_ax{iregion}.Position(4),...
                           0.22*all_ax{iregion}.Position(3),...
                           0.22*all_ax{iregion}.Position(4)];
                       
    h = axes('Position', inner_temp_position, 'Layer', 'top'); %[left bottom width height]
    hold on
    bb = bar(1, mean(reg_slope{iregion}), ...
             'EdgeColor', [1 1 1], 'FaceColor', [0.8 0.8 1]);
    errorbar(1, mean(reg_slope{iregion}),...
             std(reg_slope{iregion}) / sqrt(numel(reg_slope{iregion})),...
             'color', [0.5 0.5 0.5])
    
    % plot sig stars
    text(bb.XEndPoints, bb.YEndPoints - 0.09, ...
        HumanOdorRep_get_sig_string(pslope(iregion)),...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
    
    yline(0, ':');
    h.XColor        = [1 1 1];
    h.XAxis.Visible = 'off'; 
    ylim([-0.14, 0.02]);
    xlim([0.2 1.5]);
    yticks(h,[-0.1, 0]);
    if iregion == 1
        ylabel('slope');
    end 
    box off
    hold off
end
set(findall(fig, '-property', 'FontSize'), 'FontSize', 14);
set(findall(fig, '-property', 'LineWidth'), 'LineWidth', 1.5);
fig.Position = [0 0 660 220];

% save figure
exportgraphics(fig, fullfile(fileparts(fileparts(pwd)), 'Figures',...
               'Fig-3-b-repetition-suppression.pdf'),'ContentType','vector');

%% print stats
fprintf('\n\nAverage response strength of odor-modulated neurons for repeated odor presentations across regions (mean ± SEM).\n')
fprintf('Insets show response slopes per region (mean ± SEM).\n')
fprintf('Significance is based on a Wilcoxon signed-rank test against a constant response strength, i.e., a slope of zero:\n\n')
for iregion=1:4
    fprintf('%s: N=%d, Z=%.2g, p=%.2g;\n', region_names{iregion}, ...
        sum(rep_data.region_idx == iregion), stats_slope{iregion}.zval,...
        pslope(iregion))
end
fprintf('\n\n')
% test 1st against 2nd trial
[p, ~, stats] = signrank(z_response_mat(rep_data.region_idx == 1,1),...
                         z_response_mat(rep_data.region_idx == 1,2));
fprintf('Firing of PC neurons substantially decreased from the first to the second odor presentation.\n')
fprintf('Wilcoxon signed rank of firing rate in the first vs second trial in PC: N=%i, Z=%.1f, P=%.2G\n',...
         sum(rep_data.region_idx==1), stats.zval, p)
