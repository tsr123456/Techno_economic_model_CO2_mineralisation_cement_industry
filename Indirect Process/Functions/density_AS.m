%%---------------------------% Density Amoniums Sulfate%-----------------%%
%This function calculates the density of aqueos amoniums sulfate
% input conc in Mol/l
% Limits: 1-40 Mol /l
% Output density in g/cm3 or t/m3
%Reference:https://www.engineeringtoolbox.com/density-aqueous-solution-inorganic-salt-acid-concentration-d_1958.html

function [density] = density_AS(conc)
       b =      0.9945;
       m =      0.0771;
       n =      0.8463;      
        
       density = m.*conc.^n+b;
end

