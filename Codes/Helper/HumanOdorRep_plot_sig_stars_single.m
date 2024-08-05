function tx= sniff_plot_sig_stars_single(x,p,yhight,deltay,rotate)
% function tx= sniff_plot_sig_stars_single(x,p,yhight,deltay,rotate)
% function to add sig stars to a bar plot
%-----------------------------------------------------------------------------------------
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------


    % get string
    if p<=1E-4
         stars='****'; 
    elseif p<=1E-3
        stars='***'; 
    elseif p<=1E-2
        stars='**';
    elseif p<=0.05
        stars='*';
    elseif isnan(p)
        stars='n.s.';
    else
        stars='';
    end
    
    % draw text
    if ~exist('rotate', 'var') || isempty(rotate)
        tx=text(x, yhight+deltay,stars, 'FontWeight', 'bold', 'HorizontalAlignment', 'right');
    elseif rotate ==1
        tx=text(x, yhight+deltay,stars, 'FontWeight', 'bold',...
         'HorizontalAlignment', 'center', 'Rotation', 90);
    end
end
