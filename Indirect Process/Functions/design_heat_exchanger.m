%-----------------%% Equipment Costs Heat Exchanger %%--------------------%
% The inputs for this function is the following:
%t_in_warm; temperature of warm stream in [°C]
%t_out_warm;temperature of warm stream in [°C]
%t_in_cold;temperature of cold stream in [°C]
%t_out_cold;temperature of cold stream in [°C]
%q; heating that needs to be transfered in [MW]
%k; heat transmission coefficient in [W/m2K]
%max_area_heat_exchanger; maximum area for a single heat exchnager in [m2]
%Factors_capex_heat_exchanger; Regression factors for the calculation of
%equipment costs. 
 
%% Calculation-------------------------------------------------------------

function [numbr_he,area_he_maxium_size] = design_heat_exchanger (t_in_warm, t_out_warm,t_in_cold,t_out_cold,q,k, max_area_heat_exchanger)
  %k_he = 1000; %in [W/m2K]

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
    area_he = abs(q*1000 / (k*log_dif_Temp));% Q/(k*deltaln(T)) in [kW]*1000/([W/m2K]*K) 

    if area_he > max_area_heat_exchanger
        numbr_he =1;
        area_he_maxium_size = area_he;
        while area_he_maxium_size > max_area_heat_exchanger
            numbr_he = numbr_he+1;
            area_he_maxium_size = area_he/numbr_he;
        end

    else
        numbr_he=1;
        area_he_maxium_size = area_he;
    end

end
