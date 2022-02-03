
%%%--------------------% Ball mill%------------------------------%%
% This cost curve was developed using ball mill and the Aspen Capital Cost Estimator
% x = duty in kW
% direct costs are calcualted in € (2020).

% Only applicable within these lmits, X = 290-21540 [kW]

function direct_cost_ball_mill = direct_cost_ball_mill(x)

xlim = 100;
if x< xlim
    x= xlim;
end

a =   1.233e+05; 
b =  -9.006e+05;
n =      0.4977; 

direct_cost_ball_mill = a.*x.^n+b;


end