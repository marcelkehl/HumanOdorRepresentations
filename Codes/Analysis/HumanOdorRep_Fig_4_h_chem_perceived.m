%-----------------------------------------------------------------------------------------
% Plot decoding performance for chemical vs. perceived odor identity
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   4h
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% laod data
data_path     = fullfile(fileparts(fileparts(pwd)), 'Data');
load(fullfile(data_path, 'Fig-4-h-decoding-chemical-perceived.mat'))
region_names  = {'PC','Am','EC','Hp','PHC'};

% plot results 
pp = nan(5,1);
zz = cell(5,1);
rng('default')
fig = figure();
hold on
for iregion = 1:5
    chem_minus_perc = Decoding.region(iregion).ChemicalMinusPerceived;
    % plot swarm chart and bar plot with error for decoding
    swarmchart((2*iregion)*ones(1, numel(chem_minus_perc)),...
               100*chem_minus_perc, 14, [0.6 0.6 0.8], 'filled',...
               'MarkerFaceAlpha', 0.2, 'MarkerEdgeAlpha', 0.2)
           
    bar(2*iregion, 100*mean(chem_minus_perc), ...
        'FaceColor','none','Edgealpha',0.7,'Edgecolor',[0.1 0.1 0.3]);
    
    errorbar(2*iregion,100*mean(chem_minus_perc),...
                       100*HumanOdorRep_std_error(chem_minus_perc),'kx');
                   
    % print results
    [pp(iregion), ~, zz{iregion}] = signrank(chem_minus_perc);
    HumanOdorRep_plot_sig_stars(2*iregion, pp(iregion), 8.5, 0)
    fprintf('%s: %.2f chemical vs. %.2f perceived, Z=%.2g, P=%.2g; \n',...
        region_names{iregion}, 100*sum(chem_minus_perc>0)/numel(chem_minus_perc),...
        100*sum(chem_minus_perc<0)/numel(chem_minus_perc),...
        zz{iregion}.zval, pp(iregion))
end

title('Chemical odor identity vs. \newline subjective odor percept')
ax            = gca; 
ax.XTick      = 2:2:10; xlim([1,11]);
ax.XTickLabel = region_names;
all_values    = vertcat(Decoding.region(:).ChemicalMinusPerceived);
ylim([prctile(100*all_values(:), 0.05), prctile(100*all_values(:), 99.95)]);
ylabel('Decoding accuracy [%] \newline chemical - perceived');
set(findall(fig,'-property','FontSize'),'FontSize',18);
set(findall(fig,'-property','LineWidth'),'LineWidth',2);
yline(0,':')
fig.Position = [0 0 280 330];

% save figure
exportgraphics(fig,fullfile(fileparts(fileparts(pwd)),'Figures',...
    'Fig-4-h-decoding-chemical-perceived.pdf'),'ContentType','vector')
fprintf('\n \n')