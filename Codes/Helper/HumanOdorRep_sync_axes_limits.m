function HumanOdorRep_sync_axes_limits(figurehandle, axishandles, ylimits,xlimits, ...
                          do_zero_x, do_zero_y)
%% function HumanOdorRep_sync_axes_limits(figurehandle, axishandles, ylimits,xlimits, ...
%%                          do_zero_x, do_zero_y)
% takes a figure handle (figurehandle = gcf) and multiple
% axishandels from e.g. subplots (axishandles(i) = gca), and makes all
% y- and x-limits of the same according to the maximal y and x
% limits in all axes, or, if ylimits (e.g. ylimits = [-10 15]) and
% xlimits are provided, sets limits to these values
% if do_zero_x/y are set to true, will print zero lines over the entire
%  plot
verbose = false;
%% get the status quo
for i = 1:length(axishandles)
    try
        set(figurehandle,'CurrentAxes',axishandles(i))
        yl = ylim;
        xl = xlim;
    catch err
        yl = [0 1];
        xl = [0 1];
        
        if verbose
            warning('could not get axis handle');
        end
        
    end
    
    ylimits_(i,:) = yl;
    xlimits_(i,:) = xl;
    
end
xlimits_ = [min(xlimits_(:,1)) max(xlimits_(:,2))];
ylimits_ = [min(ylimits_(:,1)) max(ylimits_(:,2))];


%% set according to arguments provided (if present)
if ~exist('xlimits', 'var') || isempty(xlimits)
    xlimits = xlimits_;
end
if ~exist('ylimits', 'var') || isempty(ylimits)
    ylimits = ylimits_;
end

for i = 1:length(axishandles)
    try        
        set(figurehandle,'CurrentAxes',axishandles(i))
        
        xlim(xlimits);
        ylim(ylimits);
        
        if do_zero_x
            plot([0 0],ylimits, ':k');
        end
        if do_zero_y
            plot([xlimits],[0 0], ':k');
        end
    catch err
        if verbose
            warning('resetting axis failed');
        end
    end
end
