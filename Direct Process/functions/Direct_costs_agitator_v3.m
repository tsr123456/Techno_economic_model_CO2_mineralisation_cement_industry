%%%-------------------------% Agitator%------------------------------%%
% This cost curve was developed using centrifugal pumps and the Aspen Capital Cost Estimator
% x = duty in kW
% direct costs are calcualted in € (2020).

% Limits: X = 10-75kW
function direct_costs = Direct_costs_agitator_v3(x)

a =         909; 
b =   1.753e+04;  
n =       1.084; 
     
direct_costs = a.*x.^n+b;

end


