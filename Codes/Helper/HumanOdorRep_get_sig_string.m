function sigstring= HumanOdorRep_get_sig_string(p)
% function to get significance stars depending on provided p value
%-----------------------------------------------------------------------------------------
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------

if ~isnumeric(p)
    error('No numeric input provided!')
end

if numel(p)==1
   if p>=0.05
       sigstring = 'n.s.';
   elseif p >= 0.01
       sigstring = '*';
   elseif p < 0.01  && p >= 0.001
       sigstring = '**';
   elseif p < 0.001 && p >= 0.0001
       sigstring = '***';
   elseif p < 0.0001
       sigstring = '****';
   end
end

end