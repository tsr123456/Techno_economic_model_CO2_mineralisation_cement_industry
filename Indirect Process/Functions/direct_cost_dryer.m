 %%%--------------------% Rotary Dryer%------------------------------%%
% This cost curve was developed using Aspen Capital Cost Estimator
% direct costs are calcualted in € (2020), for a indirect dryer and SS as
% material
% Input: Area in [m]

% Only applicable within these limits, area = 10-185m2

function [numbr_dry, direct_cost_dry] = direct_cost_dryer(area)

max_area = 185;
numbr_dry = 1;

if (area>max_area)
    
    while(area>max_area) %|| (area>max_area)
        numbr_dry = numbr_dry + 1;
        area = area/numbr_dry;
    end
   
end

%%% Calculate Equipment costs:
%Coefficients (with 95% confidence bounds):
       a_eq =        69.7;
       b_eq =        6513;
       n_eq =      0.9392;

equipment_cost_dry = a_eq+ b_eq.*area.^n_eq;


%%% Add Material factor for SS instead of CS: 
equipment_cost_dry = equipment_cost_dry.*(1.56/1.45);

%Coefficients (with 95% confidence bounds):
       a_er =        1500;
       b_er =        5053 ;
       n_er =      0.7328;
       
errection_costs = a_er+ b_er.*area.^n_er;

direct_cost_dry = equipment_cost_dry + errection_costs;

end