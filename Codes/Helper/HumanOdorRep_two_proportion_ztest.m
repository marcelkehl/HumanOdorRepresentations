function [p,Z]=HumanOdorRep_two_proportion_ztest(n1pos, n1, n2pos, n2)
% function [p,Z]=HumanOdorRep_two_proportion_ztest(n1pos, n1, n2pos, n2)
% calculate two-proportion z-test
%
%-----------------------------------------------------------------------------------------
% Kehl et al. 2024 (DOI:XX)
% Single-Neuron Representations of Odors in the Human Brain
% Author:  Marcel Kehl
% License: MIT License
%-----------------------------------------------------------------------------------------
    p1 =  n1pos/n1;
    p2 =  n2pos/n2;
    p  = (n1pos+n2pos)/(n1+n2); % population mean 
    Z  = (p1-p2)/sqrt(p*(1-p)*(1/n1+1/n2));
    p  =  min(2*normcdf(-abs(Z)),1);
end