
function   [] = HumanOdorRep_plot_multimodal_neuron(unitdata, data_path, save_path)
% function [] = HumanOdorRep_plot_multimodal_neuron(unitdata, data_path, save_path)
%
%-----------------------------------------------------------------------------------------
% Plot function for multimodal neurons
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

% Number of stimuli per modality
Nstim      = 16;

% plot colors (smell, images, words)
plot_color = [[162,195,234]; [239,171,182]; [149,221,186]]/255;

% timing: response intervals
response_interval_words = [0 1000];
response_interval_img   = [0 1000];
response_interval_smell = [0 2000];
bsl_interval            = [-2000 0];
raster_time_axis         =  -500:2000;

%% plot results 
h1  = figure('visible', 'on');
set(h1, 'PaperUnits', 'centimeters');
set(get(gca,'Title'), 'Visible','on');

% preallocate variables
[fr_resp_smell, fr_resp_img, fr_resp_words,...
 bls_fr_resp, sd_fr_resp, pval_smell, pval_word, pval_img,...
 z_fr_img, z_fr_words, z_fr_smell] = deal(nan(1,Nstim));
                            
for stim_idx = 1:Nstim
    % get current stimulus info and trails

    % smell
    temp_trial_idx_smell  = unitdata.smell.stimID == stim_idx;
    temp_trials_smell     = unitdata.smell.trial(temp_trial_idx_smell);
    
    % image
    temp_trial_idx_img    = unitdata.img.stimID == stim_idx;
    temp_trials_img       = unitdata.img.trial(temp_trial_idx_img);

    % words
    temp_trial_idx_words  = unitdata.word.stimID == stim_idx;
    % for words exclude trials where words match the target odor
    temp_trial_idx_identification = temp_trial_idx_smell(65:128);
    % 16x4x4=256 presentations (odors, trials, words/trial)
    temp_trial_idx_identification_words_with_target_smell = ...
                               reshape(repmat(temp_trial_idx_identification,4,1),1,256);
    % discard word trials with target odor
    temp_trials_words = unitdata.word.trial(temp_trial_idx_words & ...
                            ~temp_trial_idx_identification_words_with_target_smell);
    
    % plot raster for target stimulus (e.g., banana)
    if strcmpi(unitdata.targetstimname, unitdata.stimnames(stim_idx))
        
        % plot odor icon
        subplot(5,4,1);
        A = imread(fullfile(data_path, [unitdata.targetstimname '_smell.png']));
        imshow(A);
        title('Odor');
        aa   = gca;
        aa.Position = aa.Position .* [1.0 1.0 1.2 1.2];
        
        % plot odor raster and PSTH
        subplot(5,4,5);
        hold on
        HumanOdorRep_plot_raster(temp_trials_smell, raster_time_axis);
        aa   = gca;
        aa.Position = aa.Position .* [1.0 1.0 1.1 1.2];
        hold off
        subplot(5,4,9);
        bar(min(raster_time_axis)+50:100:max(raster_time_axis)-50,...
            histcounts(vertcat(temp_trials_smell{:}),...
            min(raster_time_axis):100:max(raster_time_axis)),...
            'FaceColor',plot_color(1,:),'EdgeColor',plot_color(1,:));
        ax(1) = gca;
        ax(1).Position = ax(1).Position .* [1.0 1.07 1.1 1];
        box off
        xlabel('t [ms]');
        ylabel('N');
        
        % plot image
        subplot(5,4,2);
        A = imread(fullfile(data_path, [unitdata.targetstimname '_img.png']));
        imshow(A);
        title('Image');
        aa   = gca;
        aa.Position = aa.Position .* [1.0 1.0 1.2 1.2];
        
        % plot image raster and PSTH
        subplot(5,4,6);
        hold on
        HumanOdorRep_plot_raster(temp_trials_img, raster_time_axis);
        aa   = gca;
        aa.Position = aa.Position .* [1.0 1.0 1.1 1.2];
        hold off
        subplot(5,4,10);
        bar(min(raster_time_axis)+50:100:max(raster_time_axis)-50, ...
            histcounts(vertcat(temp_trials_img{:}), ...
            min(raster_time_axis):100:max(raster_time_axis)),...
            'FaceColor', plot_color(2,:), 'EdgeColor', plot_color(2,:));
        ax(3) = gca;
        ax(3).YAxis.Visible = 'off'; 
        ax(3).Position = ax(3).Position .* [1.0 1.07 1.1 1];
        box off
        
        % plot written name
        subplot(5,4,3);
        A = imread(fullfile(data_path,[unitdata.targetstimname '_word.png']));
        imshow(A);
        title('Name');
        aa   = gca;
        aa.Position = aa.Position .* [1.0 1.0 1.2 1.2];
        
        % plot word raster and PSTH
        subplot(5,4,7);
        hold on
        HumanOdorRep_plot_raster(temp_trials_words, raster_time_axis);
        aa   = gca;
        aa.Position = aa.Position .* [1.0 1.0 1.1 1.2];
        hold off
        subplot(5,4,11);
        bar(min(raster_time_axis)+50:100:max(raster_time_axis)-50, ...
            histcounts(vertcat(temp_trials_words{:}), ...
            min(raster_time_axis):100:max(raster_time_axis)),...
            'FaceColor', plot_color(3,:), 'EdgeColor', plot_color(3,:));
        ax(2) = gca;
        ax(2).YAxis.Visible = 'off';
        ax(2).Position = ax(2).Position .* [1.0 1.07 1.1 1];
        box off
        
        % align axis
        HumanOdorRep_sync_axes_limits(h1,ax);
    end

    % calculate response firing rates for smells, images and words
    fr_resp_smell(stim_idx) = HumanOdorRep_firing_rate(temp_trials_smell,...
                                                        min(response_interval_smell),...
                                                        max(response_interval_smell));
    fr_resp_img(stim_idx)   = HumanOdorRep_firing_rate(temp_trials_img,...
                                                        min(response_interval_img),...
                                                        max(response_interval_img));
    fr_resp_words(stim_idx) = HumanOdorRep_firing_rate(temp_trials_words,...
                                                        min(response_interval_words),...
                                                        max(response_interval_words));
    % get common baseline firing rate
    [bls_fr_resp(stim_idx), sd_fr_resp(stim_idx)] = ...
                              HumanOdorRep_firing_rate(unitdata.smell.trial,...
                              min(bsl_interval),max(bsl_interval));
                                                   
    % stats: calculate ranksum between response and baseline                         
    pval_smell(stim_idx)    = HumanOdorRep_ranksum(temp_trials_smell, unitdata.smell.trial,...
                                                    response_interval_smell,bsl_interval);
    pval_word(stim_idx)     = HumanOdorRep_ranksum(temp_trials_words, unitdata.smell.trial,...
                                                    response_interval_words,bsl_interval);
    pval_img(stim_idx)      = HumanOdorRep_ranksum(temp_trials_img,   unitdata.smell.trial,...
                                                    response_interval_img,bsl_interval);
                                                
    % calculate z-scored firing rate                                  
    z_fr_img(stim_idx)      = (fr_resp_img(stim_idx)-bls_fr_resp(stim_idx)) ...
                                / (sd_fr_resp(stim_idx));
    z_fr_words(stim_idx)    = (fr_resp_words(stim_idx)-bls_fr_resp(stim_idx)) ...
                                / (sd_fr_resp(stim_idx));
    z_fr_smell(stim_idx)    = (fr_resp_smell(stim_idx)-bls_fr_resp(stim_idx)) ...
                                / (sd_fr_resp(stim_idx));
