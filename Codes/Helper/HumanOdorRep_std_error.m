function stderror = HumanOdorRep_std_error(X)
% function stderror = HumanOdorRep_std_error(X)
% calcualte standard error for given data
%-----------------------------------------------------------------------------------------
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------
if sum(isempty(X))>0 
    error("Empty values for std error calculation")
end

if sum(isnan(X))>0 
    stderror = nanstd(X)/sqrt(sum(~isnan(X)));
else
    stderror = std(X)/sqrt(numel(X));
end

end