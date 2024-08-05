function pp = HumanOdorRep_calculate_percentile(data, value)
%-----------------------------------------------------------------------------------------
% Estimates p value based on the percentile in the data distribution
%
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------
    data       = data(:)';
    value      = value(:);
    
    nhigher    = sum(data > value, 2);
    nequal     = sum(data == value, 2);
    
    nlower     = sum(data < value, 2);
    percentile = (nlower+ 0.5.*nequal)/length(data);
    
    % calculate a conservative p-value based on the percentile
    % p = (1-percentile) + 1/length(data)
    pp  = (nhigher + 0.5.*nequal + 1) / length(data); 
end