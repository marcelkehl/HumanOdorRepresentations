%-----------------------------------------------------------------------------------------
% Compare firing rates of odor-modulated neurons in response to actual odor
% vs. odorless control
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   1i
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% laod data
data_path = fullfile(fileparts(fileparts(pwd)), 'Data'); 
load(fullfile(data_path, 'Fig-1-i-odor-vs-odorless-control.mat'))
region_names = {'PC', 'Am', 'EC', 'Hp', 'PHC'};

% coord plot paired sample
fig = figure();
hold on
n_regions = size(region_names, 2);
pp        = nan(1, n_regions);

fprintf('Odor vs odorless control:\n \n')
ll          = cell(1, n_regions);
zz_template = struct('zval', [], 'signedrank', []);
zz          = repmat(zz_template, 1, 5);

for iregion = 1:n_regions
   
   % get units in region
   tmp_idx = region_idx == iregion' & ...
             ~isnan(mean(z_fr_odor_and_neurtral, 2))';% nan 1st session without control

   % odors
   swarmchart(ones(1, sum(tmp_idx))*((iregion-1)*5+1),...
       z_fr_odor_and_neurtral(tmp_idx, 1), 20, [0.4, 0.4, 1], 'filled',...
       'MarkerFaceAlpha', 0.4, 'MarkerEdgeAlpha', 0.8, 'XJitter', 'none')
   
   % odorless control
   swarmchart(ones(1,sum(tmp_idx,2))*((iregion-1)*5+2),...
       z_fr_odor_and_neurtral(tmp_idx, 2), 20, [0.5, 0.5, 0.5], 'filled',...
       'MarkerFaceAlpha', 0.8, 'MarkerEdgeAlpha', 0.9, 'XJitter', 'none')
   
   if iregion == 1
      legend(["odor", "control"], "Autoupdate", "off", 'Location', 'southeast')
   end
   
   bar((iregion-1)*5,   mean(z_fr_odor_and_neurtral(tmp_idx, 1)),...
       'FaceColor', 'none', 'Edgealpha', 0.7, 'EdgeColor', [0.4, 0.4, 1])
   
   bar((iregion-1)*5+3, mean(z_fr_odor_and_neurtral(tmp_idx, 2)),...
       'FaceColor', 'none', 'Edgealpha', 0.7, 'EdgeColor', [0.5, 0.5, 0.5])
   
   % connect matched samples by lines
   ll{iregion} = line([ones(1, sum(tmp_idx))'*((iregion-1)*5+1),...
                       ones(1,sum(tmp_idx))'*(5*(iregion-1)+2)]',...
                       z_fr_odor_and_neurtral(tmp_idx, :)',...
                       'color', [0.5, 0.5, 0.5, 0.4],'linewidth',0.5);
   % add error bars                
   errorbar((iregion-1)*5,  mean(z_fr_odor_and_neurtral(tmp_idx, 1)),...
       HumanOdorRep_std_error(z_fr_odor_and_neurtral(tmp_idx, 1)), 'k.',...
       'color', [0.4, 0.4, 1], 'MarkerSize', 20);
   
   errorbar((iregion-1)*5+3,mean(z_fr_odor_and_neurtral(tmp_idx, 2)),...
       HumanOdorRep_std_error(z_fr_odor_and_neurtral(tmp_idx, 2)), 'k.',...
       'color', [0.5 0.5 0.5], 'MarkerSize', 20);
   
   % calculate sign-rank test
   [pp(iregion), ~, zz(iregion)] = ...
       signrank(z_fr_odor_and_neurtral(tmp_idx, 1),...
       z_fr_odor_and_neurtral(tmp_idx, 2));
   ylabel('z-score (FR)');
   
   % add sig stars
   HumanOdorRep_plot_sig_stars([((iregion-1)*5), ((iregion-1)*5+3)],...
       pp(iregion), 2.6, 0.1)
end

ax            = gca; 
ax.XTick      = 1.5:5:21.5; 
ax.XTickLabel = region_names;
title('Odor vs. odorless control')
ylim([prctile(z_fr_odor_and_neurtral(:), 2.5),...
    prctile(z_fr_odor_and_neurtral(:), 97.5)])
set(findall(fig, '-property', 'FontSize'), 'FontSize', 18);
set(findall(fig, '-property', 'LineWidth'), 'LineWidth', 2);
for ii=1:5
    set(ll{ii}, 'LineWidth', 0.3);
end
yline(0, '--')
fig.Position = [0, 0, 420, 370];

% save figure
exportgraphics(fig, fullfile(fileparts(fileparts(pwd)), 'Figures',...
    'Fig-1-i-odor-vs-odorless-control.pdf'), 'ContentType', 'vector')

% print stats
fprintf(['\nIn PC, Am, EC and Hp firing rates in response to odors',...
    'were significantly higher than for the odorless controls:\n'])
for iregion = 1:n_regions
    n_units = sum(region_idx == iregion' &...
                  ~isnan(mean(z_fr_odor_and_neurtral,2))');
    fprintf('%s: N=%i, Z=%.2g, P=%.2g;\n',...
            region_names{iregion}, n_units, zz(iregion).zval, pp(iregion));
end

[pcontrol, ~, zcontrol] =  signrank(z_fr_odor_and_neurtral(:, 2),...
                           0, 'tail', 'right');
Nunits =  sum(~isnan(mean(z_fr_odor_and_neurtral, 2)));
fprintf(['\nSniffing odorless air alone induced an increase in firing',...
    ' of odor-modulated units \n(N=%i, Z=%.2g, P=%.2g, one-sided ',...
    'Wilcoxon signed-rank).\n'], Nunits, zcontrol.zval, pcontrol)
    
[pall, ~, zall] = signrank(z_fr_odor_and_neurtral(: ,1),...
                           z_fr_odor_and_neurtral(:, 2));
fprintf(['\nOdor-modulated units exhibited significantly higher firing',...
    'rates\nin response to actual odors vs control:\nN=%i, Z=%.2g, ',...
    'P=%.2g; \n \n '], Nunits, zall.zval, pall)