end

% plot response strength (barplot)
% combine all z scores bar plot
all_zvalues = [z_fr_smell; z_fr_img; z_fr_words];
subplot(5,4,13:20)
b = bar(all_zvalues');
for ii = 1:3 
   b(ii).FaceColor = plot_color(ii,:);
   b(ii).EdgeColor = plot_color(ii,:);
end

% print p-values and add sig stars to bar plot
for istim = 1:Nstim
    fprintf('%s:  P(odor)=%.2g; P(image)=%.2g; P(name)=%.2g;\n',...
      unitdata.stimnames{istim},pval_smell(istim),pval_img(istim),pval_word(istim))
    
    if pval_smell(istim)<0.05
        HumanOdorRep_plot_sig_stars_single(b(1).XEndPoints(istim)+0.06,...
            pval_smell(istim),b(1).YEndPoints(istim),1,1);
    end
    if pval_img(istim)<0.05
        HumanOdorRep_plot_sig_stars_single(b(2).XEndPoints(istim)+0.06,...
            pval_img(istim),  b(2).YEndPoints(istim),1,1);
    end
   if pval_word(istim)<0.05
        HumanOdorRep_plot_sig_stars_single(b(3).XEndPoints(istim)+0.06,...
            pval_word(istim), b(3).YEndPoints(istim),1,1);
    end
end

legend(["odor", "image", "name"], "Location", 'northwest')
ylabel('z-score (FR)');
ax            = gca;
ax.XTick      = 1:Nstim;
ax.XTickLabel = unitdata.stimnames;
if strcmpi('licorice', unitdata.targetstimname)
    ylim([-3,24])
end

set(gca, 'color', 'none');
hold off;

% show spike density plot
subplot_axix  = subplot(5,4, [4,8]);
set(subplot_axix, 'position', get(subplot_axix, 'position') + [0,0,0,-0.1])
hold on;
HumanOdorRep_density_plot(unitdata.spikeshapes);
if strcmp(unitdata.targetstimname, 'banana')
    title('Am');
    figpanel  = 'g';
elseif strcmp(unitdata.targetstimname, 'licorice')
    title('PC');
    figpanel  = 'h';    
end
    
aa           = gca;
aa.Position  = aa.Position .* [1.05 0.9 1.1 0.9];
hold off;

% save plot
h1.Position  = [0 0 1050 600];
set(findall(h1,'-property','FontSize'), 'FontSize',12);
set(findall(h1,'-property','LineWidth'),'LineWidth',1);
h1.Position  = [0 0 600 470];

% save figure
exportgraphics(h1,fullfile(save_path,...
               strcat('Fig-5-',figpanel,'-',unitdata.targetstimname,'-neuron.pdf')),...
               'ContentType','vector')
end