function h = HumanOdorRep_plot_raster(spikes, x, condition, plot_colors, linewidth)
%% function h = HumanOdorRep_plot_raster(spikes, x, condition, plot_colors,linewidth)
% creates raster plot of spike-times
% spikes is expected to be a cell array of vectors of spike-times
% per trial (e.g. spikes{trialnr} = [-199, 20, 25, 46...]
% x denotes the x-axis in time (same unit as spikes, most of the
% time : milliseconds)
%
% optional arguments for different colors
% condition:  vector with same length as spikes indicating the
% condition a trial belongs to (values should be ascending integers starting
% with 1)
% plot_colors: n by 3 array of rgb-color values, n=number of conditions
%
%-----------------------------------------------------------------------------------------
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

ntrials = length(spikes);
if ~exist('x', 'var') || isempty(x)
    warning(['will construct an x-axis based on earliest and latest ' ...
             'spike time-stamp in seconds']);
    mints = min([spikes{:}]);
    maxts = max([spikes{:}]);
    x = (floor(mints/100)*100): ...
        (ceil(maxts/100)*100);
    if isempty(x)
        x = -1000:2000;
    end
end
if ~exist('condition', 'var') || isempty(condition)
    condition = ones(1,ntrials);
end

if ~exist('plot_colors', 'var') || isempty(plot_colors)
    ncolors = length(unique(condition));
    if ncolors == 1
        plot_colors = [0 0 0];
    else
        if ncolors <= 7
            plot_colors = get(gca, 'colororder');
        else
            plot_colors = colormap('hsv');
            idx = 1:floor(size(plot_colors,1)/ ncolors):size(plot_colors,1);
            plot_colors = plot_colors(idx,:);
        end
    end
end
if ~exist('linewidth', 'var') || isempty(linewidth)
    linewidth = 1.2;
end

ucond = unique(condition); % to lookup color
dist_between = 1/ntrials;
line_height  = (3/5)*dist_between;
hold on
a = 1;
for t = 1:ntrials
    if ~isempty(spikes{t})
        %% plot spikes
        for j=1:length(spikes{t})
            line([spikes{t}(j) spikes{t}(j)],[a a-line_height], 'color', ...
                plot_colors(ucond == condition(t), :), 'LineWidth', linewidth);
        end
    end
    a = a - dist_between;
end

xlim([x(1) x(end)]);
plot([0 0], [0 1], ':k');
box off
axis off

h = gca;
hold on;
end
