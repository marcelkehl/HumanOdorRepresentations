%-----------------------------------------------------------------------------------------
% Plot firing rate of odor-modulated neurons to liked vs. disliked odors
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   4d
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% laod data
data_path     = fullfile(fileparts(fileparts(pwd)), 'Data');
load(fullfile(data_path, 'Fig-4-d-liked-vs-disliked.mat'))
region_names   = {'PC','Am','EC','Hp','PHC'};
Nregions       = numel(region_names);
color_liked    = [0.15 0.85 0.15];
color_disliked = [0.5  0.5  0.8];

% coord plot paired sample (liked vs. disliked)
fig = figure();
hold on
rng('default');
[ll, sstats ] = deal(cell(Nregions,1));
pp            = nan(1,Nregions);

for iregion = 1:Nregions
   % select neurons from target region
   tmp_idx = region_ids'== iregion;

   %firing rates in this region
   z_fr_liked    = z_fr_liked_vs_disliked(tmp_idx, 1);
   z_fr_disliked = z_fr_liked_vs_disliked(tmp_idx, 2);
   % plot data points
   swarmchart(ones(1, numel(z_fr_liked))*((iregion-1)*5+1),...
              z_fr_liked, 20, color_liked, 'filled',...
              'MarkerFaceAlpha', 0.4, 'MarkerEdgeAlpha', 0.8, 'XJitter', 'none')
   
   swarmchart(ones(1,numel(z_fr_disliked))*(5*(iregion-1)+2),...
              z_fr_disliked, 20, color_disliked, 'filled',...
              'MarkerFaceAlpha', 0.8, 'MarkerEdgeAlpha', 0.9, 'XJitter', 'none')
  
   if iregion == 1
      legend(["liked", "disliked"], "Autoupdate", "off", 'Box', 'off');
   end
   
   % plot bars
   bar((iregion-1)*5,  mean(z_fr_liked), 'FaceColor', 'none',...
       'Edgealpha',0.7,'EdgeColor',color_liked)
   bar((iregion-1)*5+3,mean(z_fr_disliked),'FaceColor','none',...
       'Edgealpha',0.7,'EdgeColor',color_disliked)
   
   % connect paired data points 
   ll{iregion} = line([ones(1,numel(z_fr_liked))'*((iregion-1)*5+1),...
                       ones(1,numel(z_fr_disliked))'*(5*(iregion-1)+2)]',...
                       z_fr_liked_vs_disliked(tmp_idx,:)',...
                       'color', [0.5 0.5 0.5 0.4], 'linewidth', 0.5);
  
   % plot error bars
   errorbar((iregion-1)*5,  mean(z_fr_liked),...
       HumanOdorRep_std_error(z_fr_liked),...
       'k.', 'color', color_liked,   'MarkerSize', 24);
   
   errorbar((iregion-1)*5+3,mean(z_fr_disliked),...
       HumanOdorRep_std_error(z_fr_disliked),...
       'k.', 'color', color_disliked, 'MarkerSize', 24);
   
   % sign-rank test liked vs. disliked
   [pp(iregion), ~, sstats{iregion}] = signrank(z_fr_liked, z_fr_disliked);
   ylabel('z-score (FR)');
  
   % plot sig stars
   HumanOdorRep_plot_sig_stars([((iregion-1)*5), ((iregion-1)*5+3)],...
       pp(iregion), 3.2, 0.1)
end

% plot settings
ax            = gca;
ax.XTick      = 1.5:5:21.5;
ax.XTickLabel = region_names;
title('Liked vs. disliked odors')
ylim([prctile(z_fr_liked_vs_disliked(:), 2.5), ...
      prctile(z_fr_liked_vs_disliked(:), 97.5)])
  
set(findall(fig, '-property', 'FontSize'), 'FontSize', 18);
set(findall(fig, '-property', 'LineWidth'), 'LineWidth', 2);
for ii=1:5
    set(ll{ii}, 'LineWidth', 0.3);
end
yline(0,'--')
fig.Position = [0 0 440 430];

% save figure
exportgraphics(fig, fullfile(fileparts(fileparts(pwd)), 'Figures', ...
               'Fig-4-d-liked-vs-disliked.pdf'), 'ContentType', 'vector')

% print stats
fprintf('\n\nFiring rates (z-values) of odor-modulated neurons in response to liked vs. disliked odors across regions.\n')
fprintf('A significant difference based on participant preference (liked vs. disliked) was only observed\n')
fprintf('for odor-modulated neurons in the amygdala. Wilcoxon signed rank:\n')
for iregion = 1:5
    fprintf('%s: N=%i, Z=%.2G, P=%.2G;\n', region_names{iregion},...
        sum(region_ids'== iregion & mean(z_fr_liked_vs_disliked,2)),...
        sstats{iregion}.zval, pp(iregion))
end
fprintf('\n\n')