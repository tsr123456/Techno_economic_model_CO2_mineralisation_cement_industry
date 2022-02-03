
%%%--------------------% Ball mill%------------------------------%%
% This cost curve was developed using ball mill and the Aspen Capital Cost Estimator
% x = duty in kW
% direct costs are calcualted in € (2020).

%Limtis: X = 290-21540 kW

function direct_costs = Direct_costs_ball_mill_v3(x)

a =   1.233e+05; 
b =  -9.006e+05;
n =      0.4977; 

direct_costs = a.*x.^n+b;

end





