
       
%%%--------------------% Furnace%------------------------------%%
% This cost curve was developed using Aspen Capital Cost Estimator
% x = duty in kW
% y = Flow rate in m3/h
% direct costs are calcualted in € (2020), Location: Rotterdam


%Limits: y = 180-540m3/h x = 100-1000kW

function direct_costs = Direct_costs_furnace_v3(heating_duty,flow_rate)

flow_rate = flow_rate./3.6; % transform in l/s


a =    2.37e+05;  
b =        6686; 
c =       7.102; 
m =       1.988;
n =      0.5224; 
    
direct_costs = a+ b.*heating_duty.^n +c.*flow_rate.^m;

end