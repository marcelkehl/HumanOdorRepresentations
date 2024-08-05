%-----------------------------------------------------------------------------------------
% Plot piriform neuron responding to the image of garlic
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   5b
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% laod data
data_path     = fullfile(fileparts(fileparts(pwd)), 'Data');
load(fullfile(data_path, 'Fig-5-b-PC-img-modulated-neuron.mat'))
addpath(fullfile(fileparts(pwd), 'Helper')) % add path to helper tools 
load(fullfile(data_path, 'odor_names.mat'));
load(fullfile(data_path, 'odor_colors.mat'));

% plot image-modulated neuron
fig = figure();

% plot raster
subplot(4, 3, 4:12)
hold on
% stim sorted in raster according to firing rate
pseudo_stim_ids = repmat(1:16,8,1);
raster = HumanOdorRep_plot_raster(sorted_trials, plot_int,...
            pseudo_stim_ids(:), odor_colors(idx_fr_sorted, :));
raster.Children(1).Color = [0.5 0.5 0.5 0.5];

% add image labels to axis
ax = gca;
ax.YTick      = 1/32:1/16:31/32;
ax.YTickLabel = flip(stimnames(idx_fr_sorted));
x = zeros(size(ax.YTick))-650;
text(x, ax.YTick, ax.YTickLabel, 'HorizontalAlignment', 'right',...
    'Color', [0.3 0.3 0.35]);

for ii=1:16
    text(-520, ax.YTick(end+1-ii), '\bullet', 'HorizontalAlignment',...
         'right', 'Color', odor_colors(idx_fr_sorted(ii),:));
end
set(ax.XAxis, 'Visible', 'on');
set(ax.YAxis, 'Visible', 'off');
xlabel('t [ms]');      
ax.XColor = [0.3 0.3 0.35];

% get position for spike density plot
ax.PositionConstraint = 'outerposition';
ax.PositionConstraint = 'outerposition';
ax.Position           = ax.Position .* [2.2 1.0 0.85 1];

% plot spike density plot
splot = subplot(4,3,2:3);
hold on;
cba          = HumanOdorRep_density_plot(spike_shapes);
ax2          = gca;
ax2.Position = ax2.Position .* [1.05 1.05 0.7 0.65];
hold off               
title('PC image response')

% save figure
set(findall(fig, '-property', 'FontSize'), 'FontSize', 14);
set(findall(ax, '-property', 'LineWidth'), 'LineWidth', 2);
fig.Position = [0 0 300 480];
exportgraphics(fig, fullfile(fileparts(fileparts(pwd)), 'Figures',...
    'Fig-5-b-PC-img-modulated-neuron.pdf'), 'ContentType', 'vector')

% calculate stats 

% image timing
response_intervall_img  = [ 0     1000 ];
bsl_intervall_img       = [ -500     0 ]; 

% calculate response firing rate for all trials 
[~, ~, count_resp] =  HumanOdorRep_firing_rate(sorted_trials,...
    response_intervall_img(1), response_intervall_img(2));
                   
% calculate baseline firing rate for all trials 
[~, ~, count_bsl]  = HumanOdorRep_firing_rate(sorted_trials,...
    bsl_intervall_img(1), bsl_intervall_img(2));
                            
% calculate z-values of the firing rates for each trial
z_fr_resp = ((count_resp     / abs(diff(response_intervall_img)/1000)) - ...
              mean(count_bsl / abs(diff(bsl_intervall_img)/1000))) / ... 
             (std(count_bsl) / abs(diff(bsl_intervall_img)/1000));

[pp, tbl_img_anova] = anova1(z_fr_resp, pseudo_stim_ids(:), 'off');
  
fprintf('\n\nExample of an image-modulated neuron in the human PC.\n')
fprintf('One-way ANOVA of z-scored firing rates with odor identity F(%i,%i)=%.2f, P=%.2G\n',...
        tbl_img_anova{2,3},tbl_img_anova{3,3},tbl_img_anova{2,5},pp)
