%-----------------------------------------------------------------------------------------
% Plot Venn diagram of odor and image modulated neurons
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Figure   5c
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% clean workspace
clear; clc; close all;

% load data
data_path = fullfile(fileparts(fileparts(pwd)), 'Data');
load(fullfile(data_path, 'Fig-5-c-odor-image-venn.mat'));

p_crit            = 0.05;
N_sig_stimid_img  = sum([unitcount.n_IM_units]);
N_sig_stimid_odor = sum([unitcount.n_OM_units]);
N_cells           = sum([unitcount.n_units]);
N_sig_stimid_img_and_odor = sum([unitcount.n_IM_and_OM_units]);

% plot Venn diagram
fig=figure();
[H, S] = HumanOdorRep_venn([N_sig_stimid_odor/N_cells N_sig_stimid_img/N_cells],...
                            N_sig_stimid_img_and_odor/N_cells,'FaceColor',...
                            {[162,195,234]/255,[239,171,182]/255},'FaceAlpha',...
                            {0.6,0.6},'EdgeColor',[1 1 1]);
% add text to plot                  
text(0, 0, num2str(N_sig_stimid_odor - N_sig_stimid_img_and_odor),...
    'FontSize', 20, 'HorizontalAlignment', 'right')
text(S.Position(2,1), S.Position(2,2),...
    num2str(N_sig_stimid_img - N_sig_stimid_img_and_odor), 'FontSize',20)
text((S.Position(2,1)-S.Position(1,1))/2., S.Position(2,2),...
     num2str(N_sig_stimid_img_and_odor),'FontSize',20)
legend('Odor-modulated', 'Image-modulated', 'location', 'southoutside', 'FontSize',24)
set(findall(fig, '-property', 'FontSize'), 'FontSize', 24);
set(findall(fig, '-property', 'LineWidth'), 'LineWidth', 0.001);
fig.Position = [0 0 470 420];
axis('off')
legend('boxoff')                                    
exportgraphics(fig,fullfile(fileparts(fileparts(pwd)), 'Figures',...
               'Fig-5-c-odor-image-venn.pdf'), 'ContentType', 'vector')

% derive statistics
p_odor  = HumanOdorRep_myBinomTest(N_sig_stimid_odor, N_cells, p_crit);
p_img   = HumanOdorRep_myBinomTest(N_sig_stimid_img,  N_cells, p_crit);
p_both  = HumanOdorRep_myBinomTest(N_sig_stimid_img_and_odor, N_cells,...
                                   N_sig_stimid_odor*N_sig_stimid_img/(N_cells*N_cells));

[pZ, Z] = HumanOdorRep_two_proportion_ztest(N_sig_stimid_odor, N_cells,...
                                            N_sig_stimid_img,  N_cells);

fprintf('\n\nPopulation of image- and odor-modulated neurons, and their intersection.\n')
fprintf('\nOnly neurons from recordings with a subsequent visual task were included.\n')
fprintf('In total, %i image-modulated neurons were identified.\n',...
        sum([unitcount(:).n_IM_units]))
fprintf('\n%i of %i units significantly modulated their firing in response to images.\n',... 
        N_sig_stimid_img, N_cells)
fprintf('This is a significant fraction following a two-sided Binomial test (P=%.2G) with N=%i, k=%i, and P(chance)=0.05.\n',...
        p_img, N_cells, N_sig_stimid_img)
fprintf('\n%i of %i units significantly modulated their firing in response to odors.\n',...
        N_sig_stimid_odor, N_cells)
fprintf('This is a significant fraction following a two-sided Binomial test (P=%.2G) with N=%i, k=%i, and P(chance)=0.05.\n',...
        p_odor, N_cells, N_sig_stimid_odor)
fprintf('\nThe proportion of odor-modulated neurons was significantly higher than image-modulated neurons\n')
fprintf('%i vs %i of %i, Two-proportions Z-test: Z=%.2G, P=%.2G\n', ...
        N_sig_stimid_odor, N_sig_stimid_img, N_cells, Z, pZ)

fprintf('\nBoth populations showed significant overlap with\n')
fprintf('%i of %i units significantly modulated their firing in response to both, odors and images.\n',...
        N_sig_stimid_img_and_odor,N_cells)
fprintf('This is a significant fraction following a two-sided Binomial test (P=%.2G) with N=%i, k=%i, and P(chance)=%.3G.\n',...
        p_both, N_cells, N_sig_stimid_img_and_odor, ...
        N_sig_stimid_odor*N_sig_stimid_img/(N_cells*N_cells))
fprintf('\nPC and amygdala contained significantly more odor-modulated than image-modulated neurons. Two-proportions Z-test:\n')
for iregion=1:5
    [pZ_temp, Z_temp] = HumanOdorRep_two_proportion_ztest(unitcount(iregion).n_OM_units, ...
        unitcount(iregion).n_units,unitcount(iregion).n_IM_units, unitcount(iregion).n_units);
    fprintf('%s:%i vs %i of %i, Z=%.2G, P=%.2G;\n', unitcount(iregion).region,...
        unitcount(iregion).n_OM_units,unitcount(iregion).n_IM_units,...
        unitcount(iregion).n_units, Z_temp,pZ_temp)                             
end
fprintf('\n\n')

p_img_pc = HumanOdorRep_myBinomTest(unitcount(1).n_IM_units, unitcount(1).n_units, 0.05);
fprintf('Remarkably, a significant fraction of PC neurons were image-modulated:\n')
fprintf('%i of %i neurons, P=%.2G, two-sided Binomial test\n\n', ...
        unitcount(1).n_IM_units, unitcount(1).n_units, p_img_pc)
    