function    [cba] = HumanOdorRep_density_plot(spikes, idx)
%% function [cba] = HumanOdorRep_density_plot(spikes, idx)
%
% function to visualize the spike density of single neurons 
% based on individual action potentials 
%
% Inputs:
%
% spikes - Number of spikes x 64 time bins
%          spike voltages in muV
%          time stamps sampled at 32,768 Hz
%
% idx    - (optional) index of the spikes included in the cluster
%
% function adopted code segments from Thomas P. Reber & Simon Kornblith
%
%-----------------------------------------------------------------------------------------
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------
%
%

% select spikes
if ~exist('idx', 'var')
    wavs = spikes;
else
    wavs = spikes(idx,:);
end

% define time axis using data sampling rate (32,768 Hz)
xvals = (-19:44)*1000/(2^15);

% generate a 2D histogram
lbound     = floor(min(min(wavs)));       % Lowest point of the figure
ubound     = ceil(max(max(wavs)));        % Highest point of the figure
vps        = size(spikes,2);              % Values per spike after interpolation.
ybins      = linspace(lbound,ubound,150); % Vector of bins in vertical direction
ybinSize   = ybins(2)-ybins(1);           % Size of a bin in vertical direction
numXbins   = vps;                         % Number of bins in horizontal direction
numYbins   = length(ybins);               % Number of bins in vertical direction
n          = zeros(numXbins,numYbins);    % Preallocate 2D histogram

% get bin counts
for k = 1:numXbins
    for j = 1:numYbins
        n(k,j)= sum (wavs(:,k) <= ybins(j)+ybinSize/2 & wavs(:,k) > ybins(j)-ybinSize/2);
    end
end

% normalize to maximum
n = n./max(n(:));

% exclude extreme outliers
cutoff      = 5*std(reshape(n,numel(n),1)); % cutoff for too high bin values
n(n>cutoff) = cutoff;                       % replace outliers with cutoff

% plot spike density
pcolor(xvals, ybins, n');
shading interp

% define colormap (blue to white)
blue_colormap      = zeros(100,3);
blue_colormap(:,3) = 1:-0.006:0.4006;
blue_colormap(:,2) = [1:-0.01:0.01]';
blue_colormap(:,1) = [1:-0.01:0.01]';

% set axis limits
xlim([-0.625 1.375]);
ylim([min(ybins) max(ybins)]);
ax      = gca;
ax.YLim = 0.9*ax.YLim;

% define axis ticks
xlabel('ms'); 
ylabel('\muV');
ax.XTick = [0,1];
if max(ax.YTick)>0
    ax.YTick = [0 max(ax.YTick)];
end

% show color bar
colormap(blue_colormap)
cba = colorbar;

% overlay density plot with mean spike shape & SD
hold on 
plot(xvals,mean(wavs,1),'color',[1 1 1],'Linewidth',0.3)
plot(xvals,mean(wavs,1)+std(wavs,1),'color',[1 1 1],'Linestyle',':','Linewidth',0.3)
plot(xvals,mean(wavs,1)-std(wavs,1),'color',[1 1 1],'Linestyle',':','Linewidth',0.3)
ylabel(cba, 'Spike density', 'rotation', 90);
cba.Limits = [0 1];
cba.Ticks  = [0 1];
end