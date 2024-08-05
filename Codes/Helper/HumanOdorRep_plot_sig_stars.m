function HumanOdorRep_plot_sig_stars(pair, p, yheight, deltay)
% function to add sig stars to a barplot
%-----------------------------------------------------------------------------------------
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

    % get string
    if p <= 1E-4
        stars='****'; 
    elseif p <= 1E-3
        stars='***'; 
    elseif p <= 1E-2
        stars='**';
    elseif p <= 0.05
        stars = '*';
    elseif isnan(p)
        stars = 'n.s.';
    else
        stars = '';
    end

    % plot line
    line(pair, [yheight, yheight], 'color', [0, 0, 0])
    % draw text
    text(mean(pair), yheight+deltay, stars, 'FontWeight', 'bold',...
        'HorizontalAlignment', 'center')
end
