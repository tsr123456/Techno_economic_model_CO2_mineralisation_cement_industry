%%---------------------------% Density Amoniums biSulfate%-----------------%%
%This function calculates the density of aqueos ABS
% input conc in Mol/l
% Limits: 1-10 Mol /l
% Output density in g/cm3 or t/m3
%https://pubs.acs.org/doi/pdf/10.1021/j150624a042
%https://pubs.acs.org/doi/10.1021/j150624a042

function [density] = density_ABS(conc)
 density = 0.99671 + (0.604706*10^-1).* conc - (0.108981*10^-2).*conc.^2 + (0.106394*10^-4).*conc.^3;
end
