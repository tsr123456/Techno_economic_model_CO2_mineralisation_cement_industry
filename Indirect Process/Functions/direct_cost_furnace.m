%%%--------------------% Furnace%------------------------------%%
% This cost curve was developed using Aspen Capital Cost Estimator
% x = duty in kW
% y = Flow rate in m3/h
% direct costs are calcualted in € (2020)


% Only applicable within these limits, y = 180-540m3/h x = 100-1000 [kW]

function direct_cost_furnace = direct_cost_furnace(heat_duty,flow_rate)

flow_rate = flow_rate./3.6; % transform in l/s


a =    2.37e+05;  
b =        6686; 
c =       7.102; 
m =       1.988;
n =      0.5224; 
    
direct_cost_furnace = a+ b.*heat_duty.^n +c.*flow_rate.^m;

end