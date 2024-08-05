function HumanOdorRep_plot_decoding_results(data_path,...
    decoding_results_file, plot_title, plot_name, y_limits, save_path,...
    figsize, Err_type)
% function HumanOdorRep_plot_decoding_results(data_path,...
%     decoding_results_file, plot_title, plot_name, y_limits, save_path,...
%     figsize, Err_type)
% 
% Function to plot decoding results
%
% Input:
%
% data_path: path to decoding results
% decoding_results_file: name of decoding result file
% plot_title: Title of the plot
% plot_name: Name of the figure
% y_limits: limits of the y-axis 
% save_path: path to save the plot
% figsize: size of the figure in pixel
% Err_type: 'SEM' or 'SD'

%-----------------------------------------------------------------------------------------
% Plot fraction of odor-modulated neurons without the odorless control
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------


% load data
load(fullfile(data_path, decoding_results_file), 'decoding_results');
region_names = {'PC', 'Am', 'EC', 'Hp', 'PHC'};

if ~exist('Err_type', 'var') || isempty(Err_type)
    Err_type  = 'SED';
end

if ~exist('figsize', 'var') || isempty(figsize)
    figsize = [380 350];
end

% plot results
rng('default')
close all
fig = figure();
hold on
n_regions = size(decoding_results.region, 2);
[pp, nn] = deal(nan(1, n_regions));
for iregion = 1:5    

    data_real = decoding_results.region(iregion).results;
    data_shuf = decoding_results.region(iregion).permresults;
    swarmchart((3*iregion+1)*ones(1, size(data_real, 2)), 100*data_real,...
           4, [0.9 0.4 0.4], 'filled', 'MarkerFaceAlpha', 0.4,...
           'MarkerEdgeAlpha',0.2)
    swarmchart(3*iregion*ones(1, size(data_shuf,2)),...
        100*data_shuf, 4, [0.6 0.6 0.65], 'filled', 'MarkerFaceAlpha',...
        0.2, 'MarkerEdgeAlpha', 0.2)
           
    if iregion == 1
        legend({'real', 'shuffled'}, 'Autoupdate', 'off', 'Box', 'off') 
    end

    if strcmp(Err_type,'SED')
        errorbar(3*iregion+1, 100*mean(data_real), ...
            100*HumanOdorRep_std_error(data_real), 'kx');
        errorbar(3*iregion,   100*mean(data_shuf),...
            100*HumanOdorRep_std_error(data_shuf), 'kx');
    elseif strcmp(Err_type,'SD')
        errorbar(3*iregion+1, 100*mean(data_real), 100*std(data_real), 'kx');
        errorbar(3*iregion,   100*mean(data_shuf), 100*std(data_shuf), 'kx');
    end

    pp(iregion) = HumanOdorRep_calculate_percentile(data_shuf, mean(data_real));
    nn(iregion) = sum(data_shuf > mean(data_real));    
    HumanOdorRep_plot_sig_stars(3*iregion+1, pp(iregion),...
        max(100*data_real)+0.5, 0)
end
title(plot_title)
ax            = gca;
ax.XTick      = 3.5:3:17;
ax.XTickLabel = region_names;

xlim([2, 17]);
if exist('y_limits', 'var') && ~isempty(y_limits)
    ylim(y_limits);
end
ylabel('Decoding accuracy [%]');
set(findall(fig, '-property', 'FontSize'), 'FontSize', 18);
set(findall(fig, '-property', 'LineWidth'), 'LineWidth', 2);
yline(100/16, '--')
fig.Position = [0 0 figsize(1) figsize(2)];
exportgraphics(fig, strcat(save_path, filesep, plot_name, '.pdf'),...
    'ContentType', 'vector')

%% print stats
fprintf('\nDecoding performance based on neuronal activity in different regions.\n\n')     
fprintf('Each red dot shows the decoding performance based on 200 randomly drawn neurons (%i subsampling runs).\n',numel(data_real))
fprintf('The mean decoding performance and SEM across all subsampling runs is shown in black.\n')
fprintf('Grey dots indicate decoding performance on label permuted data.\n')
fprintf('The dashed horizontal line indicates chance level (6.25 %%).\n')
fprintf('Significance estimated based on percentile of mean decoding performance of the real data in the surrogate distribution: \n\n')
for iregion=1:5
    fprintf('%s: P<%.2G; ', region_names{iregion}, pp(iregion))
end
fprintf('\n \n')

end