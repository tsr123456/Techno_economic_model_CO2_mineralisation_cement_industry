%%---------------------------% Density Magnesium Sulfate%-----------------%%
%This function calculates the density of aqueos Magnesium sulfate
% input conc in wt%
% Limits: conc 1-26 % Temp in °C = 0-80°C
% Output density in g/cm3 or t/m3
% Reference: https://handymath.com/cgi-bin/mgsulftble.cgi?submit=Entry

function [density] = density_MS(conc_wtpercent,temp)
        
conc_wt_percent = conc_wtpercent*100;% transfrom from 0.X into X%
       p00 =      0.9943;
       p10 =   -0.001323;
       p01 =    0.003697;
       
       density = p00 + p10.*conc_wtpercent + p01.*temp;
end

