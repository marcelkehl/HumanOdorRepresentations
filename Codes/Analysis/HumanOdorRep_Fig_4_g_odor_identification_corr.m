%-----------------------------------------------------------------------------------------
% Correlation of firing rate of odor-modulated amygdala neurons with reference valence ratings
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   4g
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% laod data
data_path     = fullfile(fileparts(fileparts(pwd)), 'Data');
load(fullfile(data_path, 'Fig-4-g-odor-identification-corr.mat'))

% plot colors and labels
plot_colors  = [[232,152,138]; [130,213,151]; [202,157,219];...
                [126,199,213]; [215,173,103]]/255;
region_names = {'PC', 'Am', 'EC' ,'Hp', 'PHC'};

% compare firing rates of correct vs. wrong in odor modulated neurons
[pp, ~, stats] = signrank(z_fr_correct, z_fr_wrong);
fprintf('Correct odor identification was accompanied by an overall increase in firing rate of odor-modulated neurons:\n')
fprintf('Wilcoxon signed rank correct vs incorrect: N=%i, Z=%.2f, P=%.2g \n \n',...
    numel(z_fr_correct), stats.zval, pp)
fprintf('Neuronal odor-decoding accuracy and behavioral odor-identification performance across regions and sessions:');

% plot correlations of behavior and decoding accuracy
fprintf('\n\n')
fig = figure();
for idx_region = 1:5
    
    subplot(1, 5, idx_region)
    hold on
    decoding_region   = 100*decoding_results.region(idx_region).results; 
    
    % remove sessions with no decoding (i.e., not enough neurons)
    xx              = 100*proportion_correct(~isnan(decoding_region))';
    yy              = decoding_region(~isnan(decoding_region))';
    
    % calculate correlation and print results
    [r_temp, p_temp] = corr(xx, yy, 'Type', 'Spearman');
    fprintf('%s: N=%i, r=%.2f, P=%.2g;\n', region_names{idx_region},...
        numel(yy), r_temp, p_temp)
    
    % plot correlation
    plot(xx, yy, '.', 'Markersize', 16, 'Color', plot_colors(idx_region,:))
    
    % plot linear model and error range
    lm              = fitlm(xx, yy);
    xr              = linspace(min(xx), max(xx), 100)';
    [y_fit, y_ci]   = predict(lm, xr);
    plot(xr, y_fit, 'black');
    fill([xr; flipud(xr)], [y_ci(:,1); flipud(y_ci(:,2))], [0.2 0.2 0.2],...
         'FaceAlpha', 0.1, 'EdgeColor', 'none');
    title(sprintf('%s', region_names{idx_region}));
    xlim([48 100]);
    ax=gca; 
    ax.XTick = [50,75,100];
    if idx_region ==3
        xlabel('Behavioral odor identification performance per session [%]')
    end
    if idx_region ==1
        ylabel('Neuronal decoding accuracy \newline      per session [%]')
    end
    hold off
end
fprintf('\n\n')
set(findall(fig, '-property', 'FontSize'), 'FontSize', 16);
set(findall(fig, '-property', 'LineWidth'), 'LineWidth', 1.5);
fig.Position = [0 0 940 190];

% save figure
exportgraphics(fig,fullfile(fileparts(fileparts(pwd)), 'Figures',...
    'Fig-4-g-odor-identification-corr.pdf'), 'ContentType', 'vector')