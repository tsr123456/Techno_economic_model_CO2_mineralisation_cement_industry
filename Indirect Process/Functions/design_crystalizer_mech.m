%-----------------%% Design Crystalizer %%--------------------%
% The inputs for this function is the following:
%t_in_warm; temperature of warm stream in [°C]
%t_out_warm;temperature of warm stream in [°C]
%t_in_cold;temperature of cold stream in [°C]
%t_out_cold;temperature of cold stream in [°C]
%q; heating that needs to be transfered in [MW]
%k; heat transmission coefficient in [W/m2K]

%Output: Length in [m], area in [m2]

 
%% Calculation-------------------------------------------------------------

function [length_cry,area_cry] = design_crystalizer_mech (t_in_warm, t_out_warm,t_in_cold,t_out_cold,q,k)
  
    % radius crystalizer (24 inch -Aspen Icarus):
    radius = 0.3048; 
    %convert Temperatures to Kelvin:
    
    t_in_warm = t_in_warm + 273.15; %Input temperature in [K]
    t_out_warm =t_out_warm +273.15; %Output temperature in [K]
    t_in_cold = t_in_cold+273.15; % Input temperature cold stream in [K]
    t_out_cold = t_out_cold+273.15; %Standard temp in [K]
    
   %calculate logarithmic temperature difference: 
    if (t_in_warm-t_out_cold)==(t_out_warm -t_in_cold)
         log_dif_Temp = (t_in_warm-t_out_cold);
    else
         log_dif_Temp = (((t_in_warm-t_out_cold) - (t_out_warm -t_in_cold))/(log((t_in_warm-t_out_cold)/(t_out_warm -t_in_cold))));
    end
        
 % derive area for heat exchanger   
    area_cry = abs(q*1000 / (k*log_dif_Temp));% Q/(k*deltaln(T)) in [kW]*1000/([W/m2K]*K) 
    
 % calculate length of Mechanical scraped-surface crystallizer:
 
    length_cry = area_cry/(2*pi*radius);

end
