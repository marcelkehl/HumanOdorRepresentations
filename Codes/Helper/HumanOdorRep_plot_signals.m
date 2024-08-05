function    [h, f, ylimits] = HumanOdorRep_plot_signals(signals, x, plot_color, error_type)
%% function [h, f, ylimits] = HumanOdorRep_plot_signals(signals, x, plot_color, error_type)
%
% plots the mean and some error of signals stored in 2D array 
% rows: observations/trials/segments, columns: samples. 
%
% Optional arguments:
% x:          a custom x-axis (e.g. time in seconds), same length as there
%             are columns in signals
%
% plot_color: either a matlab-color string ('r', 'g', ... ) or a
%             vector with r-g-b values between 0 and 1 (e.g. [0.7 0.7 0.7])
% 
% error_type: string denoting displayed error: 'SD' or 'SEM', 


    if ~exist('x', 'var') || isempty(x)
        x = 1:size(signals,2);
    end
    assert(size(signals,2) == length(x));
    
    if ~exist('plot_color', 'var') || isempty(plot_color)
        plot_color = 'b';
    end
    
    if ~exist('error_type', 'var') || isempty(error_type)
        error_type = 'SEM';
    end
   
    error_types = {'SD','SEM'};
    if sum(strcmp(error_types, error_type)) < 1
        error(['Please choose one of the following error types ' ...
               'types:', sprintf('\n %s ', error_types{:})]);
    end
    
    % exclude nans
    nansigs = sum(isnan(signals),2) > 0;
    signals = signals(~nansigs,:);
    nsigs   = size(signals,1);
    
    if nsigs > 1        
        m   = mean(signals);
        sd  = std(signals);
        sem = sd./sqrt(nsigs);   
    else
        m   = signals;
        sem = zeros(1, size(signals, 2));
        sd  = zeros(1, size(signals, 2));
    end
    
    if strcmp(error_type, 'SEM')
        err = sem;
    elseif strcmp(error_type, 'SD')
        err = sd;
    end
    
    p_sem = m + err;
    n_sem = m - err;
        
    ylimits  = [floor(min(n_sem)), ceil(max(p_sem))];
    X        = [x, fliplr(x)];
    Y        = [p_sem, fliplr(n_sem)];
    f        = fill(X, Y, plot_color);
    
    alpha(0.25);   
    set(f, 'EdgeColor', 'none'),
    hold on
    h = plot(x, m, 'Color', plot_color);
    box off
end